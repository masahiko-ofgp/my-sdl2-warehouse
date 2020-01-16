#include <stdio.h>
#include <SDL2/SDL.h>
#include <SDL2/SDL_timer.h>
#include <SDL2/SDL_image.h>

#define TITLE "My SDL2 Window"
#define WINDOW_WIDTH 640
#define WINDOW_HEIGHT 480
#define SCRL_SPEED 300

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

    Uint32 render_flags = SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC;
    
    SDL_Renderer *rend = SDL_CreateRenderer(window,
                                            -1,
                                            render_flags);

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
    dst.x = (WINDOW_WIDTH - dst.w) / 2;

    float y_pos = WINDOW_HEIGHT;

    while (dst.y >= -dst.h) {
        SDL_RenderClear(rend);
        dst.y = (int) y_pos;
        SDL_RenderCopy(rend, tex, NULL, &dst);
        SDL_RenderPresent(rend);

        y_pos -= (float) SCRL_SPEED / 60;

        SDL_Delay(1000 / 60);
    }

    // Clean up
    SDL_DestroyTexture(tex);
    SDL_DestroyRenderer(rend);
    SDL_DestroyWindow(window);
    SDL_Quit();

    return 0;
}
