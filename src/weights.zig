const std = @import("std");

pub const Choice = enum(u1) {
    defect = 0,
    cooperate = 1,
};

pub const Payoff = struct {
    p1: i32,
    p2: i32,
};

pub const payoff_matrix = [2][2]Payoff{
    .{
        .{ .p1 = -1, .p2 = -1 },
        .{ .p1 = 5, .p2 = -1 },
    },
    .{
        .{ .p1 = -1, .p2 = 5 },
        .{ .p1 = 4, .p2 = 4 },
    },
};

pub fn getPayoff(p1_choice: Choice, p2_choice: Choice) Payoff {
    return payoff_matrix[@intFromEnum(p1_choice)][@intFromEnum(p2_choice)];
}
