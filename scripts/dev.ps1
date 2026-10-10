$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
Set-Location -LiteralPath $repoRoot
. (Join-Path $PSScriptRoot 'bootstrap.ps1')

if (-not (Test-Path -LiteralPath (Join-Path $repoRoot 'node_modules'))) {
    & $pnpmCommand @pnpmPrefix install --frozen-lockfile
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

& $pnpmCommand @pnpmPrefix dev
exit $LASTEXITCODE
