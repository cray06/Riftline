# RiftScope

RiftScope is a Windows 10/11 x64 desktop companion foundation for League of Legends. Tauri 2 and WebView2 host the interface. React renders the UI; Rust owns application state and prepares data for display.

## Requirements

- Node.js 22.13+
- pnpm 11+
- Stable Rust with the `x86_64-pc-windows-msvc` target
- Microsoft C++ Build Tools with Desktop development with C++
- Microsoft Edge WebView2 Runtime

Run `./scripts/setup.ps1` to check the local environment without installing components.
The [Tauri Windows prerequisites](https://v2.tauri.app/start/prerequisites/) guide covers the C++ tools, WebView2, and Rust MSVC setup.

## Development

```powershell
./scripts/dev.ps1
```

`dev.bat` provides the same entry point from Command Prompt or Explorer. The development launcher finds Rust in your user profile and uses Corepack when pnpm is not on `PATH`. If a prerequisite is genuinely absent, it installs it before starting Tauri. Windows may request administrator approval for system components.

## Checks and release

```powershell
pnpm lint
pnpm check
pnpm build
pnpm rust:fmt
pnpm rust:clippy
cargo test --manifest-path src-tauri/Cargo.toml
./scripts/check.ps1
./scripts/build.ps1
```

`pnpm build` builds web assets. `pnpm tauri:build` or `./scripts/build.ps1` creates a Windows release bundle.

## Layout

- `src/app`, `src/components`, `src/features`: desktop UI and pages
- `src/lib/tauri`: typed IPC boundary
- `src/stores`: UI state
- `src-tauri/src/commands`: Tauri commands
- `src-tauri/src/domain`, `error`, `infrastructure`, `services`, `state`: backend contracts and shared state
- `src-tauri/capabilities`: minimal window permissions

The dashboard calls `ping` and `get_backend_status` once on load. Network, cache, user data, analytics, and Riot or League integrations have only extension points. Future game integrations must use legitimate Riot and League interfaces. The application does not interact with Vanguard.

Docker is optional and reserved for future auxiliary services. It is not used to run or develop the Windows desktop client.
