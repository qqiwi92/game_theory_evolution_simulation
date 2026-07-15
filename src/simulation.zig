const std = @import("std");
const Player = @import("player.zig").Player;
pub const Simulation = struct {
    allocator: std.mem.Allocator,
    arena: std.ArrayList(Player),
    rand: std.Random,
    const Self = @This();
    pub fn init(allocator: std.mem.Allocator, init_entity_count: u32, random: std.Random) !Self {
        const arena = try std.ArrayList(Player).initCapacity(allocator, init_entity_count);
        return .{
            .allocator = allocator,
            .arena = arena,
            .rand = random,
        };
    }
    pub fn deinit(self: * Self) void {
        self.arena.deinit(self.allocator);
    }
};
