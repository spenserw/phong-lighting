//! By convention, root.zig is the root source file when making a library.
const std = @import("std");
const rl = @import("raylib");

const GLSL_VERSION = 330;

var movingLight = false;

pub fn initWindow(width: u16, height: u16, title: [:0]const u8) void {
    rl.setConfigFlags(.{ .window_resizable = true, .fullscreen_mode = true });
    rl.initWindow(width, height, title);
    rl.maximizeWindow();
    rl.disableCursor();
}

pub fn gameLoop() !void {
    defer rl.closeWindow(); // Close window and OpenGL context

    const shader = try rl.loadShader("resources/shaders/glsl330/phong.vert", "resources/shaders/glsl330/phong.frag");
    defer rl.unloadShader(shader);

    var playerPosition = rl.Vector3{ .x = 0, .y = 1.0, .z = 2.0 };
    const playerColor = rl.Vector3{ .x = 0.92, .y = 0.55, .z = 0.21 };

    const playerMesh = rl.genMeshCube(1.0, 2.0, 1.0);
    const playerModel = try rl.loadModelFromMesh(playerMesh);
    playerModel.materials[0].shader = shader;

    const otherMesh = rl.genMeshKnot(2.0, 3.0, 16, 128);
    const otherModel = try rl.loadModelFromMesh(otherMesh);
    otherModel.materials[0].shader = shader;

    // Define the camera to look into our 3d world
    var camera = rl.Camera3D{
        .position = rl.Vector3{ .x = 0.0, .y = 10.0, .z = 10.0 },
        .target = playerPosition,
        .up = rl.Vector3{ .x = 0.0, .y = 1.0, .z = 0.0 },
        .fovy = 45.0,
        .projection = .perspective,
    };
    const cameraPosLoc = rl.getShaderLocation(shader, "cameraPosition");

    var lightPosition = rl.Vector3{ .x = 4.0, .y = 1.0, .z = 4.0 };
    const lightPosLoc = rl.getShaderLocation(shader, "lightPosition");
    const lightColorLoc = rl.getShaderLocation(shader, "lightColor");
    const lightColor = rl.Vector3{ .x = 1.0, .y = 1.0, .z = 1.0 };
    rl.setShaderValue(shader, lightColorLoc, &lightColor, .vec3);

    const playerColorLoc = rl.getShaderLocation(shader, "objectColor");
    rl.setShaderValue(shader, playerColorLoc, &playerColor, .vec3);

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    while (!rl.windowShouldClose()) {
        rl.updateCamera(&camera, .first_person);

        // Move player
        if (movingLight) {
            if (rl.isKeyDown(.right)) lightPosition.x += 0.2;
            if (rl.isKeyDown(.left)) lightPosition.x -= 0.2;
            if (rl.isKeyDown(.down)) lightPosition.z += 0.2;
            if (rl.isKeyDown(.up)) lightPosition.z -= 0.2;
            if (rl.isKeyDown(.left_shift)) lightPosition.y += 0.2;
            if (rl.isKeyDown(.left_control)) lightPosition.y -= 0.2;
        } else {
            if (rl.isKeyDown(.right)) playerPosition.x += 0.2;
            if (rl.isKeyDown(.left)) playerPosition.x -= 0.2;
            if (rl.isKeyDown(.down)) playerPosition.z += 0.2;
            if (rl.isKeyDown(.up)) playerPosition.z -= 0.2;
            if (rl.isKeyDown(.left_shift)) playerPosition.y += 0.2;
            if (rl.isKeyDown(.left_control)) playerPosition.y -= 0.2;
        }

        camera.target = playerPosition;
        rl.setShaderValue(shader, lightPosLoc, &lightPosition, .vec3);
        rl.setShaderValue(shader, cameraPosLoc, &camera.position, .vec3);

        if (rl.isKeyDown(.space)) movingLight = !movingLight;

        rl.beginDrawing();
        defer rl.endDrawing();

        // 3D
        {
            rl.beginMode3D(camera);
            defer rl.endMode3D();

            rl.clearBackground(.black);
            rl.drawGrid(10, 1.0);
            {
                rl.beginShaderMode(shader);
                defer rl.endShaderMode();

                // rl.drawModel(playerModel, playerPosition, 1.0, rl.colorFromNormalized(vec3ToVec4(playerColor)));
                rl.drawModel(otherModel, playerPosition, 1.0, rl.colorFromNormalized(vec3ToVec4(playerColor)));
            }

            rl.drawSphere(lightPosition, 0.5, rl.colorFromNormalized(vec3ToVec4(lightColor)));
        }

        const controllingText = if (movingLight) "Light" else "Player";
        rl.drawText(controllingText, 0, 0, 8, .black);
    }
}

fn vec3ToVec4(vec3: rl.Vector3) rl.Vector4 {
    return rl.Vector4{
        .x = vec3.x,
        .y = vec3.y,
        .z = vec3.z,
        .w = 1.0,
    };
}
