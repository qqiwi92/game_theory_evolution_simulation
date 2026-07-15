const std = @import("std");
const Simulation = @import("simulation.zig").Simulation;
pub fn main() !void {
    var prng = std.Random.DefaultPrng.init(1337);
    const rand = prng.random();

    var gpa = std.heap.DebugAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const population = 100;
    var sim = try Simulation.init(allocator, population, rand);
    sim.deinit();
}
