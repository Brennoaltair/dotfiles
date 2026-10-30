# LibreWolf

Tema escuro neutro, cantos retos e abas na lateral com a Sidebery.

| Arquivo | Onde vai |
|---|---|
| `chrome/userChrome.css` | Interface do navegador (esconde a barra de abas do topo) |
| `chrome/userContent.css` | Páginas internas `about:*` |
| `theme.zip` | Tema de cores exportado do Firefox Color |
| `sidebery.css` | Sidebery → Settings → Styles editor |

## Restaurar

1. Instale as extensões Sidebery e Firefox Color.
2. Em `about:config`, deixe `toolkit.legacyUserProfileCustomizations.stylesheets` como `true`.
3. Em `about:support`, copie o caminho da "Pasta do perfil" e ligue a pasta `chrome`:

   ```bash
   ln -s ~/dotfiles/librewolf/chrome "<pasta do perfil>/chrome"
   ```

4. Em `about:addons`, ⚙️ → "Instalar extensão de arquivo…" e escolha `theme.zip`.
   Se o LibreWolf recusar o arquivo, abra color.firefox.com e digite as cores abaixo.
5. Cole o conteúdo de `sidebery.css` no Styles editor da Sidebery.
6. Reinicie o navegador (Cmd+Q).

## Cores (Firefox Color)

| Campo | Cor |
|---|---|
| Toolbar Color | `#1e1e1e` |
| Toolbar Icons and Text | `#e6e6e6` |
| Background Color | `#121212` |
| Background Tab Text Color | `#8c8c8c` |
| Search Bar Color | `#121212` |
| Search Text | `#e6e6e6` |
| Tab Highlight Color | `#bfbfbf` |
| Popup Background | `#1e1e1e` |
| Popup Text | `#e6e6e6` |
