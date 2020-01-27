use sdl2;
use sdl2::event::Event;
use sdl2::keyboard::Keycode;
use sdl2::mouse::MouseState;
use sdl2::image::{LoadSurface, InitFlag};
use sdl2::rect::Rect;
use sdl2::surface::Surface;
use std::time::Duration;
use std::thread;
use std::path::Path;

const TITLE: &'static str = "My SDL Window";
const WINDOW_WIDTH: u32 = 640;
const WINDOW_HEIGHT: u32 = 480;
const SPEED: i32 = 300;


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
    let mut dest = Rect::new(
        ((WINDOW_WIDTH - surface.width()) / 2) as i32,
        ((WINDOW_HEIGHT - surface.height()) / 2) as i32,
        surface.width() / 4,
        surface.height() / 4
    );
    let mut x_pos = ((WINDOW_WIDTH - dest.width()) / 2) as i32;
    let mut y_pos = ((WINDOW_HEIGHT - dest.height()) / 2) as i32;

    let texture_creator = canvas.texture_creator();
    let tex = texture_creator.create_texture_from_surface(&surface)
        .map_err(|e| e.to_string())?;

    let mut event_pump = sdl_ctx.event_pump()?;

    'running: loop {
        let mouse_state = MouseState::new(&event_pump);
    
        canvas.clear();
        canvas.copy(&tex, None, dest)?;
        canvas.present();

        for ev in event_pump.poll_iter() {
            match ev {
                Event::Quit { .. } |
                Event::KeyDown { keycode: Some(Keycode::Escape), .. } =>
                    break 'running,
                _ => {}
            } 
        }
        let mut x_vel;
        let mut y_vel;
        let target_x = (mouse_state.x() - dest.w / 2) as f64;
        let target_y = (mouse_state.y() - dest.h / 2) as f64;
        let delta_x = target_x - (x_pos as f64);
        let delta_y = target_y - (y_pos as f64);
        let distance = (delta_x * delta_x + delta_y * delta_y).sqrt();

        if distance < 5.0 {
            x_vel = 0;
            y_vel = 0;
        } else {
            x_vel = (delta_x * (SPEED as f64) / distance) as i32;
            y_vel = (delta_y * (SPEED as f64) / distance) as i32;
        }

        if mouse_state.left() {
            x_vel = -(x_vel);
            y_vel = -(y_vel);
        }

        x_pos += x_vel / 60;
        y_pos += y_vel / 60;

        if x_pos <= 0 { x_pos = 0; }
        if y_pos <= 0 { y_pos = 0; }
        if x_pos >= ((WINDOW_WIDTH - dest.width()) as i32) {
            x_pos = (WINDOW_WIDTH - dest.width()) as i32;
        }
        if y_pos >= ((WINDOW_HEIGHT - dest.height()) as i32) {
            y_pos = (WINDOW_HEIGHT - dest.height()) as i32;
        }

        dest.set_y(y_pos as i32);
        dest.set_x(x_pos as i32);        

        thread::sleep(Duration::new(0, 1_000_000_000u32 / 60));
    }
    Ok(())
}
