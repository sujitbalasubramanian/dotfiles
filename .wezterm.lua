local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font_size = 12
config.font = wezterm.font("FiraCode Nerd Font")
config.color_scheme = "Catppuccin Mocha"

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
-- config.automatically_reload_config = false

-- tabbar config
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

-- keybindings
-- config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
--
-- config.keys = {
-- 	{ key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
-- 	{ key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
-- 	{ key = "|", mods = "LEADER|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
-- 	{ key = "-", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
-- 	{ key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
-- 	{ key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
-- 	{ key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
-- 	{ key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
--
-- 	{ key = "a", mods = "LEADER|CTRL", action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }) },
-- }
--
-- for i = 1, 8 do
-- 	table.insert(config.keys, {
-- 		key = tostring(i),
-- 		mods = "LEADER",
-- 		action = wezterm.action.ActivateTab(i - 1),
-- 	})
-- end

return config
