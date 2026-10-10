#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

fn main() {
    if let Err(error) = riftscope_lib::run() {
        eprintln!("RiftScope failed to start: {error}");
        std::process::exit(1);
    }
}
