const std = @import("std");
const Choice = @import("weights.zig").Choice;

const Random = std.Random;

pub const Coefficients = struct {
    trust: f32 = 0.5,
    defection: f32 = 0.5,
    alpha: f32 = 0.3,

    mut_step: f32 = 0.02,
    longevity: u32 = 10,

    const Self = @This();

    pub fn initRandom(rand: Random) Self {
        return .{
            .trust = rand.float(f32),
            .defection = rand.float(f32),
            .mut_step = 0.005 + (rand.float(f32) * 0.075),
            .longevity = rand.intRangeAtMost(u32, 5, 15),
        };
    }

    pub fn procreate(parent: *const Self, rand: Random) Self {
        const step = parent.mut_step;
        return .{
            .trust = mutateFloat(parent.trust, step, rand),
            .defection = mutateFloat(parent.defection, step, rand),
            .mut_step = @max(0.001, mutateFloat(parent.mut_step, step, rand)),
            .longevity = mutateInt(parent.longevity, step, rand, 5, 50),
        };
    }

    fn mutateFloat(val: f32, step: f32, rand: Random) f32 {
        const noise = rand.floatNorm(f32) * step;
        return @max(0.0, @min(1.0, val + noise));
    }

    fn mutateInt(val: u32, step: f32, rand: Random, min: u32, max: u32) u32 {
        const noise = rand.floatNorm(f32) * @as(f32, @floatFromInt(val)) * step;
        const delta = @as(i32, @intFromFloat(@round(noise)));
        const new_val = @as(i32, @intCast(val)) + delta;
        return @intCast(@max(@as(i32, @intCast(min)), @min(@as(i32, @intCast(max)), new_val)));
    }
};

pub const Player = struct {
    id: u32,
    coefs: Coefficients,

    age: u32 = 0,
    karma: f32 = 0.5,
    score: f32 = 10.0,
    
    const Self = @This();

    pub fn init(id: u32) Self {
        return .{
            .id = id,
            .coefs = .{},
        };
    }

    pub fn initWithCoefs(id: u32, coefs: Coefficients) Self {
        return .{
            .id = id,
            .coefs = coefs,
        };
    }

    pub fn initRandom(id: u32, rand: Random) Self {
        return initWithCoefs(id, Coefficients.initRandom(rand));
    }

    pub fn procreate(self: *const Self, child_id: u32, rand: Random) Self {
        return initWithCoefs(child_id, self.coefs.procreate(rand));
    }
    pub fn fight(self: *Self, rand: std.Random, other: *const Self) Choice {
        const verdict = self.coefs.trust * other.karma + (1 - self.coefs.defection) * (1 - other.karma);
        return if (rand.float(f32) < verdict) Choice.cooperate else Choice.defect;
    }
    pub fn growOlder(self: *Self) void {
        self.age += 1;
    }
    pub fn resetAsDescendant(self: *Self, parent_coefs: *const Coefficients, rand: Random) void {
        self.coefs = parent_coefs.procreate(rand);

        self.age = 0;
        self.karma = 0.5;
        self.score = 5.0;
    }
    pub fn updateKarma(self: *Self, choice: Choice) void {
        const choice_val = @intFromEnum(choice);
        self.karma = choice_val * self.coefs.alpha + self.karma * (1 - self.coefs.alpha);
    }
};
