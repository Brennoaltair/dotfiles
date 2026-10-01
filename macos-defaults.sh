#!/bin/bash

# macOS system defaults
# Run once on a new machine, or re-run safely (idempotent).
# Last synced: 2026-09-26 — values verified against live machine.

set -euo pipefail

log_ok()   { echo "   ✅ $*"; }
log_skip() { echo "   ⏭️  $* (já ok, pulando)"; }

apply() {
    local domain="$1" key="$2" type="$3" value="$4" scope="${5:-}"
    local host_flag=""
    case "$scope" in
        --host) host_flag="-currentHost" ;;
        "")     ;;
        *)      echo "apply: escopo desconhecido: $scope" >&2; exit 1 ;;
    esac

    local current match=false
    current=$(defaults $host_flag read "$domain" "$key" 2>/dev/null || echo "__unset__")

    case "$type" in
        -bool)
            # macOS stores true→1, false→0; normalize before comparing
            local cv nv
            case "$current" in
                1|true)  cv=1 ;;
                0|false) cv=0 ;;
                *)       cv="" ;;
            esac
            [[ "$value" == "1" || "$value" == "true" ]] && nv=1 || nv=0
            [[ -n "$cv" && "$cv" == "$nv" ]] && match=true
            ;;
        -float)
            # IEEE 754 precision: macOS may store extra digits (e.g. 0.1000000014901161)
            # Always write floats — fast and idempotent in effect
            match=false
            ;;
        *)
            [[ "$current" == "$value" ]] && match=true
            ;;
    esac

    if $match; then
        log_skip "$key"
    else
        defaults $host_flag write "$domain" "$key" "$type" "$value"
        log_ok "$key = $value"
    fi
}

main() {
echo ""
echo "⚙️  Aplicando macOS defaults..."

# ── Screenshots ───────────────────────────────────────────────────────────────
apply com.apple.screencapture disable-shadow    -bool  true
apply com.apple.screencapture type              -string png

# ── Fotos / iPhone ────────────────────────────────────────────────────────────
apply com.apple.ImageCapture disableHotPlug -bool true --host

# ── Save / Print dialogs ──────────────────────────────────────────────────────
apply NSGlobalDomain NSNavPanelExpandedStateForSaveMode  -bool true
apply NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
apply NSGlobalDomain PMPrintingExpandedStateForPrint     -bool true
apply NSGlobalDomain PMPrintingExpandedStateForPrint2    -bool true

# ── iCloud ────────────────────────────────────────────────────────────────────
apply NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# ── .DS_Store em externos ─────────────────────────────────────────────────────
apply com.apple.desktopservices DSDontWriteNetworkStores -bool true
apply com.apple.desktopservices DSDontWriteUSBStores     -bool true

# ── Finder ────────────────────────────────────────────────────────────────────
apply NSGlobalDomain      AppleShowAllExtensions          -bool   true
apply com.apple.finder    ShowPathbar                     -bool   true
apply com.apple.finder    ShowStatusBar                   -bool   true
apply com.apple.finder    _FXSortFoldersFirst             -bool   true
apply com.apple.finder    FXDefaultSearchScope            -string SCcf
apply com.apple.finder    FXEnableExtensionChangeWarning  -bool   false
apply com.apple.finder    QuitMenuItem                    -bool   true
apply com.apple.finder    NewWindowTarget                 -string PfAF
apply com.apple.finder    FXPreferredViewStyle            -string icnv
apply com.apple.finder    ShowExternalHardDrivesOnDesktop -bool   true
apply com.apple.finder    ShowRemovableMediaOnDesktop     -bool   true

# ── Teclado ───────────────────────────────────────────────────────────────────
apply NSGlobalDomain KeyRepeat               -int  1
apply NSGlobalDomain InitialKeyRepeat        -int  10
apply NSGlobalDomain ApplePressAndHoldEnabled -bool false

# ── Autocorrect ───────────────────────────────────────────────────────────────
apply NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
apply NSGlobalDomain NSAutomaticCapitalizationEnabled     -bool false
apply NSGlobalDomain NSAutomaticDashSubstitutionEnabled   -bool false
apply NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
apply NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled  -bool false

# ── Dock ──────────────────────────────────────────────────────────────────────
apply com.apple.dock autohide                -bool  true
apply com.apple.dock autohide-delay          -float 0
apply com.apple.dock autohide-time-modifier  -float 0
apply com.apple.dock show-recents            -bool  false
apply com.apple.dock launchanim              -bool  false
apply com.apple.dock mru-spaces              -bool  false
apply com.apple.dock minimize-to-application -bool  true
apply com.apple.dock showhidden              -bool  false
apply com.apple.dock show-process-indicators -bool  false
apply com.apple.dock expose-animation-duration -float 0.1
apply com.apple.dock tilesize                  -int   64
apply com.apple.dock orientation               -string bottom
# Hot corner — bottom right: Quick Note (14)
apply com.apple.dock wvous-br-corner           -int   14
apply com.apple.dock wvous-br-modifier         -int   0

# ── Performance ──────────────────────────────────────────────────────────────
apply NSGlobalDomain NSWindowResizeTime   -float  0.001
apply NSGlobalDomain AppleShowScrollBars  -string WhenScrolling

# ── Segurança ─────────────────────────────────────────────────────────────────
apply com.apple.screensaver askForPassword      -int  1
apply com.apple.screensaver askForPasswordDelay -int  0
# SecureKeyboardEntry: só afeta Terminal.app (mantido por consistência)
apply com.apple.terminal    SecureKeyboardEntry -bool true

# ── Chrome ────────────────────────────────────────────────────────────────────
apply com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

# ── Reinicia processos ────────────────────────────────────────────────────────
echo ""
echo "   🔄 Reiniciando Finder, Dock, SystemUIServer..."
killall Finder       2>/dev/null || true
killall Dock         2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

echo "   ✅ macOS defaults aplicados."
echo ""
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
