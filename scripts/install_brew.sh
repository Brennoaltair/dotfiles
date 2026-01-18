#!/usr/bin/env bash
set -euo pipefail

echo "🍺 Verificando Homebrew..."

if ! command -v brew >/dev/null 2>&1; then
  echo "-> Homebrew não encontrado. Instalando..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "-> Homebrew já instalado. Atualizando..."
  brew update
fi