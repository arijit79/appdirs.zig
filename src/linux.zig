const std = @import("std");
const Allocator = std.mem.Allocator;
const appdirs = @import("main.zig");

pub fn extractOsSpecificPaths(alloc: Allocator) !appdirs.UserDirs {
    var env_map = try std.process.getEnvMap(alloc);
    defer env_map.deinit();

    var user_drs = appdirs.UserDirs{
        .home = try appdirs.copyIfPresent(alloc, env_map.get("HOME")),
        .audio = null,
        .desktop = null,
        .documents = null,
        .downloads = null,
        .fomt = null,
        .pictures = null,
        .public = null,
        .templates = null,
        .videos = null,
        .alloc = alloc,
    };
    return user_drs;
}

pub fn home_dir(alloc: Allocator) !?[]const u8 {
    var env_map = try std.process.getEnvMap(alloc);
    defer env_map.deinit();
    var home = env_map.get("HOME") orelse return null;
    return try alloc.dupe(u8, home);
}
