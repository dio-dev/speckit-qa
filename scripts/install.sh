#!/usr/bin/env bash
set -euo pipefail

destination_root="${1:-}"

if [[ -z "${destination_root}" ]]; then
  if [[ -n "${CODEX_HOME:-}" ]]; then
    destination_root="${CODEX_HOME}/skills"
  else
    destination_root="${HOME}/.codex/skills"
  fi
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target="${destination_root}/speckit-qa"

mkdir -p "${target}"

copy_item() {
  local item="$1"
  rm -rf "${target}/${item}"
  cp -R "${repo_root}/${item}" "${target}/${item}"
}

copy_item "SKILL.md"
copy_item "agents"
copy_item "prompts"
copy_item "slash-commands"
copy_item "templates"

printf 'Installed speckit-qa to %s\n' "${target}"
