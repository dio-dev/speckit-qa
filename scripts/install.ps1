param(
    [string]$DestinationRoot
)

$ErrorActionPreference = "Stop"

if (-not $DestinationRoot -or [string]::IsNullOrWhiteSpace($DestinationRoot)) {
    if ($env:CODEX_HOME -and -not [string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
        $DestinationRoot = Join-Path $env:CODEX_HOME "skills"
    } else {
        $DestinationRoot = Join-Path $HOME ".codex\\skills"
    }
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$target = Join-Path $DestinationRoot "speckit-qa"

New-Item -ItemType Directory -Force -Path $target | Out-Null

$itemsToCopy = @(
    "SKILL.md",
    "agents",
    "prompts",
    "slash-commands",
    "templates"
)

foreach ($item in $itemsToCopy) {
    $sourcePath = Join-Path $repoRoot $item
    $destPath = Join-Path $target $item

    if (Test-Path $destPath) {
        Remove-Item -Recurse -Force $destPath
    }

    Copy-Item -Recurse -Force $sourcePath $destPath
}

Write-Output "Installed speckit-qa to $target"
