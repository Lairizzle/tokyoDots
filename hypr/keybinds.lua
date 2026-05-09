-- keybinds.lua

local mainMod = "ALT"

-- Basic window management
hl.bind(mainMod .. " + Q",           hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + U",           hl.dsp.window.close())
hl.bind(mainMod .. " SHIFT + M",     hl.dsp.exit())
hl.bind(mainMod .. " + E",           hl.dsp.exec_cmd(fileManager))
hl.bind("CTRL SHIFT + L",            hl.dsp.exec_cmd(lockscreen))
hl.bind(mainMod .. " + V",           hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE",       hl.dsp.exec_cmd(menu))
hl.bind("CTRL + J",                  hl.dsp.layout_msg("togglesplit"))

-- Move windows
hl.bind(mainMod .. " CTRL + H",      hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " CTRL + L",      hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " CTRL + J",      hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " CTRL + K",      hl.dsp.window.move({ direction = "d" }))

-- Focus movement (arrow keys)
hl.bind(mainMod .. " + left",        hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right",       hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up",          hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down",        hl.dsp.focus({ direction = "d" }))

-- Monitor / workspace navigation (CTRL = DP-1, mainMod = DP-2)
hl.bind("CTRL + H", function()
    hl.dispatch(hl.dsp.focus({ monitor = "DP-1" }))
    hl.dispatch(hl.dsp.focus({ workspace = "r-1" }))
end)
hl.bind("CTRL + L", function()
    hl.dispatch(hl.dsp.focus({ monitor = "DP-1" }))
    hl.dispatch(hl.dsp.focus({ workspace = "r+1" }))
end)
hl.bind(mainMod .. " + H", function()
    hl.dispatch(hl.dsp.focus({ monitor = "DP-2" }))
    hl.dispatch(hl.dsp.focus({ workspace = "r-1" }))
end)
hl.bind(mainMod .. " + L", function()
    hl.dispatch(hl.dsp.focus({ monitor = "DP-2" }))
    hl.dispatch(hl.dsp.focus({ workspace = "r+1" }))
end)

-- Switch workspaces 1-10
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " SHIFT + " .. i,       hl.dsp.window.move_to_workspace({ workspace = i }))
end
hl.bind(mainMod .. " + 0",             hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " SHIFT + 0",       hl.dsp.window.move_to_workspace({ workspace = 10 }))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",             hl.dsp.workspace.toggle_special({ name = "magic" }))
hl.bind(mainMod .. " SHIFT + S",       hl.dsp.window.move_to_workspace({ workspace = "special:magic" }))

-- Scroll through workspaces with mouse
hl.bind("CTRL SHIFT + mouse_down",     hl.dsp.focus({ workspace = "e+1" }))
hl.bind("CTRL SHIFT + mouse_up",       hl.dsp.focus({ workspace = "e-1" }))

-- Mouse move/resize windows
hl.bind(mainMod .. " CTRL + mouse:272", hl.dsp.window.move())
hl.bind(mainMod .. " CTRL + mouse:273", hl.dsp.window.resize())

-- Resize active window with bracket keys
hl.bind("CTRL + bracketright",  hl.dsp.window.resize_by({ x = 30,  y = 0 }))
hl.bind("CTRL + bracketleft",   hl.dsp.window.resize_by({ x = -30, y = 0 }))

-- Fullscreen (maximized / keep gaps)
hl.bind("CTRL SHIFT + F",       hl.dsp.window.fullscreen({ mode = 1 }))

-- Audio / media (locked = works on lockscreen)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"),                                  { locked = true })
hl.bind("XF86AudioPause",        hl.dsp.exec_cmd("playerctl play-pause"),                            { locked = true })
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"),                            { locked = true })
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"),                              { locked = true })

-- Screenshots
hl.bind("CTRL + P",             hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind(mainMod .. " + P",      hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("CTRL SHIFT + P",       hl.dsp.exec_cmd("hyprshot -m region"))

-- Quick edit hyprland config
hl.bind("CTRL " .. mainMod .. " + SPACE", hl.dsp.exec_cmd("~/.config/hypr/edit-hypr.sh"))
