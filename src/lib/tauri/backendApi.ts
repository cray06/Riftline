import { invoke } from "@tauri-apps/api/core";
import type { BackendStatus } from "../../types/backend";

export const backendApi = {
  ping: () => invoke<string>("ping"),
  getStatus: () => invoke<BackendStatus>("get_backend_status"),
};
