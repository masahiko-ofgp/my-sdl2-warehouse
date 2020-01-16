import sdl2/sdl

const
  TITLE = "Nim SDL2 Window"
  WINDOW_WIDTH = 640
  WINDOW_HEIGHT = 480

proc main() =
  var
    window: Window

  defer:
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

  sdl.delay(5000)


when isMainModule:
  main()
