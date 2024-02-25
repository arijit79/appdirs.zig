const std = @import("std");
const builtin = @import("builtin");
const Allocator = std.mem.Allocator;

const oshandler = switch (builtin.os.tag) {
    .linux => @import("linux.zig"),
    else => unreachable,
};

pub const AppDirs = struct {
    const Self = @This();
    alloc: Allocator,
    // std_dirs: StandardDirs,
    user_dirs: UserDirs,

    fn getPath(comptime D: type, dir: D) !?[]const u8 {
        _ = dir;
    }

    fn init(alloc: Allocator) !Self {
        return Self{ .alloc = alloc, .user_dirs = try oshandler.extractOsSpecificPaths(alloc) };
    }

    fn deinit(self: Self) void {
        self.user_dirs.deinit();
    }
};

pub const StandardDirs = struct {
    home: ?[]const u8,
    cache: ?[]const u8,
    config: ?[]const u8,
    local_config: ?[]const u8,
    data: ?[]const u8,
    data_local: ?[]const u8,
    executable: ?[]const u8,
    preference: ?[]const u8,
    runtime: ?[]const u8,
    state: ?[]const u8,

    alloc: Allocator,

    fn deinit(self: @This()) void {
        comptime var fields = @typeInfo(UserDirs).Struct.fields;

        inline for (fields) |field| {
            if (field.type == Allocator) {
                continue;
            }
            if (@field(self, field.name)) |f| {
                self.alloc.free(f);
            }
        }
    }
};

pub const UserDirs = struct {
    home: ?[]const u8,
    music: ?[]const u8,
    desktop: ?[]const u8,
    documents: ?[]const u8,
    downloads: ?[]const u8,
    fomts: ?[]const u8,
    pictures: ?[]const u8,
    public: ?[]const u8,
    templates: ?[]const u8,
    videos: ?[]const u8,

    alloc: Allocator,

    fn deinit(self: @This()) void {
        comptime var fields = @typeInfo(UserDirs).Struct.fields;

        inline for (fields) |field| {
            if (field.type == Allocator) {
                continue;
            }
            if (@field(self, field.name)) |f| {
                self.alloc.free(f);
            }
        }
    }
};

pub fn copyIfPresent(alloc: Allocator, val: ?[]const u8, default: ?[]const u8) !?[]const u8 {
    if (val) |inner| {
        return try alloc.dupe(u8, inner);
    } else if (default) |d| {
        return try alloc.dupe(u8, d);
    } else {
        return null;
    }
}

test "Test getPath" {
    var allocator = std.testing.allocator;
    var appdirs = try AppDirs.init(allocator);
    defer appdirs.deinit();
    // var result = try getPath(allocator, UserDirs, UserDirs.home);
    // defer allocator.free(result.?);
    std.debug.print("{s}\n", .{appdirs.user_dirs.downloads.?});
}
