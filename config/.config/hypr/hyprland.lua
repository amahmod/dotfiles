hl.config({
	monitor = {
		{
			name = "",
			resolution = "preferred",
			position = "auto",
			scale = 1,
		},
	},

	general = {
		layout = "dwindle",
		gaps_in = 0,
		gaps_out = {
			top = 5,
			right = 0,
			bottom = 0,
			left = 0,
		},
	},

	dwindle = {
		preserve_split = true,
		force_split = 2, -- Always split to the right/bottom
	},

	misc = {
		enable_swallow = true,
		swallow_regex = "^(org.wezfurlong.wezterm|wezterm|kitty)$",
	},
})

-----------------------------------------
---- DYNAMIC MONITORS & WORKSPACES ------
-----------------------------------------
local function setup_monitors_and_workspaces()
	local mons = hl.get_monitors()
	if not mons or #mons == 0 then return end

	-- Sort monitors left-to-right (primary is leftmost / ID 0)
	table.sort(mons, function(a, b)
		if a.x ~= b.x then return a.x < b.x end
		return a.id < b.id
	end)

	local primary = mons[1]

	if #mons == 1 then
		-- Single Monitor: Workspaces 1-10 on primary
		for w = 1, 10 do
			hl.workspace_rule({
				workspace = tostring(w),
				monitor = primary.name,
				default = (w == 1),
				persistent = true,
			})
		end
	else
		-- Multi-Monitor: Primary gets 1-5, Secondary gets 6-10
		for w = 1, 5 do
			hl.workspace_rule({
				workspace = tostring(w),
				monitor = primary.name,
				default = (w == 1),
				persistent = true,
			})
		end
		local secondary = mons[2]
		for w = 6, 10 do
			hl.workspace_rule({
				workspace = tostring(w),
				monitor = secondary.name,
				default = (w == 6),
				persistent = true,
			})
		end
	end

	-- Reload / launch Waybar with detected monitors
	hl.exec_cmd(os.getenv("HOME") .. "/.config/waybar/launch.sh")
end

-- Run monitor configuration
setup_monitors_and_workspaces()

-------------------------
---- AUTOSTART APPS -----
-------------------------
hl.on("hyprland.start", function()
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("dunst")
	setup_monitors_and_workspaces()
end)

hl.on("monitor.added", function()
	setup_monitors_and_workspaces()
end)

hl.on("monitor.removed", function()
	setup_monitors_and_workspaces()
end)

hl.on("monitor.layout_changed", function()
	setup_monitors_and_workspaces()
end)

--------------------------
------ KEYBINDINGS -------
--------------------------

local terminal = "wezterm"
local menu     = "wofi --show drun"
local main_mod = "SUPER"

-- Applications & Launcher
hl.bind(main_mod .. " + Return",    hl.dsp.exec_cmd(terminal))
hl.bind(main_mod .. " + SPACE",     hl.dsp.exec_cmd(menu))
hl.bind(main_mod .. " + E",         hl.dsp.exec_cmd(terminal .. " start yazi"))
hl.bind(main_mod .. " + SHIFT + E", hl.dsp.exec_cmd("thunar"))

-- Window Actions
hl.bind(main_mod .. " + Q",         hl.dsp.window.close())
hl.bind(main_mod .. " + F",         hl.dsp.window.fullscreen())
hl.bind(main_mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + ALT + Q",   hl.dsp.exit())

-- Focus Navigation (Vim hjkl & Arrow Keys)
hl.bind(main_mod .. " + H",     hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + J",     hl.dsp.focus({ direction = "down" }))
hl.bind(main_mod .. " + K",     hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + L",     hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + Left",  hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + Down",  hl.dsp.focus({ direction = "down" }))
hl.bind(main_mod .. " + Up",    hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + Right", hl.dsp.focus({ direction = "right" }))

-- Window Swap / Move (Vim SHIFT+hjkl & Arrow Keys)
hl.bind(main_mod .. " + SHIFT + H",     hl.dsp.window.swap({ direction = "l" }))
hl.bind(main_mod .. " + SHIFT + J",     hl.dsp.window.swap({ direction = "d" }))
hl.bind(main_mod .. " + SHIFT + K",     hl.dsp.window.swap({ direction = "u" }))
hl.bind(main_mod .. " + SHIFT + L",     hl.dsp.window.swap({ direction = "r" }))
hl.bind(main_mod .. " + SHIFT + Left",  hl.dsp.window.swap({ direction = "l" }))
hl.bind(main_mod .. " + SHIFT + Down",  hl.dsp.window.swap({ direction = "d" }))
hl.bind(main_mod .. " + SHIFT + Up",    hl.dsp.window.swap({ direction = "u" }))
hl.bind(main_mod .. " + SHIFT + Right", hl.dsp.window.swap({ direction = "r" }))

-- Workspaces 1-10: Switch workspace & Move window to workspace
for i = 1, 10 do
	local key = tostring(i % 10)
	hl.bind(main_mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
	hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end


-- Mouse Window Drag & Resize
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume Control (Keys & Media Buttons)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind(main_mod .. " + equal", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),        { locked = true, repeating = true })
hl.bind(main_mod .. " + minus", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),        { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),       { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),     { locked = true })

-- Screenshots (grim + slurp + wl-copy)
hl.bind(main_mod .. " + SHIFT + S", hl.dsp.exec_cmd([[sh -c 'grim -g "$(slurp)" - | wl-copy && notify-send "Screenshot" "Selection copied to clipboard" -i camera-photo']]))
hl.bind(main_mod .. " + S",         hl.dsp.exec_cmd([[sh -c 'grim - | wl-copy && notify-send "Screenshot" "Screen captured to clipboard" -i camera-photo']]))

-- Waybar Controls
hl.bind(main_mod .. " + SHIFT + B", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/waybar/launch.sh"))

-- System Theme Switcher Controls
hl.bind(main_mod .. " + SHIFT + T", hl.dsp.exec_cmd("bash " .. os.getenv("HOME") .. "/.config/hypr/scripts/theme-switch.sh menu"))
hl.bind(main_mod .. " + ALT + T",   hl.dsp.exec_cmd("bash " .. os.getenv("HOME") .. "/.config/hypr/scripts/theme-switch.sh next"))

-- Terminal Opacity Toggle
hl.bind(main_mod .. " + SHIFT + O", hl.dsp.exec_cmd("bash " .. os.getenv("HOME") .. "/.config/hypr/scripts/toggle-opacity.sh"))

---------------------------------
-------- WINDOW RULES -----------
---------------------------------
hl.window_rule({
	name  = "file-roller-float",
	match = { class = "org.gnome.FileRoller" },
	float = true,
})

---------------------------------
-------- LAYER RULES ------------
---------------------------------
hl.layer_rule({
	name = "waybar",
	blur = true,
	blur_popups = true,
})
