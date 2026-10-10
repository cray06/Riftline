function Update-ProcessPath {
    $machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $cargoPath = Join-Path $env:USERPROFILE '.cargo\bin'
    $npmPath = Join-Path $env:APPDATA 'npm'
    $env:Path = @($cargoPath, $npmPath, $userPath, $machinePath, $env:Path) -join ';'
}

function Get-ToolPath([string]$name) {
    $tool = Get-Command $name -ErrorAction SilentlyContinue
    if ($null -eq $tool) { return $null }
    return $tool.Source
}

function Install-WingetPackage([string]$packageId, [string]$displayName, [string]$overrideArguments = '') {
    if (-not (Get-ToolPath 'winget.exe')) {
        throw "$displayName is missing and Windows Package Manager is unavailable. Install it manually, then run dev.bat again."
    }

    Write-Host "Installing $displayName..."
    $arguments = @('install', '--id', $packageId, '--exact', '--source', 'winget', '--accept-package-agreements', '--accept-source-agreements')
    if ($overrideArguments) { $arguments += @('--override', $overrideArguments) }
    & winget.exe @arguments
    if ($LASTEXITCODE -ne 0) { throw "$displayName installation failed with exit code $LASTEXITCODE." }
    Update-ProcessPath
}

function Test-VcTools {
    $programFilesX86 = [Environment]::GetEnvironmentVariable('ProgramFiles(x86)')
    if (-not $programFilesX86) { return $false }
    $vswhere = Join-Path $programFilesX86 'Microsoft Visual Studio\Installer\vswhere.exe'
    if (-not (Test-Path -LiteralPath $vswhere)) { return $false }
    $installation = & $vswhere -latest -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
    return -not [string]::IsNullOrWhiteSpace($installation)
}

function Test-WebView2 {
    $runtimePath = Join-Path ([Environment]::GetEnvironmentVariable('ProgramFiles(x86)')) 'Microsoft\EdgeWebView\Application'
    if (Test-Path -LiteralPath $runtimePath) { return $true }
    $registryPaths = @(
        'HKLM:\SOFTWARE\Microsoft\EdgeUpdate\Clients\{F1F6E3A5-1B79-4C8A-A2A6-77A2FAE6A873}',
        'HKCU:\SOFTWARE\Microsoft\EdgeUpdate\Clients\{F1F6E3A5-1B79-4C8A-A2A6-77A2FAE6A873}',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\Clients\{F1F6E3A5-1B79-4C8A-A2A6-77A2FAE6A873}'
    )
    foreach ($path in $registryPaths) {
        $version = (Get-ItemProperty -LiteralPath $path -ErrorAction SilentlyContinue).pv
        if ($version -and $version -ne '0.0.0.0') { return $true }
    }
    return $false
}

Update-ProcessPath

$nodeCommand = Get-ToolPath 'node.exe'
if (-not $nodeCommand) {
    Install-WingetPackage 'OpenJS.NodeJS.LTS' 'Node.js LTS'
    $nodeCommand = Get-ToolPath 'node.exe'
}
if (-not $nodeCommand) { throw 'Node.js was installed but is not available. Restart the terminal and run dev.bat again.' }
$nodeVersion = [version]((& $nodeCommand --version).TrimStart('v'))
if ($nodeVersion -lt [version]'22.13.0') {
    if (-not (Get-ToolPath 'winget.exe')) { throw 'Node.js 22.13 or newer is required and Windows Package Manager is unavailable.' }
    Write-Host 'Updating Node.js LTS...'
    & winget.exe upgrade --id OpenJS.NodeJS.LTS --exact --source winget --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) { throw 'Node.js update failed.' }
    Update-ProcessPath
    $nodeCommand = Get-ToolPath 'node.exe'
    if (-not $nodeCommand -or [version]((& $nodeCommand --version).TrimStart('v')) -lt [version]'22.13.0') {
        throw 'Node.js 22.13 or newer is required. Restart the terminal and run dev.bat again.'
    }
}

$pnpmCommand = Get-ToolPath 'pnpm.cmd'
$pnpmPrefix = @()
if (-not $pnpmCommand) {
    $corepackCommand = Get-ToolPath 'corepack.cmd'
    if ($corepackCommand) {
        $pnpmCommand = $corepackCommand
        $pnpmPrefix = @('pnpm')
    } else {
        $npmCommand = Get-ToolPath 'npm.cmd'
        if (-not $npmCommand) { throw 'npm is missing from the Node.js installation.' }
        Write-Host 'Installing pnpm 11.25.0...'
        & $npmCommand install --global pnpm@11.25.0
        if ($LASTEXITCODE -ne 0) { throw 'pnpm installation failed.' }
        Update-ProcessPath
        $pnpmCommand = Get-ToolPath 'pnpm.cmd'
    }
}
if (-not $pnpmCommand) { throw 'pnpm is unavailable after installation.' }
$pnpmVersion = & $pnpmCommand @pnpmPrefix --version
if ($LASTEXITCODE -ne 0) { throw 'pnpm could not be started.' }
if ([version]$pnpmVersion -lt [version]'11.0.0') {
    $corepackCommand = Get-ToolPath 'corepack.cmd'
    if ($corepackCommand) {
        $pnpmCommand = $corepackCommand
        $pnpmPrefix = @('pnpm')
        $pnpmVersion = & $pnpmCommand @pnpmPrefix --version
    } else {
        $npmCommand = Get-ToolPath 'npm.cmd'
        Write-Host 'Updating pnpm to 11.25.0...'
        & $npmCommand install --global pnpm@11.25.0
        if ($LASTEXITCODE -ne 0) { throw 'pnpm update failed.' }
        Update-ProcessPath
        $pnpmCommand = Get-ToolPath 'pnpm.cmd'
        $pnpmVersion = & $pnpmCommand --version
    }
}
if ($LASTEXITCODE -ne 0 -or [version]$pnpmVersion -lt [version]'11.0.0') { throw 'pnpm 11 or newer is unavailable.' }
Write-Host "pnpm: $pnpmVersion"

$cargoCommand = Get-ToolPath 'cargo.exe'
$rustupCommand = Get-ToolPath 'rustup.exe'
if (-not $cargoCommand -and -not $rustupCommand) {
    Install-WingetPackage 'Rustlang.Rustup' 'Rustup'
    $rustupCommand = Get-ToolPath 'rustup.exe'
}
$rustcCommand = Get-ToolPath 'rustc.exe'
$hostTriple = if ($rustcCommand) { (& $rustcCommand -vV | Select-String '^host: ').Line } else { '' }
if ($hostTriple -notmatch 'x86_64-pc-windows-msvc') {
    if (-not $rustupCommand) { throw 'Rustup is unavailable. Restart the terminal and run dev.bat again.' }
    Write-Host 'Installing stable Rust MSVC x64 toolchain...'
    & $rustupCommand default stable-x86_64-pc-windows-msvc
    if ($LASTEXITCODE -ne 0) { throw 'Rust MSVC toolchain installation failed.' }
    Update-ProcessPath
    $cargoCommand = Get-ToolPath 'cargo.exe'
}
if (-not $cargoCommand) { throw 'Cargo is unavailable after Rust installation.' }
Write-Host "Rust: $(& $cargoCommand --version)"

if (-not (Test-VcTools)) {
    Install-WingetPackage 'Microsoft.VisualStudio.2022.BuildTools' 'Microsoft C++ Build Tools' '--passive --wait --norestart --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended'
    if (-not (Test-VcTools)) { throw 'Microsoft C++ Build Tools are still unavailable after installation.' }
}

if (-not (Test-WebView2)) {
    Install-WingetPackage 'Microsoft.EdgeWebView2Runtime' 'WebView2 Runtime'
    if (-not (Test-WebView2)) { throw 'WebView2 Runtime is still unavailable after installation.' }
}

Write-Host 'RiftScope prerequisites are ready.'
