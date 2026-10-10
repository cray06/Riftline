use chrono::{DateTime, Utc};

use crate::error::AppError;
use crate::infrastructure::create_http_client;

use super::AppConfig;

pub struct AppState {
    pub config: AppConfig,
    pub http_client: reqwest::Client,
    pub started_at: DateTime<Utc>,
}

impl AppState {
    pub fn new() -> Result<Self, AppError> {
        Ok(Self {
            config: AppConfig::default(),
            http_client: create_http_client()?,
            started_at: Utc::now(),
        })
    }
}
