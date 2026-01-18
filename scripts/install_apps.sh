#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "📦 Instalando aplicativos via Brewfile..."

if [[ -f "$PROJECT_ROOT/Brewfile" ]]; then
    brew bundle --file="$PROJECT_ROOT/Brewfile"
else
    echo "⚠️ Brewfile não encontrado!"
fi