#!/bin/bash

# Aborta o script em caso de erro e trata variáveis não definidas
set -euo pipefail

DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]:-.}" )" && pwd )"
SKIP_UPDATE=false
# ── Flags ─────────────────────────────────────────────────────────────────────
for arg in "$@"; do
  case "$arg" in
    --skip-update) SKIP_UPDATE=true ;;
    --help|-h)
      echo "Uso: ./install.sh [--skip-update]"
      echo ""
      echo "  --skip-update   Pula o 'brew update' (útil em reruns)"
      exit 0
      ;;
    *)
      echo "Opção desconhecida: $arg" >&2
      echo "Use ./install.sh --help" >&2
      exit 2
      ;;
  esac
done

# ── Helpers ───────────────────────────────────────────────────────────────────
log_ok()   { echo "   ✅ $*"; }
log_skip() { echo "   ⏭️  $* (já ok, pulando)"; }
log_warn() { echo "   ⚠️  $*"; }

# Cria symlink; o que existir no destino (exceto symlink) vira <destino>.bak.<data>
link() {
    local src="$DOTFILES/$1"
    local dst="$HOME/$2"

    if [ ! -e "$src" ] && [ ! -L "$src" ]; then
        log_warn "link: fonte obrigatória não existe: $src"
        return 1
    fi

    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        log_skip "$dst"
        return
    fi

    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -e "$dst" ]; then
        local backup
        backup="$dst.bak.$(date '+%Y%m%d%H%M%S')"
        mv "$dst" "$backup"
        log_warn "backup: $backup"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    log_ok "$dst → $src"
}

install_launch_agent() {
    local template="$DOTFILES/LaunchAgents/com.brenno.brew-autoupdate.plist"
    local dst="$HOME/Library/LaunchAgents/com.brenno.brew-autoupdate.plist"
    local tmp

    mkdir -p "$(dirname "$dst")"
    tmp="$(mktemp "${TMPDIR:-/tmp}/com.brenno.brew-autoupdate.plist.XXXXXX")"
    cp "$template" "$tmp"
    plutil -remove ProgramArguments.0 "$tmp"
    plutil -insert ProgramArguments.0 -string "$DOTFILES/scripts/brew-autoupdate.sh" "$tmp"
    plutil -lint "$tmp" >/dev/null

    if [ -f "$dst" ] && cmp -s "$tmp" "$dst"; then
        rm "$tmp"
        log_skip "$dst"
        return
    fi

    mv -f "$tmp" "$dst"
    log_ok "$dst gerado para este clone"
}

# ── Banner ────────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  dotfiles setup — $(date '+%Y-%m-%d %H:%M')"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Bootstrap remoto (curl) ───────────────────────────────────────────────────
# Executado via curl, o script não está dentro de um clone: clona o repositório
# e reexecuta o install.sh local, que é quem os symlinks e o LaunchAgent usam.
SCRIPT_PATH="${BASH_SOURCE[0]:-}"
if [[ -z "$SCRIPT_PATH" || ! -f "$SCRIPT_PATH" || ! -f "$DOTFILES/Brewfile" ]]; then
    REPO_URL="https://github.com/Brennoaltair/dotfiles.git"
    TARGET="${DOTFILES_DIR:-$HOME/dotfiles}"
    echo "📥 Execução remota: preparando o clone em $TARGET..."

    if [[ "$(uname -s)" != "Darwin" ]]; then
        log_warn "Este setup é compatível apenas com macOS."
        exit 1
    fi
    if ! xcode-select -p &>/dev/null; then
        echo "   📦 Instalando Xcode CLT (necessário para o Git)..."
        xcode-select --install || true
        echo "   ⏳ Conclua a instalação na janela do macOS; aguardando..."
        until xcode-select -p &>/dev/null; do sleep 5; done
        log_ok "Xcode CLT: $(xcode-select -p)"
    fi

    if [ -d "$TARGET/.git" ]; then
        if git -C "$TARGET" pull --ff-only; then
            log_ok "Clone atualizado: $TARGET"
        else
            log_warn "Não foi possível atualizar $TARGET; usando a versão local."
        fi
    elif [ -e "$TARGET" ]; then
        log_warn "$TARGET já existe e não é um clone Git. Mova-o ou defina DOTFILES_DIR."
        exit 1
    else
        git clone "$REPO_URL" "$TARGET"
        log_ok "Clonado em $TARGET"
    fi

    exec /bin/bash "$TARGET/install.sh" "$@"
fi

# ── Compatibilidade ───────────────────────────────────────────────────────────
if [[ "$(uname -s)" != "Darwin" ]]; then
    log_warn "Este setup é compatível apenas com macOS."
    exit 1
fi
if [[ "$(uname -m)" != "arm64" ]]; then
    log_warn "Este setup requer um Mac com Apple Silicon."
    exit 1
fi

MACOS_MAJOR="$(sw_vers -productVersion | cut -d. -f1)"
if (( MACOS_MAJOR < 14 )); then
    log_warn "Este setup requer macOS 14 (Sonoma) ou mais recente."
    exit 1
fi
log_ok "macOS $(sw_vers -productVersion)"

# ── Xcode Command Line Tools ──────────────────────────────────────────────────
echo "🔧 Verificando Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
    echo "   📦 Instalando Xcode CLT (necessário para Homebrew)..."
    xcode-select --install
    echo "   ⏳ Aguarde a instalação terminar e execute este script novamente."
    exit 0
fi
log_ok "Xcode CLT: $(xcode-select -p)"

# ── Senha de administrador ────────────────────────────────────────────────────
# Alguns casks (ex.: logi-options+) usam sudo no meio da instalação; pedir a
# senha agora evita um "Password:" perdido no meio do log.
echo "🔑 Alguns apps exigem sua senha de administrador do macOS."
sudo -v

# ── Homebrew ──────────────────────────────────────────────────────────────────
echo "🍺 Verificando Homebrew..."
if ! command -v brew &> /dev/null; then
    echo "   📦 Não encontrado. Instalando..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"
log_ok "Homebrew: $(brew --version | head -1)"

if $SKIP_UPDATE; then
    log_skip "brew update"
else
    echo "   🔄 Atualizando..."
    brew update --quiet
fi

# ── Apps e CLIs via Brewfile ──────────────────────────────────────────────────
echo ""
echo "📦 Instalando via Brewfile..."
if ! brew bundle --no-upgrade --file="$DOTFILES/Brewfile"; then
    log_warn "brew bundle falhou; nenhum passo dependente será executado. Corrija o erro e rode novamente."
    exit 1
fi
if ! brew bundle check --no-upgrade --file="$DOTFILES/Brewfile"; then
    log_warn "Brewfile incompleto após a instalação; corrija o pacote pendente e rode novamente."
    exit 1
fi
log_ok "Brewfile processado."

# ── Git LFS ───────────────────────────────────────────────────────────────────
echo ""
echo "🗃️  Configurando Git LFS..."
if git lfs install; then
    log_ok "Git LFS ativado."
else
    log_warn "Git LFS: falha ao inicializar."
    exit 1
fi

# ── Symlinks ──────────────────────────────────────────────────────────────────
echo ""
echo "🔗 Criando symlinks..."

link ".zprofile"          ".zprofile"
link ".zshrc"             ".zshrc"
link ".gitconfig"         ".gitconfig"
link ".gitignore_global"  ".gitignore_global"
link ".config/nvim"                 ".config/nvim"
link ".config/ghostty"              ".config/ghostty"
link ".config/cmux/config.ghostty"  "Library/Application Support/com.cmuxterm.app/config.ghostty"
link "aerospace.toml"               ".config/aerospace/aerospace.toml"
install_launch_agent

# ── Brew auto-update (10h diariamente) ────────────────────────────────────────
echo ""
echo "⏰ Agendando update automático do Homebrew..."
LAUNCH_AGENT="$HOME/Library/LaunchAgents/com.brenno.brew-autoupdate.plist"
launchctl bootout "gui/$(id -u)" "$LAUNCH_AGENT" &>/dev/null || true
if launchctl bootstrap "gui/$(id -u)" "$LAUNCH_AGENT"; then
    log_ok "LaunchAgent ativo (roda todo dia às 10h, log em ~/Library/Logs/brew-autoupdate.log)."
else
    log_warn "LaunchAgent: falha ao carregar. Rode manualmente: launchctl bootstrap gui/\$(id -u) ~/Library/LaunchAgents/com.brenno.brew-autoupdate.plist"
    exit 1
fi

# ── macOS defaults ────────────────────────────────────────────────────────────
if ! bash "$DOTFILES/macos-defaults.sh"; then
    log_warn "macos-defaults.sh falhou. Corrija o erro e rode o setup novamente."
    exit 1
fi

# ── Concluído ─────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ Setup concluído!"
echo ""
echo "  Próximos passos:"
echo "  1. Feche e reabra o terminal"
echo ""
echo "  Instalação manual necessária:"
echo "  • Hovercraft → https://sandwich.vision/hovercraft"
echo "  • Maestri → https://www.themaestri.app"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
