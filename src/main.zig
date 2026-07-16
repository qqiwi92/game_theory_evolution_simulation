const std = @import("std");
const Simulation = @import("simulation.zig").Simulation;
pub fn main(init: std.process.Init) !void {
    const population = 200;
    const epochs = 20000;

    var prng = std.Random.DefaultPrng.init(1337);
    const rand = prng.random();

    var gpa = std.heap.DebugAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const io = init.io;
    const cwd = std.Io.Dir.cwd();
    const file = try cwd.createFile(io, "simulation_log.csv", .{});
    defer file.close(io);
    var writer_buf: [1024 * 64]u8 = undefined;
    var buf_writer = file.writer(io, &writer_buf);
    const writer = &buf_writer.interface;
    try writer.print("epoch,player_id,trust,defection,age,karma\n", .{});
    defer buf_writer.flush() catch {};

    var sim = try Simulation.init(allocator, population, rand);
    defer sim.deinit();
    try sim.fillWithRandoms();

    for (0..epochs) |e| {
        try sim.fight();
        sim.cullTheWeak(10);
        if (e % 100 == 0) {
            try sim.logEpoch(e, writer);
        }
    }
    // std.debug.print("{}\n", .{sim.population.items[0]});
    // std.debug.print("{}\n", .{sim.population.items[1]});
}
