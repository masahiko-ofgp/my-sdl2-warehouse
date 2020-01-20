import sdl2/sdl,
       sdl2/sdl_image as img

const
  TITLE = "Nim SDL2 Window"
  WINDOW_WIDTH = 640
  WINDOW_HEIGHT = 480
  SPEED = 300

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
    event: sdl.Event
    x_pos: float
    y_pos: float
    x_vel: float
    y_vel: float
    close_requested = true

  if tex.queryTexture(nil, nil, addr(dest.w), addr(dest.h)) != 0:
    echo "ERROR: Couldn't query texture: ", sdl.getError()
    tex.destroyTexture()
    window.destroyWindow()
    sdl.quit()
  
  dest.w = int(dest.w / 4)
  dest.h = int(dest.h / 4)
  x_vel = float(SPEED)
  y_vel = float(SPEED)

  while close_requested:

    while sdl.pollEvent(addr(event)) != 0:
      if event.kind == EventKind.QUIT:
        close_requested = false
        break

    if int(x_pos) <= 0:
      x_pos = float(0)
      x_vel = -x_vel

    if int(y_pos) <= 0:
      y_pos = float(0)
      y_vel = -y_vel

    if int(x_pos) >= WINDOW_WIDTH - dest.w:
      x_pos = float(WINDOW_WIDTH - dest.w)
      x_vel = -x_vel

    if int(y_pos) >= WINDOW_HEIGHT - dest.h:
      y_pos = float(WINDOW_HEIGHT - dest.h)
      y_vel = -y_vel

    x_pos += x_vel / 60
    y_pos += y_vel / 60

    dest.y = int(y_pos)
    dest.x = int(x_pos)

    if rend.renderClear() != 0:
      break

    if rend.renderCopy(tex, nil, addr(dest)) != 0:
      break

    rend.renderPresent()
    
    sdl.delay(uint32(1000/60))


when isMainModule:
  main()
