pub struct AppConfig {
    pub app_version: &'static str,
}

impl Default for AppConfig {
    fn default() -> Self {
        Self {
            app_version: env!("CARGO_PKG_VERSION"),
        }
    }
}
