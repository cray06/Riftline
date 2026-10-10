use serde::Serialize;

#[derive(Debug, Serialize)]
pub struct BackendStatus {
    pub status: &'static str,
    pub app_version: &'static str,
    pub os: &'static str,
    pub architecture: &'static str,
    pub started_at: String,
}
