# Speckit QA

Structured QA orchestration for Spec-Driven Development workflows.

This repository packages the `speckit-qa` workflow so it can be installed in multiple AI coding environments:

- Codex as a skill
- Claude Code as a skill
- Cursor as a project rule plus local support files
- Kiro as a steering file plus local support files
- Other `AGENTS.md`-style tools through a managed `AGENTS.md` block

## What It Does

The workflow adds a disciplined QA layer on top of specs and implementation plans:

- `qa.init` for readiness analysis and blocker discovery
- `qa.scenarios` for executable scenario design
- `qa.run` for evidence-based browser execution
- `qa.report` for merge or release recommendations
- `qa.fix` for tracked defect remediation and retest
- `qa.regression` for broader post-fix verification

## Repository Layout

- `SKILL.md`: primary workflow instructions
- `agents/`: agent metadata
- `prompts/`: phase-specific prompt fragments
- `slash-commands/`: command entrypoints for the workflow
- `templates/`: reusable QA artifact templates
- `scripts/install.ps1`: Windows installer
- `scripts/install.sh`: macOS and Linux installer

## Install

### Quick Commands

PowerShell:

```powershell
.\scripts\install.ps1 codex
.\scripts\install.ps1 -Tool claude
.\scripts\install.ps1 -Tool cursor -ProjectRoot C:\path\to\repo
.\scripts\install.ps1 -Tool kiro -ProjectRoot C:\path\to\repo
.\scripts\install.ps1 -Tool agents -ProjectRoot C:\path\to\repo
```

Bash:

```bash
./scripts/install.sh codex
./scripts/install.sh claude
./scripts/install.sh cursor --project-root /path/to/repo
./scripts/install.sh kiro --project-root /path/to/repo
./scripts/install.sh agents --project-root /path/to/repo
```

### Tool Targets

#### Codex

Default install target:

```text
$CODEX_HOME/skills/speckit-qa
```

If `CODEX_HOME` is not set:

```text
$HOME/.codex/skills/speckit-qa
```

#### Claude Code

User install target:

```text
~/.claude/skills/speckit-qa
```

Project install target:

```text
<repo>/.claude/skills/speckit-qa
```

Example:

```powershell
.\scripts\install.ps1 -Tool claude -Scope project -ProjectRoot C:\path\to\repo
```

```bash
./scripts/install.sh claude --scope project --project-root /path/to/repo
```

#### Cursor

The installer creates:

- `<repo>/.speckit/skills/speckit-qa/`
- `<repo>/.cursor/rules/speckit-qa.mdc`

The rule points Cursor at the packaged workflow files inside `.speckit/skills/speckit-qa/`.

#### Kiro

The installer creates:

- `<repo>/.speckit/skills/speckit-qa/`
- `<repo>/.kiro/steering/speckit-qa.md`

The steering file points Kiro at the packaged workflow files inside `.speckit/skills/speckit-qa/`.

#### Other AGENTS.md Tools

The installer creates:

- `<repo>/.speckit/skills/speckit-qa/`
- a managed block inside `<repo>/AGENTS.md`

The managed block is wrapped with:

```text
<!-- speckit-qa:start -->
<!-- speckit-qa:end -->
```

Re-running the installer updates only that block.

### Advanced Options

PowerShell:

```powershell
.\scripts\install.ps1 -Tool cursor -ProjectRoot C:\path\to\repo
.\scripts\install.ps1 -Tool claude -Scope user
.\scripts\install.ps1 -Tool codex -DestinationRoot D:\custom\skills
```

Bash:

```bash
./scripts/install.sh cursor --project-root /path/to/repo
./scripts/install.sh claude --scope user
./scripts/install.sh codex --destination-root /custom/skills
```

Parameters:

- `Tool`: `codex`, `claude`, `cursor`, `kiro`, or `agents`
- `Scope`: `user` or `project`
- `ProjectRoot`: target repository for project-scoped installs
- `DestinationRoot`: override the default install root

## Usage

Reference the workflow by name when working on a feature that already has specs and implementation artifacts.

Example prompts:

- `Use speckit-qa to initialize QA for this feature.`
- `Run qa.scenarios for the current spec and implementation plan.`
- `Use speckit-qa and execute qa.report from the existing QA artifacts.`

For Cursor, Kiro, and `AGENTS.md`-based tools, ask for Speckit QA explicitly if the tool does not auto-attach the installed guidance.

## Expected Project Artifacts

The workflow works best when the target repository already contains some of the following:

- `specs/`
- `.specify/`
- `.speckit/`
- `docs/`
- `test/` or `tests/`
- `e2e/`
- `qa/`

## Notes

- The workflow is intentionally evidence-driven and does not treat unverified flows as passing.
- Browser execution assumes the host environment provides the needed browser automation capability.
- The installers copy only `SKILL.md`, `agents/`, `prompts/`, `slash-commands/`, and `templates/`.
- No runtime dependencies are required for the workflow itself.
