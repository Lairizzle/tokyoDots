-- input.lua

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse   = 1,
        accel_profile  = "float",   -- raw input, no acceleration curve
        force_no_accel = true,
        sensitivity    = 0,

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- Per-device overrides
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})
