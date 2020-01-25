use sdl2;

fn main() {
    let sdl_ctx = sdl2::init();

    match sdl_ctx {
        Ok(_) => println!("Success initializing SDL"),
        Err(e) => eprintln!("{}", e),
    }
}
