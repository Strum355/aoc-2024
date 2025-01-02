const input = @embedFile("day3");
const std = @import("std");

pub fn main() !void {
    // PART 1
     
    var muliter = std.mem.tokenizeSequence(u8, input, "mul(");
    _ = muliter.next(); // skip everything up to the first mul(
    var total: usize = 0;
    while (muliter.next()) |rest| {
        const endindex = std.mem.indexOfScalar(u8, rest, ')') orelse continue;
        const restend = rest[0..endindex];
        const commaindex = std.mem.indexOfScalar(u8, restend, ',') orelse continue;
        const firstdigit = std.fmt.parseInt(usize, rest[0..commaindex], 10) catch continue;
        const seconddigit = std.fmt.parseInt(usize, rest[commaindex+1..endindex], 10) catch continue;
        total += firstdigit * seconddigit;
    }
    std.debug.print("{d}\n", .{total});

    // PART 2

    muliter.reset();
    _ = muliter.next(); // skip everything up to the first mul(
    total = 0;
    while (muliter.next()) |rest| {
        const dont = std.mem.lastIndexOf(u8, input[0..muliter.index-rest.len], "don't()");
        const do = std.mem.lastIndexOf(u8, input[0..muliter.index-rest.len], "do()");
        if (
            (do == null and dont == null) or
            (do != null and dont == null) or 
            (do != null and do.? > dont.?)
        ) {
            const endindex = std.mem.indexOfScalar(u8, rest, ')') orelse continue;
            const restend = rest[0..endindex];
            const commaindex = std.mem.indexOfScalar(u8, restend, ',') orelse continue;
            const firstdigit = std.fmt.parseInt(usize, rest[0..commaindex], 10) catch continue;
            const seconddigit = std.fmt.parseInt(usize, rest[commaindex+1..endindex], 10) catch continue;
            total += firstdigit * seconddigit;
        }
    }
    std.debug.print("{d}\n", .{total});
}