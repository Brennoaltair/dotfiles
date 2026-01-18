#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "❌ Erro: Este script foi feito apenas para macOS."
  exit 1
fi
echo "✅ macOS detectado."