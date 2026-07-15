const std = @import("std");

pub const Coefficients = struct {
    trust: f32 = 0.5,
    defection: f32 = 0.5,
    alpha: f32 = 0.3,
    mut_step: f32 = 0.02,

    karma: f32 = 0.5,

    const Self = @This();

    pub fn initRandom() Self {
        const rand = std.crypto.random;
        return .{
            .trust = rand.float(f32),
            .karma = 0.5,
            .defection = rand.float(f32),
            .alpha = rand.float(f32),
            .mut_step = 0.005 + (rand.float(f32) * 0.075),
        };
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
};
