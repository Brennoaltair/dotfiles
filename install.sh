#!/usr/bin/env bash
set -euo pipefail

# Pega o caminho de onde este script está rodando
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Iniciando Setup do macOS (Brenno A) ==="

# Dá permissão para os scripts serem executados
chmod +x "$DOTFILES_DIR/scripts/"*.sh

# Executa um por um na ordem
source "$DOTFILES_DIR/scripts/check_os.sh"
source "$DOTFILES_DIR/scripts/install_brew.sh"
source "$DOTFILES_DIR/scripts/install_apps.sh"
source "$DOTFILES_DIR/scripts/install_aerospace.sh"
source "$DOTFILES_DIR/scripts/cleanup.sh"

echo "=== Instalação Concluída ==="
echo "ℹ️  Reinicie o computador para aplicar todas as mudanças."