# My SDL2 warehouse

- step1 Initializing SDL
- step2 Create Window
- step3 Display the image
- step4 Animation of image rising
- step5 The image is reflected on the wall
- step6 Operate the image with keyboard
- step7 Operate the image with mouse

## Requires

sdl2, sdl2_image

## c

```
$ make SRCS=filename.c
$ ./app
```

## nim

I used `sdl2nim` not `sdl2`.

```
$ nimble install sdl2nim
```

compile:

```
$ make SRCS=filename.nim
```

## rust

```
$ cargo run --bin stepN
```
