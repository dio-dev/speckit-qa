#!/usr/bin/env bash
set -euo pipefail

tool="${1:-codex}"
shift || true

scope=""
destination_root=""
project_root=""

usage() {
  cat <<'EOF'
Usage:
  ./scripts/install.sh [tool] [--scope user|project] [--destination-root PATH] [--project-root PATH]

Tools:
  codex   Install as a Codex skill
  claude  Install as a Claude skill
  cursor  Install project support files and a Cursor rule
  kiro    Install project support files and a Kiro steering file
  agents  Install project support files and a managed AGENTS.md block
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --scope)
      scope="${2:-}"
      shift 2
      ;;
    --destination-root)
      destination_root="${2:-}"
      shift 2
      ;;
    --project-root)
      project_root="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

case "$tool" in
  codex|claude|cursor|kiro|agents)
    ;;
  *)
    printf 'Unsupported tool: %s\n' "$tool" >&2
    usage >&2
    exit 1
    ;;
esac

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
package_name="speckit-qa"
runtime_items=("SKILL.md" "agents" "prompts" "slash-commands" "templates")

default_scope() {
  case "$1" in
    codex|claude)
      printf 'user'
      ;;
    *)
      printf 'project'
      ;;
  esac
}

resolve_project_root() {
  if [[ -n "$project_root" ]]; then
    (cd "$project_root" && pwd)
  else
    pwd
  fi
}

resolve_install_root() {
  local selected_tool="$1"
  local selected_scope="$2"
  local resolved_project_root="$3"

  if [[ -n "$destination_root" ]]; then
    printf '%s' "$destination_root"
    return
  fi

  case "$selected_tool" in
    codex)
      if [[ -n "${CODEX_HOME:-}" ]]; then
        printf '%s/skills' "$CODEX_HOME"
      elif [[ "$selected_scope" == "project" ]]; then
        printf '%s/.codex/skills' "$resolved_project_root"
      else
        printf '%s/.codex/skills' "$HOME"
      fi
      ;;
    claude)
      if [[ "$selected_scope" == "project" ]]; then
        printf '%s/.claude/skills' "$resolved_project_root"
      else
        printf '%s/.claude/skills' "$HOME"
      fi
      ;;
    *)
      printf '%s/.speckit/skills' "$resolved_project_root"
      ;;
  esac
}

install_skill_package() {
  local install_root="$1"
  local target="${install_root}/${package_name}"
  mkdir -p "$target"

  local item
  for item in "${runtime_items[@]}"; do
    rm -rf "${target}/${item}"
    cp -R "${repo_root}/${item}" "${target}/${item}"
  done

  printf '%s' "$target"
}

write_managed_file() {
  local path="$1"
  local content="$2"
  mkdir -p "$(dirname "$path")"
  cat > "$path" <<< "$content"
}

upsert_marked_block() {
  local path="$1"
  local start_marker="$2"
  local end_marker="$3"
  local block_content="$4"
  local tmp_file
  tmp_file="$(mktemp)"
  mkdir -p "$(dirname "$path")"

  if [[ -f "$path" ]] && grep -Fq "$start_marker" "$path" && grep -Fq "$end_marker" "$path"; then
    awk -v start="$start_marker" -v end="$end_marker" -v replacement="$block_content" '
      BEGIN { in_block = 0; replaced = 0 }
      index($0, start) {
        print start
        print replacement
        print end
        in_block = 1
        replaced = 1
        next
      }
      index($0, end) {
        in_block = 0
        next
      }
      !in_block { print }
      END {
        if (!replaced) {
          if (NR > 0) {
            print ""
          }
          print start
          print replacement
          print end
        }
      }
    ' "$path" > "$tmp_file"
  elif [[ -f "$path" ]]; then
    cp "$path" "$tmp_file"
    printf '\n%s\n%s\n%s\n' "$start_marker" "$block_content" "$end_marker" >> "$tmp_file"
  else
    printf '%s\n%s\n%s\n' "$start_marker" "$block_content" "$end_marker" > "$tmp_file"
  fi

  mv "$tmp_file" "$path"
}

normalize_path() {
  printf '%s' "$1" | tr '\\' '/'
}

if [[ -z "$scope" ]]; then
  scope="$(default_scope "$tool")"
fi

resolved_project_root="$(resolve_project_root)"
install_root="$(resolve_install_root "$tool" "$scope" "$resolved_project_root")"

case "$tool" in
  codex)
    target="$(install_skill_package "$install_root")"
    printf 'Installed speckit-qa for Codex to %s\n' "$target"
    ;;
  claude)
    target="$(install_skill_package "$install_root")"
    printf 'Installed speckit-qa for Claude to %s\n' "$target"
    ;;
  cursor)
    target="$(install_skill_package "$install_root")"
    normalized_target="$(normalize_path "$target")"
    rule_path="${resolved_project_root}/.cursor/rules/speckit-qa.mdc"
    cursor_rule_content=$(cat <<EOF
---
description: Structured QA orchestration for Spec-Driven Development workflows
alwaysApply: false
---

- Use Speckit QA when the user asks for structured QA, release readiness, browser verification, or defect retesting based on specs and plans.
- Load and follow \`${normalized_target}/SKILL.md\` before starting QA work.
- Reuse the prompt fragments in \`${normalized_target}/prompts/\`, the slash command docs in \`${normalized_target}/slash-commands/\`, and the report templates in \`${normalized_target}/templates/\`.
- Treat browser execution, screenshots, logs, and blockers as evidence. Do not claim success without verification.
- Reuse any existing \`qa/\` artifacts before generating new ones.
EOF
)
    write_managed_file "$rule_path" "$cursor_rule_content"
    printf 'Installed speckit-qa support files to %s\n' "$target"
    printf 'Installed Cursor rule to %s\n' "$rule_path"
    ;;
  kiro)
    target="$(install_skill_package "$install_root")"
    normalized_target="$(normalize_path "$target")"
    steering_path="${resolved_project_root}/.kiro/steering/speckit-qa.md"
    kiro_steering_content=$(cat <<EOF
# Speckit QA Steering

Use Speckit QA when the task is QA orchestration for an implemented or in-progress spec.

- Read \`${normalized_target}/SKILL.md\` first.
- Reuse prompt fragments from \`${normalized_target}/prompts/\`.
- Reuse slash command guidance from \`${normalized_target}/slash-commands/\`.
- Reuse templates from \`${normalized_target}/templates/\`.
- Follow the phase order: initialization, scenarios, execution, reporting, fix, regression.
- Keep QA evidence-driven. Do not mark flows as passing without browser evidence, logs, or screenshots.
EOF
)
    write_managed_file "$steering_path" "$kiro_steering_content"
    printf 'Installed speckit-qa support files to %s\n' "$target"
    printf 'Installed Kiro steering file to %s\n' "$steering_path"
    ;;
  agents)
    target="$(install_skill_package "$install_root")"
    normalized_target="$(normalize_path "$target")"
    agents_path="${resolved_project_root}/AGENTS.md"
    agents_block_content=$(cat <<EOF
# Speckit QA

Use Speckit QA when the user asks for structured QA, spec-based validation, release readiness, blocker analysis, or defect retesting.

- Read \`${normalized_target}/SKILL.md\` before starting.
- Reuse the supporting materials in \`${normalized_target}/prompts/\`, \`${normalized_target}/slash-commands/\`, and \`${normalized_target}/templates/\`.
- Treat readiness checks, scenario design, browser execution, reporting, fix verification, and regression as separate phases.
- Keep results evidence-based and preserve \`qa/\` artifacts if they already exist.
EOF
)
    upsert_marked_block "$agents_path" "<!-- speckit-qa:start -->" "<!-- speckit-qa:end -->" "$agents_block_content"
    printf 'Installed speckit-qa support files to %s\n' "$target"
    printf 'Updated AGENTS.md at %s\n' "$agents_path"
    ;;
esac
