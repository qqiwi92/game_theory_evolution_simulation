const std = @import("std");

const Player = struct {
    var c_trust: f32 = 0.5;
    var c_carma: f32 = 0.5;
    var c_defection: f32 = 0.5;

    const Self = @This();

    pub fn init() Self {
        return .{
            .c_trust = 0.5,
            .c_carma = 0.5,
            .c_defection = 0.5,
        };
    }
};
