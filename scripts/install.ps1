param(
    [ValidateSet("codex", "claude", "cursor", "kiro", "agents")]
    [string]$Tool = "codex",
    [ValidateSet("user", "project")]
    [string]$Scope,
    [string]$DestinationRoot,
    [string]$ProjectRoot
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$packageName = "speckit-qa"
$runtimeItems = @(
    "SKILL.md",
    "agents",
    "prompts",
    "slash-commands",
    "templates"
)

function Get-DefaultScope {
    param([string]$SelectedTool)

    switch ($SelectedTool) {
        "codex" { return "user" }
        "claude" { return "user" }
        default { return "project" }
    }
}

function Get-ResolvedProjectRoot {
    param([string]$ExplicitProjectRoot)

    if ($ExplicitProjectRoot -and -not [string]::IsNullOrWhiteSpace($ExplicitProjectRoot)) {
        return (Resolve-Path -Path $ExplicitProjectRoot).Path
    }

    return (Get-Location).Path
}

function Resolve-InstallRoot {
    param(
        [string]$SelectedTool,
        [string]$SelectedScope,
        [string]$ExplicitDestinationRoot,
        [string]$ResolvedProjectRoot
    )

    if ($ExplicitDestinationRoot -and -not [string]::IsNullOrWhiteSpace($ExplicitDestinationRoot)) {
        return $ExplicitDestinationRoot
    }

    switch ($SelectedTool) {
        "codex" {
            if ($env:CODEX_HOME -and -not [string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
                return (Join-Path $env:CODEX_HOME "skills")
            }

            if ($SelectedScope -eq "project") {
                return (Join-Path $ResolvedProjectRoot ".codex\skills")
            }

            return (Join-Path $HOME ".codex\skills")
        }
        "claude" {
            if ($SelectedScope -eq "project") {
                return (Join-Path $ResolvedProjectRoot ".claude\skills")
            }

            return (Join-Path $HOME ".claude\skills")
        }
        default {
            return (Join-Path $ResolvedProjectRoot ".speckit\skills")
        }
    }
}

function Install-SkillPackage {
    param(
        [string]$InstallRoot,
        [string]$SkillName
    )

    $target = Join-Path $InstallRoot $SkillName
    New-Item -ItemType Directory -Force -Path $target | Out-Null

    foreach ($item in $runtimeItems) {
        $sourcePath = Join-Path $repoRoot $item
        $destPath = Join-Path $target $item

        if (Test-Path $destPath) {
            Remove-Item -Recurse -Force $destPath
        }

        Copy-Item -Recurse -Force $sourcePath $destPath
    }

    return $target
}

function Write-ManagedFile {
    param(
        [string]$Path,
        [string]$Content
    )

    $directory = Split-Path -Parent $Path
    if ($directory) {
        New-Item -ItemType Directory -Force -Path $directory | Out-Null
    }

    [System.IO.File]::WriteAllText($Path, $Content.TrimStart("`n", "`r") + "`n")
}

function Upsert-MarkedBlock {
    param(
        [string]$Path,
        [string]$StartMarker,
        [string]$EndMarker,
        [string]$BlockContent
    )

    $directory = Split-Path -Parent $Path
    if ($directory) {
        New-Item -ItemType Directory -Force -Path $directory | Out-Null
    }

    $managedBlock = @"
$StartMarker
$BlockContent
$EndMarker
"@

    if (Test-Path $Path) {
        $existing = Get-Content -Raw -Path $Path
        $pattern = [regex]::Escape($StartMarker) + ".*?" + [regex]::Escape($EndMarker)

        if ([regex]::IsMatch($existing, $pattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)) {
            $updated = [regex]::Replace(
                $existing,
                $pattern,
                $managedBlock.Trim(),
                [System.Text.RegularExpressions.RegexOptions]::Singleline
            )
        } else {
            $separator = ""
            if ($existing.Length -gt 0 -and -not $existing.EndsWith("`n")) {
                $separator = "`n"
            }

            $updated = $existing + $separator + "`n" + $managedBlock.Trim() + "`n"
        }
    } else {
        $updated = $managedBlock.Trim() + "`n"
    }

    [System.IO.File]::WriteAllText($Path, $updated)
}

function Get-CursorRuleContent {
    param([string]$SkillPath)

    $normalizedPath = $SkillPath -replace '\\', '/'
    return (@(
        "---",
        "description: Structured QA orchestration for Spec-Driven Development workflows",
        "alwaysApply: false",
        "---",
        "",
        "- Use Speckit QA when the user asks for structured QA, release readiness, browser verification, or defect retesting based on specs and plans.",
        "- Load and follow ``$normalizedPath/SKILL.md`` before starting QA work.",
        "- Reuse the prompt fragments in ``$normalizedPath/prompts/``, the slash command docs in ``$normalizedPath/slash-commands/``, and the report templates in ``$normalizedPath/templates/``.",
        "- Treat browser execution, screenshots, logs, and blockers as evidence. Do not claim success without verification.",
        "- Reuse any existing ``qa/`` artifacts before generating new ones."
    ) -join "`n")
}

function Get-KiroSteeringContent {
    param([string]$SkillPath)

    $normalizedPath = $SkillPath -replace '\\', '/'
    return (@(
        "# Speckit QA Steering",
        "",
        "Use Speckit QA when the task is QA orchestration for an implemented or in-progress spec.",
        "",
        "- Read ``$normalizedPath/SKILL.md`` first.",
        "- Reuse prompt fragments from ``$normalizedPath/prompts/``.",
        "- Reuse slash command guidance from ``$normalizedPath/slash-commands/``.",
        "- Reuse templates from ``$normalizedPath/templates/``.",
        "- Follow the phase order: initialization, scenarios, execution, reporting, fix, regression.",
        "- Keep QA evidence-driven. Do not mark flows as passing without browser evidence, logs, or screenshots."
    ) -join "`n")
}

function Get-AgentsBlockContent {
    param([string]$SkillPath)

    $normalizedPath = $SkillPath -replace '\\', '/'
    return (@(
        "# Speckit QA",
        "",
        "Use Speckit QA when the user asks for structured QA, spec-based validation, release readiness, blocker analysis, or defect retesting.",
        "",
        "- Read ``$normalizedPath/SKILL.md`` before starting.",
        "- Reuse the supporting materials in ``$normalizedPath/prompts/``, ``$normalizedPath/slash-commands/``, and ``$normalizedPath/templates/``.",
        "- Treat readiness checks, scenario design, browser execution, reporting, fix verification, and regression as separate phases.",
        "- Keep results evidence-based and preserve ``qa/`` artifacts if they already exist."
    ) -join "`n")
}

if (-not $Scope) {
    $Scope = Get-DefaultScope -SelectedTool $Tool
}

$resolvedProjectRoot = Get-ResolvedProjectRoot -ExplicitProjectRoot $ProjectRoot
$installRoot = Resolve-InstallRoot -SelectedTool $Tool -SelectedScope $Scope -ExplicitDestinationRoot $DestinationRoot -ResolvedProjectRoot $resolvedProjectRoot

switch ($Tool) {
    "codex" {
        $target = Install-SkillPackage -InstallRoot $installRoot -SkillName $packageName
        Write-Output "Installed speckit-qa for Codex to $target"
    }
    "claude" {
        $target = Install-SkillPackage -InstallRoot $installRoot -SkillName $packageName
        Write-Output "Installed speckit-qa for Claude to $target"
    }
    "cursor" {
        $target = Install-SkillPackage -InstallRoot $installRoot -SkillName $packageName
        $rulePath = Join-Path $resolvedProjectRoot ".cursor\rules\speckit-qa.mdc"
        Write-ManagedFile -Path $rulePath -Content (Get-CursorRuleContent -SkillPath $target)
        Write-Output "Installed speckit-qa support files to $target"
        Write-Output "Installed Cursor rule to $rulePath"
    }
    "kiro" {
        $target = Install-SkillPackage -InstallRoot $installRoot -SkillName $packageName
        $steeringPath = Join-Path $resolvedProjectRoot ".kiro\steering\speckit-qa.md"
        Write-ManagedFile -Path $steeringPath -Content (Get-KiroSteeringContent -SkillPath $target)
        Write-Output "Installed speckit-qa support files to $target"
        Write-Output "Installed Kiro steering file to $steeringPath"
    }
    "agents" {
        $target = Install-SkillPackage -InstallRoot $installRoot -SkillName $packageName
        $agentsPath = Join-Path $resolvedProjectRoot "AGENTS.md"
        Upsert-MarkedBlock `
            -Path $agentsPath `
            -StartMarker "<!-- speckit-qa:start -->" `
            -EndMarker "<!-- speckit-qa:end -->" `
            -BlockContent (Get-AgentsBlockContent -SkillPath $target)
        Write-Output "Installed speckit-qa support files to $target"
        Write-Output "Updated AGENTS.md at $agentsPath"
    }
}
