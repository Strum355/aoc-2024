const std = @import("std");
const input = @embedFile("day4");

pub fn main() !void {
    // PART 1

    // excl newline
    const linelength = std.mem.indexOfScalar(u8, input, '\n').?;

    const lm: Linemanager = .{.linelength = @intCast(linelength)};

    var count: usize = 0;
    for (input, 0..) |char, i| {
        if (char == '\n' or char != 'X') continue;
        inline for (std.meta.fields(Direction)) |f| {
            do: {
                var res = lm.get_letter(i, @enumFromInt(f.value)) catch break :do;
                if (res.char == 'M') {
                    res = lm.get_letter(res.offset, @enumFromInt(f.value)) catch break :do;
                    if (res.char == 'A') {
                        res = lm.get_letter(res.offset, @enumFromInt(f.value)) catch break :do;
                        if (res.char == 'S') {
                            count += 1;
                        }
                    }
                }
            }
        }
    }

    std.debug.print("{d}\n", .{count});

    // PART 2
    count = 0;

    for (input, 0..) |char, i| {
        if (char == '\n' or char != 'A') continue;
        const topl = (lm.get_letter(i, Direction.topl) catch continue).char;
        const topr = (lm.get_letter(i, Direction.topr) catch continue).char;
        const botl = (lm.get_letter(i, Direction.botl) catch continue).char;
        const botr = (lm.get_letter(i, Direction.botr) catch continue).char;
        const valid = ((topl == 'M' and botr == 'S') or (topl == 'S' and botr == 'M'))
            and ((topr == 'M' and botl == 'S') or (topr == 'S' and botl == 'M'));
        if (valid) {
            count += 1;
        }
    }
    std.debug.print("{d}", .{count});
}

const Direction = enum {
    topl, top,    topr, 
    left,         right,
    botl, bottom, botr
};

const Linemanager = struct {
    linelength: isize,

    pub const Result = struct {
        char: u8,
        offset: usize,
    };

    pub fn get_letter(self: Linemanager, cur_pos: usize, dir: Direction) error{OutOfBounds}!Result {
        const icur_pos: isize = @intCast(cur_pos);
        const offset = switch (dir) {
            Direction.topl => icur_pos - self.linelength - 2,
            Direction.top => icur_pos - self.linelength - 1,
            Direction.topr => icur_pos - self.linelength,
            Direction.left => icur_pos - 1,
            Direction.right => icur_pos + 1,
            Direction.botl => icur_pos + self.linelength,
            Direction.bottom => icur_pos + self.linelength + 1,
            Direction.botr => icur_pos + self.linelength + 2,
        };
        if (offset < 0 or offset > input.len or input[@intCast(offset)] == '\n') {
            return error.OutOfBounds;
        }
        return .{
            .char = input[@intCast(offset)],
            .offset = @intCast(offset),
        };
    }
};