# Speckit QA

Structured QA orchestration for Spec-Driven Development workflows.

This repository packages the `speckit-qa` skill as a standalone, installable unit. It is intended for AI coding environments that support skill folders with a top-level `SKILL.md` plus supporting prompts, templates, and slash commands.

## What It Does

The skill adds a disciplined QA workflow on top of specs and implementation plans:

- `qa.init` for readiness analysis and blocker discovery
- `qa.scenarios` for executable scenario design
- `qa.run` for evidence-based browser execution
- `qa.report` for merge or release recommendations
- `qa.fix` for tracked defect remediation and retest
- `qa.regression` for broader post-fix verification

## Repository Layout

- `SKILL.md`: primary skill instructions
- `agents/`: agent metadata
- `prompts/`: phase-specific prompt fragments
- `slash-commands/`: command entrypoints for the workflow
- `templates/`: reusable QA artifact templates

## Install

### Option 1: clone directly into your skills directory

Clone this repository into your Codex skills directory as `speckit-qa`.

Typical target:

```text
.codex/skills/speckit-qa/
```

The final layout should look like:

```text
speckit-qa/
  SKILL.md
  agents/
  prompts/
  slash-commands/
  templates/
```

### Option 2: clone anywhere, then run the installer

PowerShell:

```powershell
.\scripts\install.ps1
```

Bash:

```bash
./scripts/install.sh
```

Both installers copy only the runtime skill files into:

```text
$HOME/.codex/skills/speckit-qa
```

If `CODEX_HOME` is set, they install into:

```text
$CODEX_HOME/skills/speckit-qa
```

## Usage

Reference the skill by name when working on a feature that already has specs and implementation artifacts.

Example prompts:

- `Use speckit-qa to initialize QA for this feature.`
- `Run qa.scenarios for the current spec and implementation plan.`
- `Use speckit-qa and execute qa.report from the existing QA artifacts.`

You can also wire the slash commands into your local workflow if your environment supports command-style skill triggers.

## Expected Project Artifacts

The skill works best when the target repository already contains some of the following:

- `specs/`
- `.specify/`
- `.speckit/`
- `docs/`
- `test/` or `tests/`
- `e2e/`
- `qa/`

## Notes

- The skill is intentionally evidence-driven and does not treat unverified flows as passing.
- Browser execution assumes the host environment provides the needed browser automation capability.
- The installer scripts copy `SKILL.md`, `agents/`, `prompts/`, `slash-commands/`, and `templates/`.
- No runtime dependencies are required for the skill itself.
