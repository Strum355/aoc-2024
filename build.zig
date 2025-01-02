const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    try create_day(b, "day1", target, optimize);
    try create_day(b, "day2", target, optimize);
    try create_day(b, "day3", target, optimize);
    try create_day(b, "day4", target, optimize);
}

fn create_day(b: *std.Build, day: []const u8, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) !void {
    const exe = b.addExecutable(.{
        .name = day,
        .root_source_file = b.path(try std.fmt.allocPrint(b.allocator, "src/{s}.zig", .{day})),
        .target = target,
        .optimize = optimize,
    });

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    exe.root_module.addAnonymousImport(day, .{
        .root_source_file = .{
            .cwd_relative = try std.fmt.allocPrint(b.allocator, "{s}.txt", .{day}),
        }
    });
    const run_step = b.step(day, "");
    run_step.dependOn(&run_cmd.step);
}