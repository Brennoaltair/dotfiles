#!/bin/bash

BASEDIR=$(dirname "$0")
cd "$BASEDIR"

if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew update

echo "Verificando aplicativos instalados..."
if brew bundle check --file=./Brewfile &> /dev/null; then
    echo "✅ Todos os aplicativos já estão presentes. Nenhuma instalação necessária."
else
    echo "📦 Alguns aplicativos estão faltando. Iniciando instalação..."
    if brew bundle --file=./Brewfile; then
        echo "✅ Instalação concluída com sucesso!"
    else
        echo "❌ Ocorreu um erro durante a instalação."
    fi
fi

mkdir -p ~/.config/aerospace
cp ./aerospace.toml ~/.config/aerospace/aerospace.toml


defaults write com.apple.dock autohide-delay -float 0; 
defaults write com.apple.dock autohide-time-modifier -float 0; 
killall Dock
