const std = @import("std");
const builtin = @import("builtin");
const Allocator = std.mem.Allocator;

const oshandler = switch (builtin.os.tag) {
    .linux => @import("linux.zig"),
    else => unreachable,
};

pub const AppDirs = enum {
    home,
    cache,
    config,
    local_config,
    data,
    data_local,
    executable,
    preference,
    runtime,
    state,
};

pub const UserDirs = enum {
    home,
    audio,
    desktop,
    documents,
    downloads,
    fomt,
    pictures,
    public,
    templates,
    videos,
};

pub fn getPath(alloc: Allocator, comptime D: type, dir: D) !?[]const u8 {
    _ = dir;
    return try oshandler.home_dir(alloc);
}

test "Test getPath" {
    var allocator = std.testing.allocator;
    var result = try getPath(allocator, UserDirs, UserDirs.home);
    defer allocator.free(result.?);
    std.debug.print("{s}\n", .{result.?});
}
