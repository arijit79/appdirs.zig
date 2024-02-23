const std = @import("std");
const builtin = @import("builtin");

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

pub fn getPath(comptime D: type, dir: D) []const u8 {
    _ = dir;
    switch (builtin.os.tag) {
        .linux => return "linux",
        .windows => return "windows",
        .macos => return "macos",
        else => return "unknown",
    }
}

test "Test getPath" {
    try std.testing.expectEqualStrings("linux", getPath(UserDirs, UserDirs.home));
}
