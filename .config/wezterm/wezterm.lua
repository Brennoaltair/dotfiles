local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.colors = {
	background = "#000000",
	foreground = "#ffffff",
}

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 19.0

config.window_decorations = "RESIZE"
config.enable_tab_bar = false

config.scrollback_lines = 10000
config.warn_about_missing_glyphs = false
config.keys = {
	{
		key = "Enter",
		mods = "SHIFT",
		action = wezterm.action.SendString("\27\r"),
	},
}

return config
