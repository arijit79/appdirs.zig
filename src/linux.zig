const std = @import("std");
const Allocator = std.mem.Allocator;
const appdirs = @import("main.zig");

pub fn extractOsSpecificPaths(alloc: Allocator) !appdirs.UserDirs {
    var env_map = try std.process.getEnvMap(alloc);
    defer env_map.deinit();

    var data_dir = env_map.get("XDG_DATA_DIR");
    var fonts_dir = if (data_dir) |dd| {
        return dd ++ "/fonts";
    } else {
        return null;
    };

    var user_drs = appdirs.UserDirs{
        .home = try appdirs.copyIfPresent(alloc, env_map.get("HOME"), null),
        .desktop = try appdirs.copyIfPresent(alloc, env_map.get("XDG_DESKTOP_DIR"), "~/Desktop"),
        .documents = try appdirs.copyIfPresent(alloc, env_map.get("XDG_DOCUMENTS_DIR"), "~/Documents"),
        .downloads = try appdirs.copyIfPresent(alloc, env_map.get("XDG_DOWNLOAD_DIR"), "~/Downloads"),
        .fomts = try appdirs.copyIfPresent(alloc, fonts_dir, "~/.local/share/fonts"),
        .music = try appdirs.copyIfPresent(alloc, env_map.get("XDG_MUSIC_DIR"), "~/Music"),
        .pictures = try appdirs.copyIfPresent(alloc, env_map.get("XDG_PICTURES_DIR"), "~/Pictures"),
        .public = try appdirs.copyIfPresent(alloc, env_map.get("XDG_PUBLICSHARE_DIR"), "~/Public"),
        .templates = try appdirs.copyIfPresent(alloc, env_map.get("XDG_TEMPLATES_DIR"), "~/Templates"),
        .videos = try appdirs.copyIfPresent(alloc, env_map.get("XDG_VIDEOS_DIR"), "~/Videos"),
        .alloc = alloc,
    };
    return user_drs;
}
