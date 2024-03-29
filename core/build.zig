const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const lib = b.addStaticLibrary("core", "src/main.zig");
    lib.setBuildMode(mode);
    lib.linkSystemLibraryName("SDL2");
    lib.linkSystemLibraryName("SDL2_image");
    lib.linkSystemLibraryName("SDL2_ttf");
    lib.linkLibC();
    const target = b.standardTargetOptions(.{});
    lib.setTarget(target);
    lib.install();

    const main_tests = b.addTest("src/main.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
