#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIG_SRC="$PROJECT_ROOT/config/aerospace/aerospace.toml"
CONFIG_DEST="$HOME/.config/aerospace/aerospace.toml"

echo "🪟 Configurando AeroSpace..."

mkdir -p "$(dirname "$CONFIG_DEST")"

if [[ -f "$CONFIG_SRC" ]]; then
    cp "$CONFIG_SRC" "$CONFIG_DEST"
    echo "✅ Configuração aplicada com sucesso."
else
    echo "❌ Erro: Arquivo de configuração original não encontrado."
fi