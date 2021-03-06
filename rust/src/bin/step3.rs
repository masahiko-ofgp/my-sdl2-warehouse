use sdl2;
use sdl2::event::Event;
use sdl2::keyboard::Keycode;
use sdl2::image::{LoadSurface, InitFlag};
use sdl2::rect::Rect;
use sdl2::surface::Surface;
use std::time::Duration;
use std::thread;
use std::path::Path;

const TITLE: &'static str = "My SDL Window";
const WINDOW_WIDTH: u32 = 640;
const WINDOW_HEIGHT: u32 = 480;


fn main() -> Result<(), String> {
    let sdl_ctx = sdl2::init()?;
    let video_subsys = sdl_ctx.video()?;
    let _image_ctx = sdl2::image::init(InitFlag::PNG)?;

    let window = video_subsys.window(TITLE, WINDOW_WIDTH, WINDOW_HEIGHT)
        .position_centered()
        .build()
        .map_err(|e| e.to_string())?;

    let mut canvas = window.into_canvas()
        .accelerated()
        .build()
        .map_err(|e| e.to_string())?;

    let img = Path::new("imgs/newyearalien2.png");
    let surface = Surface::from_file(&img)?;
    let dest = Rect::new(
        ((WINDOW_WIDTH - 300) / 2) as i32,
        ((WINDOW_HEIGHT - 300) / 2) as i32,
        300,
        300
    );

    let texture_creator = canvas.texture_creator();
    let tex = texture_creator.create_texture_from_surface(&surface)
        .map_err(|e| e.to_string())?;
    
    let mut event_pump = sdl_ctx.event_pump()?;

    'running: loop {
        canvas.copy(&tex, None, dest)?;
        canvas.present();

        for ev in event_pump.poll_iter() {
            match ev {
                Event::Quit {..} |
                    Event::KeyDown {keycode: Some(Keycode::Escape), ..} =>
                    break 'running,
                _ => {}
            }
        }
        thread::sleep(Duration::new(0, 1_000_000_000u32 / 60));
    }

    Ok(())
}
