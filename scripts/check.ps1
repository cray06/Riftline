$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
Set-Location -LiteralPath $repoRoot

$checks = @(
    @{ Command = 'pnpm'; Arguments = @('lint') },
    @{ Command = 'pnpm'; Arguments = @('check') },
    @{ Command = 'pnpm'; Arguments = @('build') },
    @{ Command = 'cargo'; Arguments = @('fmt', '--manifest-path', 'src-tauri/Cargo.toml', '--check') },
    @{ Command = 'cargo'; Arguments = @('check', '--manifest-path', 'src-tauri/Cargo.toml') },
    @{ Command = 'cargo'; Arguments = @('clippy', '--manifest-path', 'src-tauri/Cargo.toml', '--all-targets', '--', '-D', 'warnings') },
    @{ Command = 'cargo'; Arguments = @('test', '--manifest-path', 'src-tauri/Cargo.toml') }
)

foreach ($check in $checks) {
    Write-Host "Running $($check.Command) $($check.Arguments -join ' ')"
    $arguments = $check.Arguments
    & $check.Command @arguments
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
