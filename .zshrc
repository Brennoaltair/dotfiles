# ── History ───────────────────────────────────────────────────────────────────
HISTFILE=$HOME/.zhistory
SAVEHIST=50000
HISTSIZE=50000
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# ── Key bindings ──────────────────────────────────────────────────────────────
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Shift+Enter (Ghostty sends ESC+CR) inserts a literal newline instead of submitting
insert-newline-widget() { LBUFFER+=$'\n' }
zle -N insert-newline-widget
bindkey '^[^M' insert-newline-widget

# ── Aliases ───────────────────────────────────────────────────────────────────

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Git
alias g="git"
alias gs="git status -sb"
alias ga="git add"
alias gaa="git add -A"
alias gc="git commit"
alias gcm="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gco="git checkout"
alias gbr="git branch"
alias glg="git log --oneline --graph --decorate --all"
alias gundo="git reset --soft HEAD~1"
alias gdiff="git diff"

# Utils
alias df="df -h"
alias du="du -sh"
alias ports="lsof -iTCP -sTCP:LISTEN -n -P"
alias ip="curl -s https://ipinfo.io/ip"
alias reload="source ~/.zshrc"
alias dotfiles='cd "$(dirname "$(readlink ~/.zshrc)")"'

# ── Functions ─────────────────────────────────────────────────────────────────

mkcd() { mkdir -p "$1" && cd "$1"; }

extract() {
  case "$1" in
    *.tar.bz2) tar xjf "$1"  ;;
    *.tar.gz)  tar xzf "$1"  ;;
    *.tar.xz)  tar xJf "$1"  ;;
    *.tar)     tar xf  "$1"  ;;
    *.bz2)     bunzip2 "$1"  ;;
    *.gz)      gunzip  "$1"  ;;
    *.zip)     unzip   "$1"  ;;
    *.7z)      7zz x    "$1"  ;;
    *)         echo "'$1': formato não reconhecido" >&2; return 1 ;;
  esac
}

pr() { gh pr view --web 2>/dev/null || gh pr create --web; }

serve() { python3 -m http.server "${1:-8000}"; }

# ── Environment ────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"
export BAT_THEME="tokyonight_night"

# ── zoxide (smarter cd) ────────────────────────────────────────────────────────
eval "$(zoxide init zsh)"

# ── Autosuggestions ───────────────────────────────────────────────────────────
if command -v brew &>/dev/null; then
  AUTOSUGGESTIONS="$(brew --prefix zsh-autosuggestions)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [[ -r "$AUTOSUGGESTIONS" ]] && source "$AUTOSUGGESTIONS"
fi


# ── Syntax highlighting (precisa ser o último plugin carregado) ───────────────
if command -v brew &>/dev/null; then
  SYNTAX_HIGHLIGHTING="$(brew --prefix zsh-syntax-highlighting)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  [[ -r "$SYNTAX_HIGHLIGHTING" ]] && source "$SYNTAX_HIGHLIGHTING"
fi
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/brennoaltair/.docker/completions $fpath)
autoload -Uz compinit
(( ${+_comps[docker]} )) || compinit
# End of Docker CLI completions
