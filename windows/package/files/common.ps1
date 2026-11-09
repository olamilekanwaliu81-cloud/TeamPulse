# Shared helpers for the TeamPulse install, launch and uninstall scripts.
Add-Type -AssemblyName System.Windows.Forms

function Show-Message($text, $buttons = 'OK') {
    return [System.Windows.Forms.MessageBox]::Show($text, 'TeamPulse', $buttons)
}

# Finds Microsoft Edge (already on Windows 10 and 11) or, if that is missing, Google Chrome.
function Find-Browser {
    $keys = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe',
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe'
    )
    foreach ($key in $keys) {
        try {
            $path = (Get-ItemProperty -Path $key -ErrorAction Stop).'(default)'
            if ($path -and (Test-Path $path)) { return $path }
        } catch { }
    }
    $guesses = @(
        "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
        "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
        "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
        "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
    )
    foreach ($path in $guesses) {
        if (Test-Path $path) { return $path }
    }
    return $null
}

# The command-line options that open TeamPulse in its own window, with its own saved data.
function Get-AppArguments($appDir, $profileDir) {
    $index = Join-Path $appDir 'index.html'
    $uri = ([System.Uri]$index).AbsoluteUri + '?desktop=windows'
    return ('--app=' + $uri + ' --user-data-dir="' + $profileDir + '" --no-first-run --no-default-browser-check')
}

$NoBrowserText = 'TeamPulse needs Microsoft Edge or Google Chrome, and neither was found on this computer. Install Microsoft Edge from microsoft.com/edge and try again.'
