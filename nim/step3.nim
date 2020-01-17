import sdl2/sdl,
       sdl2/sdl_image as img

const
  TITLE = "Nim SDL2 Window"
  WINDOW_WIDTH = 640
  WINDOW_HEIGHT = 480

proc main() =
  var
    window: Window
    rend: Renderer
    surface: Surface
    tex: Texture

  defer:
    tex.destroyTexture()
    rend.destroyRenderer()
    window.destroyWindow()
    sdl.quit()

  if sdl.init(INIT_VIDEO or INIT_TIMER) != 0:
    echo "Error: Couldn't initialize SDL: ", sdl.getError()

  window = sdl.createWindow(TITLE,
                            WINDOWPOS_CENTERED,
                            WINDOWPOS_CENTERED,
                            WINDOW_WIDTH,
                            WINDOW_HEIGHT,
                            WINDOW_SHOWN)

  if window.isNil:
    echo "ERROR: Couldn't create window: ", sdl.getError()
    sdl.quit()

  rend = sdl.createRenderer(window,
                            -1,
                            RENDERER_ACCELERATED or RENDERER_PRESENTVSYNC)

  if rend.isNil:
    echo "ERROR: Couldn't create renderer: ", sdl.getError()
    window.destroyWindow()
    sdl.quit()

  surface = img.load("../imgs/newyearalien2.png")

  if surface.isNil:
    echo "ERROR: Couldn't create surface: ", sdl.getError()
    rend.destroyRenderer()
    window.destroyWindow()
    sdl.quit()

  tex = sdl.createTextureFromSurface(rend, surface)

  if tex.isNil:
    echo "ERROR: Couldn't create texture: ", sdl.getError()
    rend.destroyRenderer()
    window.destroyWindow()
    sdl.quit()

  discard rend.renderClear()
  discard rend.renderCopy(tex, nil, nil)
  rend.renderPresent()
  
  sdl.delay(5000)


when isMainModule:
  main()
