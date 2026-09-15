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

local terminal = "kitty"
local main_mod = "SUPER"

hl.bind("SUPER + Return", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + Q", hl.dsp.window.kill())
hl.bind("SUPER + M", hl.dsp.exit())
