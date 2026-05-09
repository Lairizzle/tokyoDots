-- workspaces.lua

-- Assign workspaces to monitors
hl.workspace_rule({ workspace = "1",  monitor = "DP-1" })
hl.workspace_rule({ workspace = "2",  monitor = "DP-1" })
hl.workspace_rule({ workspace = "3",  monitor = "DP-1" })
hl.workspace_rule({ workspace = "4",  monitor = "DP-1" })
hl.workspace_rule({ workspace = "5",  monitor = "DP-1" })
hl.workspace_rule({ workspace = "6",  monitor = "DP-2" })
hl.workspace_rule({ workspace = "7",  monitor = "DP-2" })
hl.workspace_rule({ workspace = "8",  monitor = "DP-2" })
hl.workspace_rule({ workspace = "9",  monitor = "DP-2" })
hl.workspace_rule({ workspace = "10", monitor = "DP-2" })

-- Window rules  (replaces old `windowrule =` lines)
-- Debug windows → DP-2 ws 6
hl.window_rule({
    match        = { title = ".*DEBUG.*" },
    monitor      = "DP-2",
    workspace    = "6",
})

-- OBS → DP-2 ws 7
hl.window_rule({
    match     = { class = "com.obsproject.Studio" },
    monitor   = "DP-2",
    workspace = "7",
})

-- Brave browser → DP-2 ws 8
hl.window_rule({
    match     = { class = "brave-browser" },
    monitor   = "DP-2",
    workspace = "8",
})

-- Discord → DP-2 ws 9
hl.window_rule({
    match     = { class = "discord" },
    monitor   = "DP-2",
    workspace = "9",
})

-- Spotify → DP-2 ws 10
hl.window_rule({
    match     = { class = "Spotify" },
    monitor   = "DP-2",
    workspace = "10",
})

-- Fullscreen windows get a distinct border colour
hl.window_rule({
    match        = { fullscreen = true },
    border_color = "rgba(2AC3DEff)",
})

-- Screenshots  (placed here since they relate to workspace/window context)
