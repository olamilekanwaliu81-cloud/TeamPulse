# Opens TeamPulse straight from this folder, without installing anything.
. (Join-Path $PSScriptRoot 'common.ps1')

$browser = Find-Browser
if (-not $browser) {
    Show-Message $NoBrowserText | Out-Null
    exit 1
}

$appDir = Join-Path $PSScriptRoot 'app'
$profileDir = Join-Path $env:LOCALAPPDATA 'TeamPulse\profile'
New-Item -ItemType Directory -Force -Path $profileDir | Out-Null
Start-Process -FilePath $browser -ArgumentList (Get-AppArguments $appDir $profileDir)
