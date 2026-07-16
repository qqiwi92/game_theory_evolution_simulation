const std = @import("std");
const Player = @import("player.zig").Player;
const Weights = @import("weights.zig");

pub const Simulation = struct {
    allocator: std.mem.Allocator,
    population: std.ArrayList(Player),
    rand: std.Random,
    ids: std.ArrayList(u32),
    const Self = @This();
    pub fn init(allocator: std.mem.Allocator, init_entity_count: u32, random: std.Random) !Self {
        const population = try std.ArrayList(Player).initCapacity(allocator, init_entity_count);
        var ids = try std.ArrayList(u32).initCapacity(allocator, init_entity_count);

        var i: u32 = 0;
        while (i < init_entity_count) : (i += 1) {
            try ids.append(allocator, i);
        }

        return .{
            .allocator = allocator,
            .population = population,
            .rand = random,
            .ids = ids,
        };
    }
    pub fn fillWithRandoms(self: *Self) !void {
        while (self.population.items.len < self.population.capacity) {
            try self.population.append(self.allocator, Player.initRandom(@intCast(self.population.items.len), self.rand));
        }
    }
    pub fn fight(self: *Self) !void {
        self.rand.shuffle(u32, self.ids.items);

        var i: usize = 0;
        const population = (self.ids.items.len / 2) * 2;
        while (i < population) : (i += 2) {
            var first: *Player = &self.population.items[i];
            var second: *Player = &self.population.items[i + 1];

            const first_verdict = first.fight(self.rand, second);
            const second_verdict = second.fight(self.rand, first);

            const payoff = Weights.getPayoff(first_verdict, second_verdict);

            first.score += payoff.p1;
            second.score += payoff.p2;

            first.growOlder();
            second.growOlder();
        }
    }
    pub fn deinit(self: *Self) void {
        self.population.deinit(self.allocator);
        self.ids.deinit(self.allocator);
    }
};
