const std = @import("std");
const Player = @import("player.zig").Player;
pub const Simulation = struct {
    allocator: std.mem.Allocator,
    population: std.ArrayList(Player),
    rand: std.Random,
    const Self = @This();
    pub fn init(allocator: std.mem.Allocator, init_entity_count: u32, random: std.Random) !Self {
        const world = try std.ArrayList(Player).initCapacity(allocator, init_entity_count);
        return .{
            .allocator = allocator,
            .population = world,
            .rand = random,
        };
    }
    pub fn fillWithRandoms(self: *Self) !void {
        while (self.population.items.len < self.population.capacity) {
            try self.population.append(self.allocator, Player.initRandom(@intCast(self.population.items.len), self.rand));
        }
    }
    pub fn deinit(self: *Self) void {
        self.population.deinit(self.allocator);
    }
};
