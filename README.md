# dotfiles

Meu setup de Mac (Apple Silicon, macOS 14+).

## Instalação

Entre na Mac App Store e rode:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Brennoaltair/dotfiles/main/install.sh)"
```

O repositório fica em `~/dotfiles`. Não apague a pasta, as configurações apontam pra ela.

Depois:

1. Reabra o terminal.
2. Libere o AeroSpace em **Ajustes do Sistema → Privacidade e Segurança → Acessibilidade**.
3. Instale na mão o que não vem pelo Homebrew (lista abaixo).

## O que ele faz

- Instala Homebrew, apps, CLIs e pacotes do `Brewfile`
- Liga as configs de Zsh, Git, Neovim, WezTerm e AeroSpace
- Aplica as preferências do macOS (`macos-defaults.sh`)
- Atualiza Homebrew e Mac App Store todo dia às 10h

Pode rodar de novo sem medo: o que já está pronto é pulado.

## Apps

AeroSpace, Bitwarden, Claude, Discord, Docker Desktop, Figma, Google Chrome, Keyboard Maestro, LocalSend, Logi Options+, Notion, Obsidian, Raycast, Shottr, Vorssaint, WezTerm, Zed, ScreenBrush e RAR Extractor.

Instalação manual:

- [Gnome](https://lexfriedman.com/gnome/)
- [Hovercraft](https://sandwich.vision/hovercraft)
- [Maestri](https://www.themaestri.app)

## CLIs

ffmpeg, gh, git-lfs, glab, jq, mas, neovim, node, pipx, sevenzip, shellcheck, yt-dlp, zoxide, pnpm e vercel.

## Atalhos

### Zsh

| Comando | O que faz |
|---|---|
| `g`, `gs`, `ga`, `gc`, `gp`, `gpl`, `gco`… | Atalhos de Git |
| `mkcd <dir>` | Cria a pasta e entra nela |
| `extract <arquivo>` | Extrai zip, tar, 7z etc. |
| `pr` | Abre ou cria o PR da branch |
| `serve [porta]` | Servidor HTTP na pasta atual |
| `ports` | Portas em uso |
| `ip` | IP público |
| `reload` | Recarrega o `.zshrc` |

### AeroSpace

| Tecla | O que faz |
|---|---|
| `Alt+Q` / `Alt+W` / `Alt+E` | Accordion vertical / horizontal / tiles |
| `Alt+1…8` | Vai pro workspace |
| `Alt+Shift+1…8` | Manda a janela pro workspace |
| `Alt+;` | Volta pra janela anterior |
| `Alt+Shift+Space` | Alterna flutuante / tiling |
| `Alt+Shift+R` | Recarrega a config |
| `Alt+N` / `T` / `B` / `F` | Notion / WezTerm / Bitwarden / Finder |
| `Alt+G` | Abre o GitHub |
