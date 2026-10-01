vim.opt.wrap        = true
vim.opt.linebreak   = true
vim.opt.background  = "dark"

vim.cmd("colorscheme default")

vim.api.nvim_set_hl(0, "Normal",       { fg = "#ffffff", bg = "#000000" })
vim.api.nvim_set_hl(0, "NormalNC",     { fg = "#ffffff", bg = "#000000" })
vim.api.nvim_set_hl(0, "NormalFloat",  { fg = "#ffffff", bg = "#000000" })
vim.api.nvim_set_hl(0, "SignColumn",   { bg = "#000000" })
vim.api.nvim_set_hl(0, "LineNr",       { fg = "#555555", bg = "#000000" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#aaaaaa", bg = "#000000" })
vim.api.nvim_set_hl(0, "EndOfBuffer",  { fg = "#000000", bg = "#000000" })
