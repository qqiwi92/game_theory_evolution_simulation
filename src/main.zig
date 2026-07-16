const std = @import("std");
const Simulation = @import("simulation.zig").Simulation;
pub fn main() !void {
    const population = 100;
    const epochs = 100;

    var prng = std.Random.DefaultPrng.init(1337);
    const rand = prng.random();

    var gpa = std.heap.DebugAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var sim = try Simulation.init(allocator, population, rand);
    defer sim.deinit();
    try sim.fillWithRandoms();

    for (0..epochs) |_| {
        try sim.fight();
        sim.cullTheWeak(10);
    }
    std.debug.print("{}\n", .{sim.population.items[0]});
    std.debug.print("{}\n", .{sim.population.items[1]});
}
