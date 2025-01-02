const input = @embedFile("day2");
const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();

    var iter = std.mem.tokenizeScalar(u8, input, '\n');

    // PART 1

    var safe_levels: usize = 0;
    while (iter.next()) |line| {
        var lineiter = std.mem.splitScalar(u8, line, ' ');
        var lineitems = std.ArrayList(u8).init(alloc);
        while (lineiter.next()) |l| {
            const level = try std.fmt.parseInt(u8, l, 10);
            try lineitems.append(level);
        }

        if (is_valid(lineitems.items)) {
            safe_levels += 1;
        }
    }

    std.debug.print("{d}\n", .{safe_levels});

    // PART 2

    iter = std.mem.tokenizeScalar(u8, input, '\n');

    safe_levels = 0;
    outer: while (iter.next()) |line| {
        var lineiter = std.mem.splitScalar(u8, line, ' ');
        var lineitems = std.ArrayList(u8).init(alloc);
        while (lineiter.next()) |l| {
            const level = try std.fmt.parseInt(u8, l, 10);
            try lineitems.append(level);
        }

        if (is_valid(lineitems.items)) {
            safe_levels += 1;
        } else {
            for (lineitems.items, 0..) |_, i| {
                var clone = try lineitems.clone();
                _ = clone.orderedRemove(i);
                if (is_valid(clone.items)) {
                    safe_levels += 1;
                    continue :outer;
                }
            }
            std.debug.print("{any} still invalid\n", .{lineitems.items});
        }
    }

    std.debug.print("{d}\n", .{safe_levels});    
}

fn is_valid(levels: []const u8) bool {
    if (!std.sort.isSorted(u8, levels, {}, std.sort.asc(u8)) and !std.sort.isSorted(u8, levels, {}, std.sort.desc(u8))) {
        return false;
    }

    var listiter = std.mem.window(u8, levels, 2, 1);
    while (listiter.next()) |pair| {
        if (pair[0] == pair[1]) {
            return false;
        } 
        if (pair[0] > pair[1] and pair[0] - pair[1] > 3) {
            return false;
        }
        if (pair[0] < pair[1] and pair[1] - pair[0] > 3) {
            return false;
        }
    }
    return true;
}