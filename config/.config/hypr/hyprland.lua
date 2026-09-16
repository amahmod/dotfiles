hl.monitor {
    output = '',
    mode = 'preferred',
    position = 'auto',
    scale = 1,
}

hl.config {
    binds = {
        window_direction_monitor_fallback = true,
    },

    general = {
        layout = 'dwindle',
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
        force_split = 2,
    },

    misc = {
        enable_swallow = true,
        swallow_regex = '^(org.wezfurlong.wezterm|wezterm|kitty)$',
        swallow_exception_regex = '^(.*node.*|.*npx.*|.*npm.*|.*pnpm.*|.*yarn.*|.*bun.*|.*deno.*|.*python.*|.*bash.*|.*zsh.*|.*yazi.*|.*nvim.*|.*wezterm.*|.*kitty.*)$',
    },
}

-----------------------------------------
---- DYNAMIC MONITORS & WORKSPACES ------
-----------------------------------------

local function setup_monitors_and_workspaces()
    local mons = hl.get_monitors()

    if not mons or #mons == 0 then
        return
    end

    -- Sort monitors left-to-right.
    table.sort(mons, function(a, b)
        if a.x ~= b.x then
            return a.x < b.x
        end

        return a.id < b.id
    end)

    local primary = mons[1]

    if #mons == 1 then
        -- Single monitor: workspaces 1-10.
        for w = 1, 10 do
            hl.workspace_rule {
                workspace = tostring(w),
                monitor = primary.name,
                default = (w == 1),
                persistent = true,
            }
        end
    else
        -- Primary monitor: workspaces 1-5.
        for w = 1, 5 do
            hl.workspace_rule {
                workspace = tostring(w),
                monitor = primary.name,
                default = (w == 1),
                persistent = true,
            }
        end

        -- Secondary monitor: workspaces 6-10.
        local secondary = mons[2]

        for w = 6, 10 do
            hl.workspace_rule {
                workspace = tostring(w),
                monitor = secondary.name,
                default = (w == 6),
                persistent = true,
            }
        end
    end

    hl.exec_cmd(os.getenv 'HOME' .. '/.config/waybar/launch.sh')
end

setup_monitors_and_workspaces()

-------------------------
---- AUTOSTART APPS -----
-------------------------

hl.on('hyprland.start', function()
    hl.exec_cmd 'systemctl --user start hyprpolkitagent'
    hl.exec_cmd 'dunst'
    hl.exec_cmd('bash ' .. os.getenv 'HOME' .. '/.config/hypr/scripts/set-wallpaper.sh --restore')

    setup_monitors_and_workspaces()
end)

hl.on('monitor.added', function()
    setup_monitors_and_workspaces()
end)

hl.on('monitor.removed', function()
    setup_monitors_and_workspaces()
end)

hl.on('monitor.layout_changed', function()
    setup_monitors_and_workspaces()
end)

--------------------------
------ KEYBINDINGS -------
--------------------------

local terminal = 'wezterm'
local main_mod = 'SUPER'

---------------------------------
-------- SYSTEM ------------------
---------------------------------

-- Reboot
hl.bind(main_mod .. ' + SHIFT + r', hl.dsp.exec_cmd 'systemctl reboot')

-- Shutdown
hl.bind(main_mod .. ' + SHIFT + d', hl.dsp.exec_cmd 'systemctl poweroff')

---------------------------------
-------- VOLUME ------------------
---------------------------------

-- Volume up
hl.bind(main_mod .. ' + equal', hl.dsp.exec_cmd 'wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+', {
    locked = true,
    repeating = true,
})

hl.bind('XF86AudioRaiseVolume', hl.dsp.exec_cmd 'wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+', {
    locked = true,
    repeating = true,
})

-- Volume down
hl.bind(main_mod .. ' + minus', hl.dsp.exec_cmd 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-', {
    locked = true,
    repeating = true,
})

hl.bind('XF86AudioLowerVolume', hl.dsp.exec_cmd 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-', {
    locked = true,
    repeating = true,
})

-- Mute
hl.bind(main_mod .. ' + m', hl.dsp.exec_cmd 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle', {
    locked = true,
})

hl.bind('XF86AudioMute', hl.dsp.exec_cmd 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle', {
    locked = true,
})

-- Microphone mute
hl.bind('XF86AudioMicMute', hl.dsp.exec_cmd 'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle', {
    locked = true,
})

---------------------------------
-------- SCREENSHOTS -------------
---------------------------------

-- Screenshot
hl.bind(main_mod .. ' + s', hl.dsp.exec_cmd('flameshot gui -p ' .. os.getenv 'HOME' .. '/Pictures/screenshots'))

-- Screenshot area/script
hl.bind(
    main_mod .. ' + SHIFT + s',
    hl.dsp.exec_cmd('bash ' .. os.getenv 'HOME' .. '/.config/hypr/scripts/screenshot.sh area')
)

---------------------------------
-------- LAUNCHER ----------------
---------------------------------

-- Wofi
hl.bind(main_mod .. ' + space', hl.dsp.exec_cmd 'wofi -show drun')

-- Terminal
hl.bind(main_mod .. ' + Return', hl.dsp.exec_cmd(terminal))

-- Emoji Picker
hl.bind(main_mod .. ' + i', hl.dsp.exec_cmd 'wofi-emoji')

---------------------------------
------ APPLICATION SUBMAP --------
---------------------------------

-- SUPER + O
hl.bind(main_mod .. ' + o', hl.dsp.submap 'apps')

hl.define_submap('apps', 'reset', function()
    -- SUPER + O, C
    hl.bind('c', hl.dsp.exec_cmd 'google-chrome-stable')

    -- SUPER + O, B
    hl.bind('b', hl.dsp.exec_cmd 'brave')

    -- SUPER + O, F
    hl.bind('f', hl.dsp.exec_cmd 'firefox')

    -- SUPER + O, T
    hl.bind('t', hl.dsp.exec_cmd 'thunar')

    -- Escape
    hl.bind('escape', hl.dsp.submap 'reset')
end)

---------------------------------
------ TERMINAL APP SUBMAP -------
---------------------------------

-- SUPER + T
hl.bind(main_mod .. ' + t', hl.dsp.submap 'terminal_apps')

hl.define_submap('terminal_apps', 'reset', function()
    -- SUPER + T, L
    hl.bind('l', hl.dsp.exec_cmd(terminal .. ' start yazi'))

    -- SUPER + T, H
    hl.bind('h', hl.dsp.exec_cmd(terminal .. ' start htop'))

    -- SUPER + T, N
    hl.bind('n', hl.dsp.exec_cmd(terminal .. ' start nvim'))

    -- SUPER + T, Y
    -- hl.bind('y', hl.dsp.exec_cmd(terminal .. ' start yazi'))

    -- Escape
    hl.bind('escape', hl.dsp.submap 'reset')
end)

---------------------------------
-------- WINDOW ------------------
---------------------------------

-- Close window
hl.bind(main_mod .. ' + q', hl.dsp.window.close())

-- Fullscreen
hl.bind(main_mod .. ' + f', hl.dsp.window.fullscreen())

-- Toggle floating
hl.bind(
    main_mod .. ' + SHIFT + f',
    hl.dsp.window.float {
        action = 'toggle',
    }
)

-- Quit Hyprland
hl.bind(main_mod .. ' + ALT + q', hl.dsp.exit())

---------------------------------
-------- FOCUS -------------------
---------------------------------

-- Vim-style directional focus
hl.bind(
    main_mod .. ' + h',
    hl.dsp.focus {
        direction = 'l',
    }
)

hl.bind(
    main_mod .. ' + j',
    hl.dsp.focus {
        direction = 'd',
    }
)

hl.bind(
    main_mod .. ' + k',
    hl.dsp.focus {
        direction = 'u',
    }
)

hl.bind(
    main_mod .. ' + l',
    hl.dsp.focus {
        direction = 'r',
    }
)

-- Arrow keys
hl.bind(
    main_mod .. ' + left',
    hl.dsp.focus {
        direction = 'l',
    }
)

hl.bind(
    main_mod .. ' + down',
    hl.dsp.focus {
        direction = 'd',
    }
)

hl.bind(
    main_mod .. ' + up',
    hl.dsp.focus {
        direction = 'u',
    }
)

hl.bind(
    main_mod .. ' + right',
    hl.dsp.focus {
        direction = 'r',
    }
)

-- Last focused window
hl.bind(
    main_mod .. ' + Tab',
    hl.dsp.focus {
        last = true,
    }
)

-- Previous monitor
hl.bind(
    main_mod .. ' + comma',
    hl.dsp.focus {
        monitor = 'l',
    }
)

-- Next monitor
hl.bind(
    main_mod .. ' + period',
    hl.dsp.focus {
        monitor = 'r',
    }
)

---------------------------------
-------- SWAP / MOVE -------------
---------------------------------

-- Swap left
hl.bind(
    main_mod .. ' + SHIFT + h',
    hl.dsp.window.swap {
        direction = 'l',
    }
)

-- Swap down
hl.bind(
    main_mod .. ' + SHIFT + j',
    hl.dsp.window.swap {
        direction = 'd',
    }
)

-- Swap up
hl.bind(
    main_mod .. ' + SHIFT + k',
    hl.dsp.window.swap {
        direction = 'u',
    }
)

-- Swap right
hl.bind(
    main_mod .. ' + SHIFT + l',
    hl.dsp.window.swap {
        direction = 'r',
    }
)

-- Arrow keys
hl.bind(
    main_mod .. ' + SHIFT + left',
    hl.dsp.window.swap {
        direction = 'l',
    }
)

hl.bind(
    main_mod .. ' + SHIFT + down',
    hl.dsp.window.swap {
        direction = 'd',
    }
)

hl.bind(
    main_mod .. ' + SHIFT + up',
    hl.dsp.window.swap {
        direction = 'u',
    }
)

hl.bind(
    main_mod .. ' + SHIFT + right',
    hl.dsp.window.swap {
        direction = 'r',
    }
)

---------------------------------
-------- WORKSPACES --------------
---------------------------------

-- 1-9 = workspaces 1-9
-- 0   = workspace 10
for i = 1, 10 do
    local key = tostring(i % 10)

    -- Focus workspace
    hl.bind(
        main_mod .. ' + ' .. key,
        hl.dsp.focus {
            workspace = i,
        }
    )

    -- Move window to workspace
    hl.bind(
        main_mod .. ' + SHIFT + ' .. key,
        hl.dsp.window.move {
            workspace = i,
        }
    )
end

---------------------------------
-------- WINDOW MOVE -------------
---------------------------------
-- Move window to previous/left monitor
hl.bind(
    main_mod .. ' + SHIFT + comma',
    hl.dsp.window.move {
        monitor = 'l',
    }
)

-- Move window to next/right monitor
hl.bind(
    main_mod .. ' + SHIFT + period',
    hl.dsp.window.move {
        monitor = 'r',
    }
)

-- Move floating window left
hl.bind(
    main_mod .. ' + CTRL + h',
    hl.dsp.window.move {
        x = -20,
        y = 0,
        relative = true,
    }
)

-- Move floating window right
hl.bind(
    main_mod .. ' + CTRL + l',
    hl.dsp.window.move {
        x = 20,
        y = 0,
        relative = true,
    }
)

-- Move floating window up
hl.bind(
    main_mod .. ' + CTRL + k',
    hl.dsp.window.move {
        x = 0,
        y = -20,
        relative = true,
    }
)

-- Move floating window down
hl.bind(
    main_mod .. ' + CTRL + j',
    hl.dsp.window.move {
        x = 0,
        y = 20,
        relative = true,
    }
)

---------------------------------
-------- WINDOW RESIZE -----------
---------------------------------

-- Resize left
hl.bind(
    main_mod .. ' + ALT + h',
    hl.dsp.window.resize {
        x = -20,
        y = 0,
        relative = true,
    }
)

-- Resize right
hl.bind(
    main_mod .. ' + ALT + l',
    hl.dsp.window.resize {
        x = 20,
        y = 0,
        relative = true,
    }
)

-- Resize up
hl.bind(
    main_mod .. ' + ALT + k',
    hl.dsp.window.resize {
        x = 0,
        y = -20,
        relative = true,
    }
)

-- Resize down
hl.bind(
    main_mod .. ' + ALT + j',
    hl.dsp.window.resize {
        x = 0,
        y = 20,
        relative = true,
    }
)

---------------------------------
-------- MOUSE -------------------
---------------------------------

-- Move/drag window
hl.bind(main_mod .. ' + mouse:272', hl.dsp.window.drag(), {
    mouse = true,
})

-- Resize window
hl.bind(main_mod .. ' + mouse:273', hl.dsp.window.resize(), {
    mouse = true,
})

---------------------------------
-------- WAYBAR ------------------
---------------------------------

hl.bind(main_mod .. ' + SHIFT + b', hl.dsp.exec_cmd(os.getenv 'HOME' .. '/.config/waybar/launch.sh'))

---------------------------------
-------- THEME -------------------
---------------------------------

hl.bind(
    main_mod .. ' + SHIFT + t',
    hl.dsp.exec_cmd('bash ' .. os.getenv 'HOME' .. '/.config/hypr/scripts/theme-switch.sh menu')
)

hl.bind(
    main_mod .. ' + ALT + t',
    hl.dsp.exec_cmd('bash ' .. os.getenv 'HOME' .. '/.config/hypr/scripts/theme-switch.sh next')
)

---------------------------------
-------- OPACITY -----------------
---------------------------------

hl.bind(
    main_mod .. ' + SHIFT + o',
    hl.dsp.exec_cmd('bash ' .. os.getenv 'HOME' .. '/.config/hypr/scripts/toggle-opacity.sh')
)

---------------------------------
-------- WINDOW RULES ------------
---------------------------------

hl.window_rule {
    name = 'file-roller-float',

    match = {
        class = 'org.gnome.FileRoller',
    },

    float = true,
}

hl.window_rule {
    name = 'screenshot-annotation-float',

    match = {
        class = '^(com.gabm.satty|satty|swappy|com.github.swappy)$',
    },

    float = true,
    center = true,

    size = {
        '80%',
        '80%',
    },
}

---------------------------------
-------- LAYER RULES -------------
---------------------------------

hl.layer_rule {
    name = 'waybar',
    blur = true,
    blur_popups = true,
}
