# dotfiles

Setup do meu Mac (Apple Silicon, macOS 14+): apps, CLIs, configs de shell/editor/terminal, preferências do macOS e update automático do Homebrew.

## Índice

- [Instalação](#instalação)
- [O que o install.sh faz](#o-que-o-installsh-faz)
- [Estrutura](#estrutura)
- [Apps](#apps)
- [CLIs](#clis)
- [Configs](#configs)
  - [Zsh](#zsh)
  - [Git](#git)
  - [WezTerm](#wezterm)
  - [Neovim](#neovim)
  - [AeroSpace](#aerospace)
- [macOS defaults](#macos-defaults)
- [Update automático](#update-automático)
- [Checks](#checks)

## Instalação

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Brennoaltair/dotfiles/main/install.sh)"
```

Executado via `curl`, o script clona o repositório em `~/dotfiles` (ou em `$DOTFILES_DIR`) e roda o `install.sh` local. Num clone existente:

```bash
./install.sh                # setup completo
./install.sh --skip-update  # pula o brew update (útil em reruns)
```

O script é idempotente: rodar de novo só aplica o que mudou.

## O que o install.sh faz

1. Confere se a máquina é macOS 14+ com Apple Silicon.
2. Instala o Xcode Command Line Tools, se faltar.
3. Pede a senha de administrador logo no início, porque alguns casks usam `sudo`.
4. Instala o Homebrew, se faltar, e roda `brew update`.
5. Instala tudo do `Brewfile` com `brew bundle`.
6. Ativa o Git LFS.
7. Cria os symlinks das configs. Se já existir um arquivo no destino, ele vira `<destino>.bak.<data>`.
8. Gera e carrega o LaunchAgent do update automático.
9. Aplica os [macOS defaults](#macos-defaults).

## Estrutura

| Arquivo | Destino | Para quê |
|---|---|---|
| `install.sh` | — | Setup completo |
| `Brewfile` | — | Apps, CLIs, apps da Mac App Store e pacotes npm globais |
| `macos-defaults.sh` | — | Preferências do sistema |
| `.zshrc` | `~/.zshrc` | Shell interativo |
| `.zprofile` | `~/.zprofile` | Login shell (Homebrew, PATH) |
| `.gitconfig` | `~/.gitconfig` | Git |
| `.gitignore_global` | `~/.gitignore_global` | Ignores globais |
| `.config/wezterm/` | `~/.config/wezterm/` | Terminal |
| `.config/nvim/` | `~/.config/nvim/` | Editor |
| `aerospace.toml` | `~/.config/aerospace/aerospace.toml` | Gerenciador de janelas |
| `LaunchAgents/` | `~/Library/LaunchAgents/` | Agenda do update automático |
| `scripts/brew-autoupdate.sh` | — | Update diário do Homebrew e da App Store |
| `scripts/check.sh` | — | Validação local e no CI |

## Apps

| App | Para quê |
|---|---|
| [AeroSpace](https://github.com/nikitabobko/AeroSpace) | Workspaces virtuais |
| [Bitwarden](https://bitwarden.com) | Gerenciador de senhas |
| [Claude](https://claude.ai/download) | Assistente de IA |
| [Discord](https://discord.com) | Chat |
| [Docker Desktop](https://www.docker.com/products/docker-desktop/) | Containers |
| [Figma](https://www.figma.com) | Design |
| [Google Chrome](https://www.google.com/chrome/) | Navegador |
| [Ice](https://github.com/jordanbaird/Ice) | Organiza a barra de menus |
| [Keyboard Maestro](https://www.keyboardmaestro.com) | Automação |
| [LocalSend](https://localsend.org) | Transferência de arquivos na rede local |
| [Logi Options+](https://www.logitech.com/software/logi-options-plus.html) | Mouse e teclado Logitech |
| [Notion](https://www.notion.so) | Notas e docs |
| [Obsidian](https://obsidian.md) | Notas em Markdown |
| [Raycast](https://www.raycast.com) | Launcher |
| [Shottr](https://shottr.cc) | Screenshots |
| Vorssaint | — |
| [WezTerm](https://wezterm.org) | Terminal |
| [Zed](https://zed.dev) | Editor |
| MesloLGS Nerd Font | Fonte do terminal |

**Segurança ([Objective-See](https://objective-see.org)):** LuLu (firewall de saída), BlockBlock (alerta de persistência) e KnockKnock (lista o que roda no boot).

**Mac App Store:** ScreenBrush e RAR Extractor.

**Instalação manual:**

- [Hovercraft](https://sandwich.vision/hovercraft)
- [Maestri](https://www.themaestri.app)

## CLIs

| CLI | Para quê |
|---|---|
| `ffmpeg` | Áudio e vídeo |
| `gh` / `glab` | GitHub / GitLab |
| `git-lfs` | Arquivos grandes no Git |
| `jq` | JSON |
| `mas` | Mac App Store pela linha de comando |
| `neovim` | Editor |
| `node` | Runtime JS |
| `pipx` | Apps Python isolados |
| `sevenzip` | `.7z` |
| `shellcheck` | Lint de shell |
| `yt-dlp` | Download de vídeos |
| `zoxide` | `cd` inteligente (`z`) |
| `zsh-autosuggestions` / `zsh-syntax-highlighting` | Plugins do zsh |
| `pnpm` / `vercel` | Instalados via npm global |

## Configs

### Zsh

- Histórico de 50 mil entradas, compartilhado entre sessões; `↑`/`↓` buscam pelo prefixo digitado.
- `Shift+Enter` insere uma nova linha em vez de executar.
- Plugins: zoxide, autosuggestions e syntax highlighting.

| Alias / função | O que faz |
|---|---|
| `..` / `...` / `....` | Sobe 1, 2 ou 3 diretórios |
| `g`, `gs`, `ga`, `gaa` | `git`, `status -sb`, `add`, `add -A` |
| `gc`, `gcm`, `gp`, `gpl` | `commit`, `commit -m`, `push`, `pull` |
| `gco`, `gbr`, `gdiff` | `checkout`, `branch`, `diff` |
| `glg` | Log em grafo de todas as branches |
| `gundo` | Desfaz o último commit, mantendo as mudanças |
| `ports` | Portas TCP escutando |
| `ip` | IP público |
| `reload` | Recarrega o `.zshrc` |
| `dotfiles` | Vai para este repositório |
| `mkcd <dir>` | Cria o diretório e entra nele |
| `extract <arquivo>` | Extrai `.tar.*`, `.zip`, `.gz`, `.bz2` e `.7z` |
| `pr` | Abre o PR da branch no navegador, ou cria um |
| `serve [porta]` | Servidor HTTP no diretório atual (porta padrão 8000) |

### Git

- `pull` com rebase.
- `push` cria o upstream automaticamente.
- Branch padrão `main`.
- Git LFS ativo e ignores globais em `.gitignore_global` (macOS, editores, Node, Python, `.env`).

### WezTerm

Fundo preto, MesloLGS Nerd Font 19pt, sem barra de abas nem título, 10 mil linhas de scrollback. `Shift+Enter` manda `ESC+CR`, que o zsh e os TUIs tratam como nova linha.

### Neovim

Config mínima: quebra de linha por palavra e o tema padrão em preto puro, combinando com o terminal.

### AeroSpace

Todas as janelas abrem flutuantes no workspace atual, sem tiling automático. Inicia no login.

| Tecla | O que faz |
|---|---|
| `Alt+1…8` | Vai para o workspace |
| `Alt+Shift+1…8` | Manda a janela para o workspace |
| `Alt+Shift+R` | Recarrega a config |

## macOS defaults

`macos-defaults.sh` só escreve o que difere do valor atual e no fim reinicia Finder, Dock e SystemUIServer.

| Área | Ajustes |
|---|---|
| Screenshots | PNG, sem sombra |
| Finder | Mostra extensões, path bar e status bar; pastas primeiro; busca na pasta atual; novas janelas abrem em Recentes; menu "Sair"; discos externos na mesa |
| Teclado | Repetição de tecla rápida, sem acentos ao segurar a tecla |
| Autocorreção | Desliga correção, capitalização e substituição de aspas, traços e pontos |
| Dock | Esconde automaticamente sem delay, sem recentes nem animações, ícones de 64px, minimiza para o app |
| Hot corner | Canto inferior direito abre a Nota Rápida |
| Mission Control | Não reordena os Spaces sozinho |
| Diálogos | Salvar e imprimir expandidos; salva localmente em vez do iCloud |
| `.DS_Store` | Não cria em volumes de rede e USB |
| Segurança | Pede a senha logo após a proteção de tela |
| Outros | Não abre o app Fotos ao conectar o iPhone; desliga o swipe de voltar no Chrome; barras de rolagem só ao rolar |

Para aplicar só os defaults:

```bash
bash macos-defaults.sh
```

## Update automático

Um LaunchAgent roda `scripts/brew-autoupdate.sh` todo dia às 10h: `brew update`, `brew upgrade`, `brew cleanup` e `mas upgrade`. O resultado aparece numa notificação e o log fica em `~/Library/Logs/brew-autoupdate.log`.

## Checks

```bash
./scripts/check.sh
```

Valida a sintaxe dos scripts e do zsh, roda o shellcheck, valida o plist, o TOML, as configs Lua e o Brewfile, e testa os symlinks, o LaunchAgent e o update automático num `$HOME` temporário, sem instalar nada nem mexer nas preferências. Roda também no GitHub Actions a cada push e PR.
