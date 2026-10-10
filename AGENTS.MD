\# AGENTS.md



\## Project



This repository is a Windows-first desktop application built with:



\- Tauri 2

\- Rust

\- React

\- TypeScript

\- Vite

\- TailwindCSS

\- pnpm



The application is intended to remain lightweight, fast, maintainable, and suitable for long-term public distribution.



Rust owns application logic, system interaction, networking, parsing, caching, persistence, and expensive computation.



React owns presentation, user interaction, and UI state.



Do not move business logic into the frontend without a strong reason.



\## Core Rules



\### No Comments



Do not write comments anywhere in code.



Forbidden:



\- `//`

\- `/\* \*/`

\- JSX comments

\- CSS comments

\- TODO comments

\- FIXME comments

\- commented-out code



Code must explain itself through clear naming and structure.



Comments are allowed only in Markdown documentation when necessary.



\### Simplicity



Prefer the simplest correct implementation.



Do not overengineer.



Do not introduce:



\- unnecessary abstractions

\- speculative interfaces

\- generic systems for one use case

\- premature optimization

\- unnecessary dependencies

\- wrapper layers with no clear benefit



Keep files and modules focused.



\## TypeScript



TypeScript must remain strict.



Never use `any`.



Avoid unsafe type assertions.



Prefer:



\- explicit domain types

\- discriminated unions

\- readonly data where appropriate

\- typed APIs

\- narrow types

\- exhaustive handling



Do not duplicate backend types manually when a shared/generated solution already exists.



Use `unknown` instead of `any` when data has not been validated.



Do not suppress TypeScript errors unless absolutely unavoidable.



Avoid:



\- `@ts-ignore`

\- `@ts-expect-error`

\- non-null assertions



If one is truly necessary, redesign the code first.



\## React



React is the UI layer, not the application engine.



Keep components small and focused.



Do not perform expensive processing inside render functions.



Avoid unnecessary global state.



Use Zustand only for state that genuinely needs to be shared.



Prefer local component state for local UI behavior.



Do not use:



\- Redux

\- large UI frameworks

\- unnecessary context providers

\- excessive `useMemo`

\- excessive `useCallback`



Only memoize when there is a measurable or obvious benefit.



Do not call Tauri `invoke` directly from arbitrary components.



All backend communication must go through the centralized frontend API layer.



Example location:



`src/lib/tauri`



Prefer:



`backendApi.getStatus()`



over:



`invoke("get\_backend\_status")`



inside components.



Avoid aggressive polling.



Prefer events or explicit refresh actions when appropriate.



\## Styling



Use TailwindCSS.



Keep visual styling consistent.



Prefer reusable primitives over repeated large class strings when repetition becomes significant.



Do not create a design system abstraction prematurely.



Maintain:



\- dark-first UI

\- clear spacing

\- accessible contrast

\- visible focus states

\- sensible hover states

\- reduced motion support

\- responsive layouts within the desktop window



Do not add external fonts unless explicitly requested.



\## Rust



Rust owns:



\- networking

\- persistence

\- caching

\- League integrations

\- system interaction

\- parsing

\- business logic

\- expensive computation



Prefer strong types.



Avoid primitive obsession when domain types improve correctness.



Use `Result` for fallible operations.



Avoid `unwrap()` and `expect()` in application code.



They are acceptable only when failure is truly impossible or during unrecoverable application initialization.



Prefer explicit error propagation with `?`.



Keep `main.rs` minimal.



Put logic into appropriate modules.



Use async only where it provides value.



Do not block the async runtime with expensive synchronous work.



Use Tokio appropriately.



\## Errors



Errors must be explicit and typed.



Use the project error type for application errors.



Do not silently ignore errors.



Do not replace meaningful errors with generic strings too early.



Frontend-facing errors must be safe to serialize and display.



Never expose secrets, tokens, credentials, filesystem-sensitive data, or internal implementation details unnecessarily.



\## Tauri



Use Tauri 2 capabilities with minimum required permissions.



Do not enable broad permissions for convenience.



Do not expose arbitrary:



\- shell execution

\- PowerShell execution

\- filesystem access

\- process execution

\- command execution



Sensitive operations belong in Rust.



Commands must be narrowly scoped and typed.



Prefer returning structured objects instead of many small IPC calls.



Avoid excessive Rust ↔ frontend IPC.



Prepare data in Rust and send useful complete payloads.



\## Windows



Windows 10 and Windows 11 x64 are the primary targets.



Prefer the MSVC toolchain.



Do not introduce platform-specific behavior for other operating systems unless requested.



Windows-specific code must be isolated when practical.



\## League of Legends



Use only legitimate interfaces intended for external applications.



Allowed future integration areas may include:



\- Riot API

\- League Client Update API

\- Live Client Data API

\- officially supported local endpoints



Do not implement:



\- DLL injection

\- process injection

\- memory reading

\- memory writing

\- DirectX hooking

\- process hooking

\- kernel drivers

\- anti-cheat bypasses

\- Vanguard interaction or circumvention



The application must remain a normal userland application.



\## Security



Never hardcode secrets.



Never expose API secrets to the frontend.



Assume distributed client code can be inspected.



Do not trust frontend input.



Validate backend command inputs.



Keep dependencies minimal and reputable.



Do not weaken security controls to simplify development.



\## Dependencies



Before adding a dependency, verify that it provides meaningful value.



Prefer existing project dependencies when suitable.



Do not add a library for trivial functionality.



Avoid duplicate libraries solving the same problem.



Use stable and actively maintained packages.



\## Naming



Use explicit names.



Avoid vague names such as:



\- `data`

\- `thing`

\- `helper`

\- `utils2`

\- `temp`

\- `misc`



Prefer names that communicate domain meaning.



Functions should do one clear thing.



Boolean names should read naturally:



\- `isConnected`

\- `hasSession`

\- `canRefresh`



\## Structure



Respect the existing architecture.



Frontend concerns belong under frontend modules.



Backend concerns belong under Rust modules.



Do not create circular dependencies.



Avoid large catch-all utility files.



Split files when they become difficult to understand, not based on arbitrary line counts.



\## Performance



Performance matters, but correctness and clarity come first.



Avoid:



\- unnecessary cloning

\- repeated serialization

\- large IPC payloads without reason

\- aggressive polling

\- expensive React re-renders

\- repeated network calls

\- blocking operations on async threads



Cache when there is a clear benefit.



Do not optimize blindly.



\## Quality



Before considering a task complete, run the relevant checks when available:



\- TypeScript check

\- ESLint

\- frontend build

\- `cargo fmt --check`

\- `cargo check`

\- `cargo clippy`

\- Rust tests



Fix warnings caused by your changes when reasonable.



Do not leave the repository in a partially broken state.



\## Editing Existing Code



Preserve existing conventions unless there is a clear reason to improve them.



Do not rewrite unrelated code.



Keep diffs focused.



Do not rename unrelated files or symbols.



Do not change architecture outside the scope of the task unless required for correctness.



\## Output



When completing a task:



\- implement the requested changes directly

\- keep explanations concise

\- mention important architectural decisions

\- mention checks that were run

\- explicitly state any checks that could not be run



Do not provide large tutorials unless requested.

