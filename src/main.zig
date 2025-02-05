// const std = @import("std");
// const pt: type = @import("pTest");

// pub fn main() !void {
//     // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
//     std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

//     // stdout is for the actual output of your application, for example if you
//     // are implementing gzip, then only the compressed bytes should be sent to
//     // stdout, not any debugging messages.
//     const stdout_file = std.io.getStdOut().writer();
//     var bw = std.io.bufferedWriter(stdout_file);
//     const stdout = bw.writer();

//     try stdout.print("Run `zig build test` to run the tests.\n", .{});

//     try bw.flush(); // don't forget to flush!

//     pt.printTest();

//     const a: u128 = 10;
//     std.debug.print("Variable a {}\n\n",.{a});
// }

// test "simple test" {
//     var list = std.ArrayList(i32).init(std.testing.allocator);
//     defer list.deinit(); //try commenting this out and see if zig detects the memory leak!
//     try list.append(42);
//     try std.testing.expectEqual(@as(i32, 42), list.pop());
// }

const std = @import("std");
const rl = @import("raylib");
const math = @import("utils/math.zig");
const GameSimulation = @import("GameSimulation.zig");

fn TestOnStart() void {
    std.debug.print("Calling test on start", .{});
}

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Our game state
    var gameState = GameSimulation.GameState {};

    // Initialize our game object
    gameState.physicsComponents[0].position =  .{ .x = 400, .y = 200 };


    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        var PressingUp: bool = false;
        var PressingDown: bool = false;
        var PressingLeft: bool = false;
        var PressingRight: bool = false;

        if (rl.isWindowFocused() and rl.isGamepadAvailable(0)) {
            if (rl.isGamepadButtonDown(0, rl.GamepadButton.left_face_up)) {
                PressingUp = true;
            }

            if (rl.isGamepadButtonDown(0, rl.GamepadButton.left_face_down)) {
                PressingDown = true;
            }

            if (rl.isGamepadButtonDown(0, rl.GamepadButton.left_face_left)) {
                PressingLeft = true;
            }

            if (rl.isGamepadButtonDown(0, rl.GamepadButton.left_face_right)) {
                PressingRight = true;
            }
        }

        // Game simulation
        {
            // Update position of object based on player's input
            {
                const entity = &gameState.physicsComponents[0];

                if (PressingUp) {
                    entity.velocity.y = -1;
                }
                else if (PressingDown) {
                    entity.velocity.y = 1;
                }
                else if (PressingLeft) {
                    entity.velocity.x = -1;
                }
                else if (PressingRight) {
                    entity.velocity.x = 1;
                }
                else {
                    entity.velocity.y = 0;
                    entity.velocity.x = 0;
                }
            }

            GameSimulation.UpdateGame(&gameState);
        }

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.white);

        // rl.drawText("Congrats! You created your first window!", 190, 200, 20, rl.Color.brown);

        // Reflect the position of out game object on screen
        rl.drawCircle(gameState.physicsComponents[0].position.x, gameState.physicsComponents[0].position.y, 50, rl.Color.maroon);
        //----------------------------------------------------------------------------------
    }
}
