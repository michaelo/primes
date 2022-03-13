const std = @import("std");
const testing = std.testing;
const c = @cImport({
    @cInclude("SDL2/SDL.h");
    @cInclude("SDL2/SDL_image.h");
});
const assert = std.debug.assert;

// Will later have to create a c-callable wrapper for ios and such
pub fn core() anyerror!void {
    // Main entry point to start SDL application
    std.debug.print("core lib here!\n", .{});

    if (c.SDL_Init(c.SDL_INIT_VIDEO) != 0) {
        c.SDL_Log("Unable to initialize SDL: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    }
    defer c.SDL_Quit();

    const screen = c.SDL_CreateWindow("Primes!", c.SDL_WINDOWPOS_UNDEFINED, c.SDL_WINDOWPOS_UNDEFINED, 600, 800, c.SDL_WINDOW_OPENGL) orelse
        {
        c.SDL_Log("Unable to create window: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    };
    defer c.SDL_DestroyWindow(screen);

    const renderer = c.SDL_CreateRenderer(screen, -1, 0) orelse {
        c.SDL_Log("Unable to create renderer: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    };
    defer c.SDL_DestroyRenderer(renderer);

    var tmpSurface: *c.SDL_Surface  = c.IMG_Load("../../../assets/gfx/game/bg-activecell.png") orelse {
        c.SDL_Log("Unable to IMG_Load: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    };
    defer c.SDL_FreeSurface(tmpSurface);

    const zig_texture = c.SDL_CreateTextureFromSurface(renderer, tmpSurface) orelse {
        c.SDL_Log("Unable to create texture from surface: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    };
    defer c.SDL_DestroyTexture(zig_texture);

    var quit = false;
    while (!quit) {
        var event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&event) != 0) {
            switch (event.@"type") {
                c.SDL_QUIT => {
                    quit = true;
                },
                else => {},
            }
        }

        _ = c.SDL_RenderClear(renderer);
        // _ = c.SDL_RenderCopy(renderer, zig_texture, null, null);
        var rect = c.SDL_Rect{ .x = 10, .y=10, .w = 60, .h=60};
        _ = c.SDL_RenderCopy(renderer, zig_texture, null, &rect);
        c.SDL_RenderPresent(renderer);

        c.SDL_Delay(17);
    }
}
