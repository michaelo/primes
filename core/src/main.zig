const std = @import("std");
const testing = std.testing;
const c = @cImport({
    @cInclude("SDL2/SDL.h");
    @cInclude("SDL2/SDL_image.h");
    @cInclude("SDL2/SDL_ttf.h");
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

    if(c.TTF_Init() != 0) {
        c.SDL_Log("Unable to initialize SDL_ttf: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    }
    defer c.TTF_Quit();
    _ = c.SDL_SetHint( c.SDL_HINT_RENDER_SCALE_QUALITY, "1" );
    // _ = c.SDL_GL_SetAttribute(c.SDL_GL_RED_SIZE, 8);
    // _ = c.SDL_GL_SetAttribute(c.SDL_GL_GREEN_SIZE, 8);
    // _ = c.SDL_GL_SetAttribute(c.SDL_GL_BLUE_SIZE, 8);
    // _ = c.SDL_GL_SetAttribute(c.SDL_GL_ALPHA_SIZE, 8);

    // _ = c.SDL_GL_SetAttribute(c.SDL_GL_DEPTH_SIZE, 32);

    // _ = c.SDL_GL_SetAttribute(c.SDL_GL_MULTISAMPLEBUFFERS, 1);
    // _ = c.SDL_GL_SetAttribute(c.SDL_GL_MULTISAMPLESAMPLES, 2);

    // _ = c.SDL_GL_SetAttribute(c.SDL_GL_ACCELERATED_VISUAL, 1); 

    // _ = c.glEnable(c.GL_MULTISAMPLE);

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

    // var tempSurface = c.SDL_CreateRGBSurface(0, 32, 0xff, 0xff00, 0xff0000, 0x00000000) orelse {
    //     c.SDL_Log("Unable to SDL_CreateRGBSurface: %s", c.SDL_GetError());
    //     return error.SDLInitializationFailed;
    // };

    var cellSurface = c.IMG_Load("../../../assets/gfx/game/bg-activecell.png") orelse {
        c.SDL_Log("Unable to IMG_Load: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    };
    defer c.SDL_FreeSurface(cellSurface);

    _ = c.SDL_SetSurfaceBlendMode(cellSurface, c.SDL_BLENDMODE_BLEND);


    const font = c.TTF_OpenFont("/Users/michaelodden/dev/primes_sdl/src/assets/fonts/Lato-Bold.ttf", 12*36) orelse {
        c.SDL_Log("Unable to load font: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    };
    defer c.TTF_CloseFont(font);
    c.TTF_SetFontHinting(font, c.TTF_HINTING_NORMAL);

    var white = c.SDL_Color{.r=255, .g=255, .b=255, .a=255};
    // var black = c.SDL_Color{.r=0, .g=0, .b=0, .a=255};
    // var transp = c.SDL_Color{.r=0, .g=0, .b=0, .a=0};

    var textSurface = c.TTF_RenderText_Blended(font, "Hei", white) orelse {
        c.SDL_Log("Unable to create ttf surface: %s", c.TTF_GetError());
        return error.SDLInitializationFailed;
    };
    defer c.SDL_FreeSurface(textSurface);
    // _ = c.SDL_SetSurfaceBlendMode(textSurface, c.SDL_BLENDMODE_BLEND);
    // c.SDL_SetAlpha( textSurface, c.SDL_SRCALPHA, 128 ) ; // 50% opacity
    
    var textRect = c.SDL_Rect{.x=10,.y=10,.w=120,.h=120};
    _ = c.SDL_BlitSurface(textSurface, null, cellSurface, &textRect);


    const zig_texture = c.SDL_CreateTextureFromSurface(renderer, cellSurface) orelse {
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
