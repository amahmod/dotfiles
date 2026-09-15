hl.config({
	monitor = {
		{
			name = "",
			resolution = "preferred",
			position = "auto",
			scale = 1
		},
	},
})

local terminal = "wezterm"
local main_mod = "SUPER"

hl.bind("SUPER + Return", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("wofi --show drun"))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + M", hl.dsp.exit())

-- Autostart essential services
hl.on("hyprland.start", function()
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("dunst")
end)
