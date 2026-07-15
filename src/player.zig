const std = @import("std");

pub const Coefficients = struct {
    trust: f32 = 0.5,
    carma: f32 = 0.5,
    defection: f32 = 0.5,
    
    pub fn initRandom() Coefficients {
        const rand = std.crypto.random;
        return Coefficients{
            .trust = rand.float(f32),
            .carma = rand.float(f32),
            .defection = rand.float(f32),
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
    pub fn initRandom(id: u32) Self{
        return initWithCoefs(id, Coefficients.initRandom());
    }
};
