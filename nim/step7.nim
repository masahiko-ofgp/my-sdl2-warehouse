import sdl2/sdl,
       sdl2/sdl_image as img,
       math

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
    mouse_x: cint
    mouse_y: cint
    buttons: int64
    target_x: int
    target_y: int
    delta_x: float
    delta_y: float
    distance: float

  if tex.queryTexture(nil, nil, addr(dest.w), addr(dest.h)) != 0:
    echo "ERROR: Couldn't query texture: ", sdl.getError()
    tex.destroyTexture()
    window.destroyWindow()
    sdl.quit()
  
  dest.w = int(dest.w / 4)
  dest.h = int(dest.h / 4)
  x_pos = float((WINDOW_WIDTH - dest.w) / 2)
  y_pos = float((WINDOW_HEIGHT - dest.h) / 2)
  x_vel = float(0)
  y_vel = float(0)

  while close_requested:

    while sdl.pollEvent(addr(event)) != 0:
      if event.kind == EventKind.QUIT:
        close_requested = false
        break

    buttons = int64(sdl.getMouseState(addr(mouse_x), addr(mouse_y)))
    target_x = int(float(mouse_x) - dest.w / 2)
    target_y = int(float(mouse_y) - dest.h / 2)
    delta_x = float(target_x) - x_pos
    delta_y = float(target_y) - y_pos
    distance = sqrt(delta_x * delta_x + delta_y * delta_y)

    if distance < float(5):
      x_vel = float(0)
      y_vel = float(0)
    else:
      x_vel = delta_x * float(SPEED) / distance
      y_vel = delta_y * float(SPEED) / distance

    if (buttons and button(BUTTON_LEFT)) > 0:
      x_vel = -x_vel
      y_vel = -y_vel

    x_pos += x_vel / 60
    y_pos += y_vel / 60

    if x_pos <= float(0):
      x_pos = float(0)

    if y_pos <= float(0):
      y_pos = float(0)

    if x_pos >= float(WINDOW_WIDTH - dest.w):
      x_pos = float(WINDOW_WIDTH - dest.w)

    if y_pos >= float(WINDOW_HEIGHT - dest.h):
      y_pos = float(WINDOW_HEIGHT - dest.h)
      
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
