#!/bin/bash

BASEDIR=$(dirname "$0")
cd "$BASEDIR"

if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew bundle --file=./Brewfile

mkdir -p ~/.config/aerospace
cp ./aerospace.toml ~/.config/aerospace/aerospace.toml


defaults write com.apple.dock autohide-delay -float 0; 
defaults write com.apple.dock autohide-time-modifier -float 0; 
killall Dock