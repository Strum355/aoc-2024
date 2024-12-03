const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();

    var file = try std.fs.cwd().openFile("day1.txt", .{});
    defer file.close();

    var leftside = std.ArrayList(u32).init(alloc);
    var rightside = std.ArrayList(u32).init(alloc);
    defer leftside.deinit();
    defer rightside.deinit();

    var buf: [14]u8 = undefined;
    while (try file.reader().readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const l = try std.fmt.parseInt(u32, line[0..5], 10);
        try leftside.append(l);
        const r = try std.fmt.parseInt(u32, line[8..], 10);
        try rightside.append(r);
    }

    std.sort.heap(u32, leftside.items, {}, std.sort.asc(u32));
    std.sort.heap(u32, rightside.items, {}, std.sort.asc(u32));

    // PART 1

    var total_distance: u64 = 0;
    for (0.., leftside.items) |i, l| {
        const r = rightside.items[i];
        total_distance += @abs(@as(i64, l) - @as(i64, r));
    }
    std.debug.print("{d}\n", .{total_distance});

    // PART 2

    var right_set = std.AutoHashMap(u32, u32).init(alloc);
    for (rightside.items) |r| {
        const entry = try right_set.getOrPutValue(r, 0);
        entry.value_ptr.* += 1;
    }
    var similarity: u32 = 0;
    for (leftside.items) |l| {
        const count = right_set.get(l) orelse continue;
        similarity += count * l;
    }
    std.debug.print("{d}\n", .{similarity});
}
