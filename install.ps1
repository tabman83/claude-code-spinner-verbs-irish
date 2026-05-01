<#
.SYNOPSIS
    Install Dublin spinner verbs into Claude Code (Windows).

.DESCRIPTION
    Fetches the latest spinner verbs from GitHub and installs them into
    %USERPROFILE%\.claude\settings.json. If a settings file already exists,
    you'll be asked whether to merge or overwrite. A timestamped backup is
    always taken before any change.

.NOTES
    Requires PowerShell 5.1+ (built into Windows 10/11).
#>

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

# --- config ---
$RepoRawUrl   = 'https://raw.githubusercontent.com/tabman83/claude-code-spinner-verbs-irish/refs/heads/master/spinner-verbs.json'
$SettingsDir  = Join-Path $HOME '.claude'
$SettingsFile = Join-Path $SettingsDir 'settings.json'

# --- pretty output ---
function Say  ($msg) { Write-Host "==> $msg" -ForegroundColor Green  }
function Warn ($msg) { Write-Host "==> $msg" -ForegroundColor Yellow }
function Err  ($msg) { Write-Host "==> $msg" -ForegroundColor Red    }

# --- fetch the verbs ---
Say 'Fetchin'' the latest verbs from GitHub...'
try {
    $verbsJson = Invoke-RestMethod -Uri $RepoRawUrl -UseBasicParsing
}
catch {
    Err "Couldn't fetch the verbs file. Check your internet, or the URL:"
    Err "  $RepoRawUrl"
    exit 1
}

# Invoke-RestMethod parses JSON automatically; if that worked, the JSON's valid.
if (-not $verbsJson) {
    Err "Downloaded file is empty or invalid. Aborting before we banjax anything."
    exit 1
}

# --- ensure settings dir exists ---
if (-not (Test-Path $SettingsDir)) {
    New-Item -ItemType Directory -Path $SettingsDir -Force | Out-Null
}

# --- decide what to do with existing settings ---
$action = 'install'
if (Test-Path $SettingsFile) {
    Warn "Found existing settings at: $SettingsFile"
    Write-Host ''
    Write-Host '  [m] Merge     - keep your other settings, replace only spinnerVerbs'
    Write-Host '  [o] Overwrite - replace the whole file with just the spinner verbs'
    Write-Host '  [c] Cancel'
    Write-Host ''
    $choice = (Read-Host "What'll it be? [m/o/c]").ToLower()
    switch ($choice) {
        'm'     { $action = 'merge' }
        'o'     { $action = 'overwrite' }
        default { Say 'Right so, nothin'' done. Off ye go.'; exit 0 }
    }
}

# --- back up if a file exists ---
if (Test-Path $SettingsFile) {
    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $backup = "$SettingsFile.bak.$timestamp"
    Copy-Item -Path $SettingsFile -Destination $backup
    Say "Backed up existing settings to: $backup"
}

# --- write the new file ---
switch ($action) {
    { $_ -in 'install', 'overwrite' } {
        $verbsJson | ConvertTo-Json -Depth 10 | Set-Content -Path $SettingsFile -Encoding UTF8
    }
    'merge' {
        try {
            $existing = Get-Content -Raw -Path $SettingsFile | ConvertFrom-Json
        }
        catch {
            Err "Existing settings file isn't valid JSON. Your original is safe in the .bak file."
            Err "Sort it out manually, or re-run and choose [o] to overwrite."
            exit 1
        }

        # Replace spinnerVerbs on the existing object, preserving everything else.
        if ($existing.PSObject.Properties.Name -contains 'spinnerVerbs') {
            $existing.spinnerVerbs = $verbsJson.spinnerVerbs
        }
        else {
            $existing | Add-Member -MemberType NoteProperty -Name 'spinnerVerbs' -Value $verbsJson.spinnerVerbs
        }

        $existing | ConvertTo-Json -Depth 10 | Set-Content -Path $SettingsFile -Encoding UTF8
    }
}

Say 'Sorted. Restart Claude Code to see the new spinner.'
Say 'If you change your mind, your old settings are in the .bak file.'
