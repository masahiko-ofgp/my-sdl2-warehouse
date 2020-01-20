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
    up = true
    down = true
    left = true
    right = true

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
      case event.kind:
      of EventKind.QUIT:
        close_requested = false
        break
      of EventKind.KEYDOWN:
        case event.key.keysym.scancode:
        of Scancode.SCANCODE_W:
          up = false
          break
        of Scancode.SCANCODE_UP:
          up = false
          break
        of Scancode.SCANCODE_A:
          left = false
          break
        of Scancode.SCANCODE_LEFT:
          left = false
          break
        of Scancode.SCANCODE_S:
          down = false
          break
        of Scancode.SCANCODE_DOWN:
          down = false
          break
        of Scancode.SCANCODE_D:
          right = false
          break
        of Scancode.SCANCODE_RIGHT:
          right = false
          break
        else:
          break
      of EventKind.KEYUP:
        case event.key.keysym.scancode:
        of Scancode.SCANCODE_W:
          up = true
          break
        of Scancode.SCANCODE_UP:
          up = true
          break
        of Scancode.SCANCODE_A:
          left = true
          break
        of Scancode.SCANCODE_LEFT:
          left = true
          break
        of Scancode.SCANCODE_S:
          down = true
          break
        of Scancode.SCANCODE_DOWN:
          down = true
          break
        of Scancode.SCANCODE_D:
          right = true
          break
        of Scancode.SCANCODE_RIGHT:
          right = true
          break
        else:
          break
      else:
        break
      
    x_vel = float(0)
    y_vel = float(0)

    if (up == true) and (down == false):
      y_vel = float(SPEED)

    if (down == true) and (up == false):
      y_vel = -float(SPEED)

    if (left == true) and (right == false):
      x_vel = float(SPEED)

    if (right == true) and (left == false):
      x_vel = -float(SPEED)

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
