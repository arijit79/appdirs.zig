const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn home_dir(alloc: Allocator) !?[]const u8 {
    var env_map = try std.process.getEnvMap(alloc);
    defer env_map.deinit();
    var home = env_map.get("HOME") orelse return null;
    return try alloc.dupe(u8, home);
}
