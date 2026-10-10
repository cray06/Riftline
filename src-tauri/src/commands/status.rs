use tauri::State;

use crate::domain::BackendStatus;
use crate::error::AppError;
use crate::services::status_service;
use crate::state::AppState;

#[tauri::command]
pub fn ping() -> &'static str {
    tracing::debug!("Ping received");
    "pong"
}

#[tauri::command]
pub fn get_backend_status(state: State<'_, AppState>) -> Result<BackendStatus, AppError> {
    Ok(status_service::get_backend_status(&state))
}
