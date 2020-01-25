use sdl2;
use sdl2::event::Event;
use sdl2::keyboard::Keycode;
use sdl2::pixels::Color;
use std::time::Duration;
use std::thread;

const TITLE: &'static str = "My SDL Window";
const WINDOW_WIDTH: u32 = 640;
const WINDOW_HEIGHT: u32 = 480;


fn main() -> Result<(), String> {
    let sdl_ctx = sdl2::init()?;
    let video_subsys = sdl_ctx.video()?;

    let window = video_subsys.window(TITLE, WINDOW_WIDTH, WINDOW_HEIGHT)
        .position_centered()
        .build()
        .map_err(|e| e.to_string())?;

    let mut canvas = window.into_canvas()
        .build()
        .map_err(|e| e.to_string())?;

    let mut event_pump = sdl_ctx.event_pump()?;

    'running: loop {
        canvas.set_draw_color(Color::RGB(0, 255, 0));
        canvas.clear();
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
