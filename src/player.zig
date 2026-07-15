const std = @import("std");

pub const Coefficients = struct {
    trust: f32 = 0.5,
    defection: f32 = 0.5,
    alpha: f32 = 0.3,
    mut_step: f32 = 0.02,
    longevity: u32 = 10,

    age: u32 = 0,
    karma: f32 = 0.5,

    const Self = @This();

    pub fn initRandom(rand: std.Random) Self {
        return .{
            .trust = rand.float(f32),
            .defection = rand.float(f32),
            .alpha = rand.float(f32),
            .mut_step = 0.005 + (rand.float(f32) * 0.075),
            .longevity = rand.intRangeAtMost( u32, 5, 15),
            .karma = 0.5,
        };
    }
    pub fn procreate(parent: *const Self) Self {
        return .{
            .trust = mutate(parent.trust),
            .defection = mutate(parent.defection),
            .alpha = mutate(parent.alpha),
            .mut_step = mutate(parent.mut_step),
            .karma = mutate(parent.karma),
            .longevity = mutate(parent.karma),
            .age = 0,
        };
    }
    fn mutate(self: *Self, field: f32) f32 {
        _ = self;
        _ = field;
        return 0.0;
    }
};

pub const Player = struct {
    id: u32,
    coefs: Coefficients,

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
    pub fn initRandom(id: u32) Self {
        return initWithCoefs(id, Coefficients.initRandom());
    }
    pub fn procreate(self: *const Self, id: u32) Self {
        return initRandom(self.id + id);
    }
};
