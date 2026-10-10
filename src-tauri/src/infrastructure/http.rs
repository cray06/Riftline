use std::time::Duration;

use crate::error::AppError;

pub fn create_http_client() -> Result<reqwest::Client, AppError> {
    reqwest::Client::builder()
        .timeout(Duration::from_secs(15))
        .build()
        .map_err(|error| AppError::initialization(error.to_string()))
}
