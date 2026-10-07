#!/bin/bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

for script in install.sh macos-defaults.sh scripts/*.sh; do
    bash -n "$script"
done
for script in .zprofile .zshrc; do
    zsh -n "$script"
done
shellcheck -x install.sh macos-defaults.sh scripts/brew-autoupdate.sh scripts/check.sh
plutil -lint LaunchAgents/com.brenno.brew-autoupdate.plist >/dev/null
python3 -c 'import pathlib, tomllib; [tomllib.loads(pathlib.Path(path).read_text()) for path in ("aerospace.toml",)]'
nvim --clean --headless -i NONE -u .config/nvim/init.lua \
    '+qa'
env HOMEBREW_NO_AUTO_UPDATE=1 brew bundle list --all --file=Brewfile >/dev/null

(
    source "$ROOT/macos-defaults.sh"
    writes=0
    current_value=""
    defaults() {
        if [[ "$1" == "read" ]]; then
            if [[ -z "$current_value" ]]; then
                return 1
            fi
            echo "$current_value"
            return
        fi
        writes=$((writes + 1))
    }

    apply test.domain TestKey -bool false >/dev/null
    [[ "$writes" -eq 1 ]] || exit 1

    writes=0
    current_value=0
    apply test.domain TestKey -bool false >/dev/null
    [[ "$writes" -eq 0 ]] || exit 1
)

(
    # shellcheck disable=SC2034 # usado pelas funções carregadas via eval
    DOTFILES="$ROOT"
    HOME="$(mktemp -d)"
    eval "$(sed -n '/^# ── Helpers/,/^# ── Banner/p' install.sh)"
    mkdir -p "$HOME/.config/nvim"
    eval "$(grep '^link ' install.sh)" >/dev/null
    [[ "$(grep -c '^link ' install.sh)" -eq 7 ]] || exit 1
    while read -r _ src dst; do
        [[ "$(readlink "$HOME/${dst//\"/}")" == "$ROOT/${src//\"/}" ]] || exit 1
    done < <(grep '^link ' install.sh)
    rm -rf "$HOME"
)

python3 scripts/test-regressions.py

echo "Checks passed."
