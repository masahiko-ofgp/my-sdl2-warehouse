import sdl2/sdl,
       sdl2/sdl_image as img

const
  TITLE = "Nim SDL2 Window"
  WINDOW_WIDTH = 640
  WINDOW_HEIGHT = 480
  SCROLL_SPEED = 300

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
                            RENDERER_ACCELERATED)

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
  surface.freeSurface()

  if tex.isNil:
    echo "ERROR: Couldn't create texture: ", sdl.getError()
    rend.destroyRenderer()
    window.destroyWindow()
    sdl.quit()

  var
    dest: sdl.Rect
    y_pos: float

  y_pos = float(WINDOW_HEIGHT)

  if tex.queryTexture(nil, nil, addr(dest.w), addr(dest.h)) != 0:
    echo "ERROR: Couldn't query texture: ", sdl.getError()
    tex.destroyTexture()
    window.destroyWindow()
    sdl.quit()
  
  dest.x = int((WINDOW_WIDTH - dest.w) / 2)

  while dest.y >= -dest.h:
    if rend.renderClear() != 0:
      break
    
    dest.y = int(y_pos)

    if rend.renderCopy(tex, nil, addr(dest)) != 0:
      break

    rend.renderPresent()
    y_pos -= float(SCROLL_SPEED / 60)
    
    sdl.delay(uint32(1000/60))


when isMainModule:
  main()
