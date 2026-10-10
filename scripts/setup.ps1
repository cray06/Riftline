$ErrorActionPreference = 'Stop'
$missing = [System.Collections.Generic.List[string]]::new()
$env:Path = @((Join-Path $env:USERPROFILE '.cargo\bin'), (Join-Path $env:APPDATA 'npm'), $env:Path) -join ';'

foreach ($tool in @('node', 'cargo', 'rustc')) {
    $command = Get-Command $tool -ErrorAction SilentlyContinue
    if ($null -eq $command) {
        $missing.Add($tool)
        Write-Host "${tool}: missing"
    } else {
        $version = & $tool --version
        Write-Host "${tool}: $version"
        if ($tool -eq 'node' -and [version]$version.TrimStart('v') -lt [version]'22.13.0') {
            $missing.Add('Node.js 22.13 or newer')
        }
    }
}

$pnpmCommand = Get-Command pnpm.cmd -ErrorAction SilentlyContinue
if ($pnpmCommand) {
    $pnpmVersion = & $pnpmCommand.Source --version
    Write-Host "pnpm: $pnpmVersion"
    if ([version]$pnpmVersion -lt [version]'11.0.0') { $missing.Add('pnpm 11 or newer') }
} elseif (Get-Command corepack.cmd -ErrorAction SilentlyContinue) {
    Write-Host 'pnpm: available through Corepack when development starts'
} else {
    $missing.Add('pnpm or Corepack')
    Write-Host 'pnpm: missing'
}

if (Get-Command rustc -ErrorAction SilentlyContinue) {
    $hostTriple = & rustc -vV | Select-String '^host: '
    if ($null -eq $hostTriple -or $hostTriple.Line -notmatch 'x86_64-pc-windows-msvc') {
        $missing.Add('Rust x86_64-pc-windows-msvc toolchain')
        Write-Host 'Rust MSVC x64 host: missing'
    } else {
        Write-Host "Rust MSVC x64 host: $($hostTriple.Line)"
    }
}

$vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
if (Test-Path -LiteralPath $vswhere) {
    $vsPath = & $vswhere -latest -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
} else {
    $vsPath = $null
}
if ([string]::IsNullOrWhiteSpace($vsPath)) {
    $missing.Add('Microsoft C++ Build Tools')
    Write-Host 'Microsoft C++ Build Tools: missing'
} else {
    Write-Host "Microsoft C++ Build Tools: $vsPath"
}

$webViewPaths = @(
    'HKLM:\SOFTWARE\Microsoft\EdgeUpdate\Clients\{F1F6E3A5-1B79-4C8A-A2A6-77A2FAE6A873}',
    'HKCU:\SOFTWARE\Microsoft\EdgeUpdate\Clients\{F1F6E3A5-1B79-4C8A-A2A6-77A2FAE6A873}',
    'HKLM:\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\Clients\{F1F6E3A5-1B79-4C8A-A2A6-77A2FAE6A873}'
)
$webViewInstalled = $false
foreach ($path in $webViewPaths) {
    if (Test-Path -LiteralPath $path) {
        $version = (Get-ItemProperty -LiteralPath $path -ErrorAction SilentlyContinue).pv
        if ($version -and $version -ne '0.0.0.0') {
            $webViewInstalled = $true
            Write-Host "WebView2 Runtime: $version"
            break
        }
    }
}
if (-not $webViewInstalled) {
    $webViewDirectory = 'C:\Program Files (x86)\Microsoft\EdgeWebView\Application'
    $webViewInstalled = Test-Path -LiteralPath $webViewDirectory
    if ($webViewInstalled) {
        Write-Host "WebView2 Runtime: $webViewDirectory"
    } else {
        $missing.Add('WebView2 Runtime')
        Write-Host 'WebView2 Runtime: missing'
    }
}

if ($missing.Count -gt 0) {
    Write-Error "Missing prerequisites: $($missing -join ', '). See README.md for installation guidance."
    exit 1
}

Write-Host 'RiftScope prerequisites are available.'
