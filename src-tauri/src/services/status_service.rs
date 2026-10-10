use crate::domain::BackendStatus;
use crate::state::AppState;

pub fn get_backend_status(state: &AppState) -> BackendStatus {
    BackendStatus {
        status: "ready",
        app_version: state.config.app_version,
        os: std::env::consts::OS,
        architecture: std::env::consts::ARCH,
        started_at: state.started_at.to_rfc3339(),
    }
}

#[cfg(test)]
mod tests {
    use chrono::{TimeZone, Utc};

    use super::*;
    use crate::state::AppConfig;

    #[test]
    fn status_reports_the_shared_start_time() {
        let started_at = Utc.with_ymd_and_hms(2026, 1, 2, 3, 4, 5).single();
        let Some(started_at) = started_at else {
            panic!("test timestamp must be valid");
        };
        let state = AppState {
            config: AppConfig::default(),
            http_client: reqwest::Client::new(),
            started_at,
        };

        let status = get_backend_status(&state);

        assert_eq!(status.status, "ready");
        assert_eq!(status.started_at, "2026-01-02T03:04:05+00:00");
        assert_eq!(status.app_version, env!("CARGO_PKG_VERSION"));
    }
}
