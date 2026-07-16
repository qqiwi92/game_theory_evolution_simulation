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
            var first: *Player = &self.population.items[self.ids.items[i]];
            var second: *Player = &self.population.items[self.ids.items[i + 1]];

            const first_verdict = first.fight(self.rand, second);
            const second_verdict = second.fight(self.rand, first);

            const payoff = Weights.getPayoff(first_verdict, second_verdict);

            first.score += payoff.p1;
            second.score += payoff.p2;

            first.growOlder();
            second.growOlder();
        }
    }

    pub fn cullTheWeak(self: *Self, elimination_factor: u32) void {
        std.mem.sort(Player, self.population.items, {}, sortPlayerDescComparatorAsc);

        const players = self.population.items;
        const size = players.len;
        const eliminated = size / elimination_factor;

        for (0..eliminated) |i| {
            players[i].resetAsDescendant(&players[size - i - 1].coefs, self.rand);
        }
    }

    pub fn logEpoch(self: *Self, epoch: usize, writer: *std.Io.Writer) !void {
        for (self.population.items) |p| {
            try writer.print("{d},{d},{d:.4},{d:.4},{d:.4},{d:.4}\n", .{
                epoch,
                p.id,
                p.coefs.trust,
                p.coefs.defection,
                p.coefs.alpha,
                p.karma,
            });
        }
    }

    pub fn deinit(self: *Self) void {
        self.population.deinit(self.allocator);
        self.ids.deinit(self.allocator);
    }
    fn sortPlayerDescComparatorAsc(_: void, a: Player, b: Player) bool {
        return a.score < b.score;
    }
};
