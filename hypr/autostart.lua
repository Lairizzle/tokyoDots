-- autostart.lua

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("brave")
    hl.exec_cmd("discord")
    hl.exec_cmd("nextcloud")
    hl.exec_cmd("spotify-launcher")
end)
