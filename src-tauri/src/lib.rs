mod commands;
mod domain;
mod error;
mod infrastructure;
mod services;
mod state;

use state::AppState;
use tauri::Manager;

pub fn run() -> Result<(), Box<dyn std::error::Error>> {
    if let Err(error) = tracing_subscriber::fmt::try_init() {
        eprintln!("Tracing initialization failed: {error}");
    }

    tauri::Builder::default()
        .setup(|app| {
            let state = AppState::new()?;
            tracing::debug!(?state.http_client, "Shared HTTP client initialized");
            app.manage(state);
            tracing::info!("RiftScope backend initialized");
            Ok(())
        })
        .invoke_handler(tauri::generate_handler![
            commands::status::ping,
            commands::status::get_backend_status
        ])
        .run(tauri::generate_context!())?;

    Ok(())
}
