import sdl2/sdl

proc main() =
  defer:
    sdl.quit()

  if sdl.init(INIT_VIDEO) != 0:
    echo "Error: Couldn't initialize SDL", sdl.getError()

  echo "SUCCESS: SDL initialized."


when isMainModule:
  main()
