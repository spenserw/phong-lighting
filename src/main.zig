const std = @import("std");
const phong_lighting = @import("phong_lighting");

pub fn main() !void {
    phong_lighting.initWindow(1920, 3240, "Phong Lighting");

    try phong_lighting.gameLoop();
}
