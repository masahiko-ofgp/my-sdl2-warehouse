#include <stdio.h>
#include <SDL2/SDL.h>
#include <SDL2/SDL_timer.h>
#include <SDL2/SDL_image.h>

#define TITLE "My SDL2 Window"
#define WINDOW_WIDTH (600)
#define WINDOW_HEIGHT (600)
#define SPEED (300)

int main() {
    if (SDL_Init(SDL_INIT_VIDEO|SDL_INIT_TIMER) != 0) {
        printf("Error initializing SDL: %s\n", SDL_GetError());
        return 1;
    }

    SDL_Window *window = SDL_CreateWindow(TITLE,
                                          SDL_WINDOWPOS_CENTERED,
                                          SDL_WINDOWPOS_CENTERED,
                                          WINDOW_WIDTH,
                                          WINDOW_HEIGHT,
                                          0);

    if (!window) {
        printf("Error creating window: %s\n", SDL_GetError());
        SDL_Quit();
        return 1;
    }

    Uint32 render_flags = SDL_RENDERER_ACCELERATED;
    
    SDL_Renderer *rend = SDL_CreateRenderer(window, -1, render_flags);

    if (!rend) {
        printf("Error creating renderer: %s\n", SDL_GetError());
        SDL_DestroyWindow(window);
        SDL_Quit();
        return 1;
    }

    SDL_Surface *surface = IMG_Load("../imgs/newyearalien2.png");

    if (!surface) {
        printf("Error creating surface\n");
        SDL_DestroyRenderer(rend);
        SDL_DestroyWindow(window);
        SDL_Quit();
        return 1;
    }

    SDL_Texture *tex = SDL_CreateTextureFromSurface(rend, surface);
    SDL_FreeSurface(surface);

    if (!tex) {
        printf("Error creating texture: %s\n", SDL_GetError());
        SDL_DestroyRenderer(rend);
        SDL_DestroyWindow(window);
        SDL_Quit();
        return 1;
    }

    SDL_Rect dst;

    SDL_QueryTexture(tex, NULL, NULL, &dst.w, &dst.h);
    dst.w /= 4;
    dst.h /= 4;
    
    float x_pos = (WINDOW_WIDTH - dst.w) / 2;
    float y_pos = (WINDOW_HEIGHT - dst.h) / 2;

    float x_vel = 0;
    float y_vel = 0;

    int up = 0;
    int down = 0;
    int left = 0;
    int right = 0;

    int close_requested = 0;

    while (!close_requested) {

        SDL_Event ev;

        while (SDL_PollEvent(&ev)) {
            switch (ev.type) {
            case SDL_QUIT:
                close_requested = 1;
                break;
            case SDL_KEYDOWN:
                switch (ev.key.keysym.scancode) {
                case SDL_SCANCODE_W: 
                case SDL_SCANCODE_UP: 
                    up = 1;
                    break;
                case SDL_SCANCODE_A:
                case SDL_SCANCODE_LEFT:
                    left = 1;
                    break;
                case SDL_SCANCODE_S:
                case SDL_SCANCODE_DOWN:
                    down = 1;
                    break;
                case SDL_SCANCODE_D:
                case SDL_SCANCODE_RIGHT:
                    right = 1;
                    break;
                default:
                    continue;
                }
                break;
            case SDL_KEYUP:
                switch (ev.key.keysym.scancode) {
                case SDL_SCANCODE_W:
                case SDL_SCANCODE_UP:
                    up = 0;
                    break;
                case SDL_SCANCODE_A:
                case SDL_SCANCODE_LEFT:
                    left = 0;
                    break;
                case SDL_SCANCODE_S:
                case SDL_SCANCODE_DOWN:
                    down = 0;
                    break;
                case SDL_SCANCODE_D:
                case SDL_SCANCODE_RIGHT:
                    right = 0;
                    break;
                default:
                    continue;
                }
                break;
            }
        }
        x_vel = y_vel = 0;

        if (up && !down) y_vel = -SPEED;
        if (down && !up) y_vel = SPEED;
        if (left && !right) x_vel = -SPEED;
        if (right && !left) x_vel = SPEED;

        x_pos += x_vel / 60;
        y_pos += y_vel / 60;

        if (x_pos <= 0) x_pos = 0;
        if (y_pos <= 0) y_pos = 0;
        if (x_pos >= WINDOW_WIDTH - dst.w) x_pos = WINDOW_WIDTH - dst.w;
        if (y_pos >= WINDOW_HEIGHT - dst.h) y_pos = WINDOW_HEIGHT - dst.h;

        dst.y = (int) y_pos;
        dst.x = (int) x_pos;

        SDL_RenderClear(rend);

        SDL_RenderCopy(rend, tex, NULL, &dst);
        SDL_RenderPresent(rend);

        SDL_Delay(1000/60);
    }

    // Clean up
    SDL_DestroyTexture(tex);
    SDL_DestroyRenderer(rend);
    SDL_DestroyWindow(window);
    SDL_Quit();

    return 0;
}
