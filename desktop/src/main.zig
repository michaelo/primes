const std = @import("std");
const core = @import("core");

pub fn main() anyerror!void {
    std.log.info("All your codebase are belong to us.", .{});

    try core.core();
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
