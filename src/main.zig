const std = @import("std");
const phong_lighting = @import("phong_lighting");

pub fn main() !void {
    phong_lighting.initWindow(1920, 1080, "Phong Lighting");

    try phong_lighting.gameLoop();
}
