# dotfiles

Configuração pessoal para preparar um Mac Apple Silicon com macOS 14 (Sonoma) ou mais recente. O setup instala aplicativos, ferramentas de terminal e preferências do sistema.

Última revisão: 30 de setembro de 2026.

## Requisitos

- Mac com Apple Silicon e macOS 14 ou mais recente
- Acesso de administrador
- Conexão com a internet
- Sessão iniciada na Mac App Store

Algumas permissões do macOS continuam manuais, especialmente Accessibility para o AeroSpace. Chaves SSH/GPG, sessões de navegadores e credenciais de CLIs também não pertencem a este repositório.

## Instalação

Num Mac novo, basta um comando:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Brennoaltair/dotfiles/main/install.sh)"
```

O script instala o Xcode Command Line Tools se necessário (aguarda você
concluir a janela do macOS), clona o repositório em `~/dotfiles` e executa o
instalador local a partir do clone. Para usar outra pasta, defina
`DOTFILES_DIR=/caminho` antes do comando. Se `~/dotfiles` já for um clone, ele
é atualizado com `git pull --ff-only`.

Alternativamente, clone manualmente e execute o instalador:

```bash
git clone https://github.com/Brennoaltair/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Mantenha a pasta clonada: os links das configurações e o LaunchAgent dependem
dela. O instalador usa os arquivos locais do clone, sem cloná-lo novamente.

O script pode ser executado novamente: etapas já concluídas são puladas. Arquivos e pastas existentes nos destinos dos links são movidos para `<destino>.bak.<data>` antes de serem substituídos; symlinks antigos são apenas removidos. Para evitar uma nova atualização do Homebrew em uma repetição:

```bash
./install.sh --skip-update
```

Use `./install.sh --help` para ver as opções disponíveis.

### Etapas que exigem interação

1. Conclua a instalação do Xcode Command Line Tools quando a janela do macOS aparecer.
2. Entre na Mac App Store antes de executar o setup.
3. Após a instalação, autorize o AeroSpace em **System Settings → Privacy & Security → Accessibility**.

## O que o setup faz

1. Valida o sistema e exige macOS 14 ou mais recente.
2. Instala o Xcode Command Line Tools e o Homebrew quando necessário.
3. Instala os casks, CLIs, apps da Mac App Store e pacotes npm globais declarados no `Brewfile`.
4. Configura o Git LFS.
5. Cria links para as configurações versionadas, com backup do que existir no destino.
6. Agenda a atualização diária do Homebrew e da Mac App Store para 10h.
7. Aplica as preferências descritas em `macos-defaults.sh`.

Qualquer etapa obrigatória que falhar interrompe a execução. Assim, uma instalação parcial não é apresentada como concluída.

## Stack

| Categoria | Ferramenta |
|---|---|
| Terminal | WezTerm |
| Shell | Zsh |
| Editor | Neovim e Zed |
| Window manager | AeroSpace |
| Launcher | Raycast |
| Pacotes | Homebrew + Brewfile |

## Estrutura

```text
dotfiles/
├── .config/
│   ├── nvim/init.lua
│   └── wezterm/wezterm.lua
├── .github/workflows/check.yml
├── LaunchAgents/com.brenno.brew-autoupdate.plist
├── scripts/
│   ├── brew-autoupdate.sh
│   ├── check.sh
│   └── test-regressions.py
├── .gitconfig
├── .gitignore_global
├── .zprofile
├── .zshrc
├── aerospace.toml
├── Brewfile
├── install.sh
└── macos-defaults.sh
```

## Zsh

### Aliases

| Alias | Ação |
|---|---|
| `dotfiles` | Abre este repositório |
| `ports` | Lista portas TCP em uso |
| `ip` | Mostra o IP público |
| `reload` | Recarrega o `.zshrc` |
| `..`, `...`, `....` | Sobe diretórios |
| `g`, `gs`, `ga`, `gaa`, `gc`, `gcm`, `gp`, `gpl`, `gco`, `gbr` | Atalhos Git |
| `glg`, `gundo`, `gdiff` | Histórico, desfazer commit e diff |

### Funções

| Função | Ação |
|---|---|
| `mkcd <dir>` | Cria e entra em um diretório |
| `extract <arquivo>` | Extrai tar, gzip, bzip2, zip e 7z |
| `pr` | Abre ou cria o PR do branch atual |
| `serve [porta]` | Serve a pasta atual via HTTP; porta padrão 8000 |

O histórico mantém 50 mil comandos, é compartilhado entre sessões e evita duplicatas consecutivas.

## AeroSpace

| Tecla | Ação |
|---|---|
| `Alt+Q` | Layout vertical accordion |
| `Alt+W` | Layout horizontal accordion |
| `Alt+E` | Layout tiles |
| `Alt+1` … `Alt+8` | Abre um workspace |
| `Alt+Shift+1` … `Alt+Shift+8` | Move a janela para um workspace |
| `Alt+;` | Volta para a janela anterior |
| `Alt+Shift+Space` | Alterna entre janela flutuante e tiling |
| `Alt+Shift+R` | Recarrega a configuração |
| `Alt+N` | Abre Notion |
| `Alt+T` | Abre WezTerm |
| `Alt+F` | Abre Finder |
| `Alt+B` | Abre Bitwarden |
| `Alt+G` | Abre GitHub |

Zed abre no workspace 2; Notion, Obsidian e Notes no 3; Discord no 4. Aplicativos utilitários definidos em `aerospace.toml` abrem como janelas flutuantes.

## Preferências do macOS

O setup executa `macos-defaults.sh`, que configura:

- screenshots sem sombra;
- diálogos de salvar e imprimir expandidos;
- documentos novos salvos localmente por padrão;
- Finder com extensões, path bar, status bar e pastas primeiro;
- repetição rápida do teclado e autocorreções desativadas;
- Dock com auto-hide, animações reduzidas e sem apps recentes;
- scrollbars automáticas;
- senha imediata após o descanso de tela;
- Secure Keyboard Entry no Terminal.app;
- workspaces sem reordenação automática.

## Aplicativos

O `Brewfile` é a fonte de verdade da instalação automática.

### Aplicativos gráficos

- AeroSpace, Bitwarden, Claude, Discord, Docker Desktop, Figma, Google Chrome
- Keyboard Maestro, LocalSend, Logi Options+, Notion, Obsidian
- Raycast, Shottr, Vorssaint, WezTerm e Zed
- Fonte MesloLG Nerd Font

### Mac App Store

- ScreenBrush
- RAR Extractor - Unarchiver

### Ferramentas de terminal

- ffmpeg, gh, git-lfs, glab
- jq, mas, neovim, node, pipx, sevenzip, shellcheck
- yt-dlp, zoxide
- zsh-autosuggestions e zsh-syntax-highlighting

### Pacotes npm globais

- pnpm e vercel

### Instalação manual

| Aplicativo | Link |
|---|---|
| Gnome | https://lexfriedman.com/gnome/ |
| Hovercraft | https://sandwich.vision/hovercraft |
| Maestri | https://www.themaestri.app |

## Atualizações automáticas

O LaunchAgent executa `scripts/brew-autoupdate.sh` diariamente às 10h. Ele atualiza fórmulas, casks e apps da Mac App Store e registra o resultado em `~/Library/Logs/brew-autoupdate.log`.

## Verificação

```bash
./scripts/check.sh
```

A verificação cobre sintaxe de Bash, Zsh, Lua, TOML e plist, inicialização do Neovim, ShellCheck, parsing do Brewfile e a regressão dos valores booleanos do `macos-defaults.sh`. Também testa extração 7z e formato não suportado, códigos de saída das atualizações (inclusive com o log inacessível), backup dos destinos dos links e geração repetida do LaunchAgent em caminhos com caracteres XML. O mesmo comando roda no GitHub Actions em macOS.

## Pós-instalação

1. Feche e reabra o terminal.
2. Autorize o AeroSpace em Accessibility.
3. Instale Gnome, Hovercraft e Maestri, se ainda forem necessários.
4. Restaure separadamente chaves SSH/GPG, autenticação de `gh`/`glab`, perfis de navegadores e dados de aplicativos.
