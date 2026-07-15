const std = @import("std");
const player = @import("player.zig");
pub fn main() !void {
    var prng = std.Random.DefaultPrng.init(1337);
    const rand = prng.random();
    const p = player.Player.initRandom(0, rand);
    _ = p.procreate(2, rand);
}
