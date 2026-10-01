#!/bin/bash
# Atualiza Homebrew (formulas + casks) e Mac App Store, roda via launchd às 10h.
# Log: ~/Library/Logs/brew-autoupdate.log

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
LOG="$HOME/Library/Logs/brew-autoupdate.log"

notify() {
    osascript -e "display notification \"$1\" with title \"Homebrew Auto-Update\"" &>/dev/null
}

if ! mkdir -p "$(dirname "$LOG")" || ! exec >>"$LOG" 2>&1; then
    notify "Falha ao abrir $LOG — nada foi atualizado"
    exit 1
fi

FAILED=0
echo ""
echo "=== $(date '+%Y-%m-%d %H:%M:%S') ==="
if command -v brew &>/dev/null; then
    brew update || FAILED=1
    brew upgrade || FAILED=1
    brew cleanup -s || FAILED=1
else
    echo "brew não encontrado"
    FAILED=1
fi

if command -v mas &>/dev/null; then
    mas upgrade || FAILED=1
else
    echo "mas não encontrado"
    FAILED=1
fi

if [ "$FAILED" -eq 0 ]; then
    notify "Apps atualizados com sucesso"
else
    notify "Falha ao atualizar — veja $LOG"
fi

exit "$FAILED"
