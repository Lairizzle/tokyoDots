-- looknfeel.lua

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 5,
		border_size = 1,
		col = {
			active_border = { colors = { "rgba(bb9af7ff)", "rgba(a277f2ff)" }, angle = 45 },
			inactive_border = "rgba(7dcfff42)",
		},
		resize_on_border = true,
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 8,
		rounding_power = 1,
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	misc = {
		force_default_wallpaper = 1,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		focus_on_activate = true,
	},
})

-- dwindle and master must be in their own hl.config() calls
-- note: pseudotile was removed in 0.55
hl.config({
	dwindle = {
		preserve_split = true,
	},
})

hl.config({
	master = {
		new_status = "master",
	},
})

-- Bezier curves
hl.curve("myBezier", { type = "bezier", points = { { 0.25, 1 }, { 0.5, 1.05 } } })
hl.curve("myBezier2", { type = "bezier", points = { { 0.25, 0.75 }, { 0.5, 1.05 } } })
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Animations
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "myBezier" })
hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "myBezier" })
hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "myBezier" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "myBezier", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "myBezier", style = "slide" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 5, bezier = "myBezier" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 5, bezier = "myBezier" })
hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 4, bezier = "myBezier" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "myBezier", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "myBezier", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 2, bezier = "myBezier" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.5, bezier = "myBezier" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "myBezier2", style = "slidevert" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 3, bezier = "myBezier2", style = "slidevert" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 3, bezier = "myBezier2", style = "slidevert" })
