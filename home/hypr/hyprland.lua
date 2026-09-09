-- hyprland.lua
-- Translated from your legacy hyprland.conf

----------------
--- MONITORS ---
----------------
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({ output = "eDP-1", mode = "1366x768", position = "0x0", scale = "1" })
hl.monitor({ output = "desc:AOC 24G2W1G4 0x00009CC8", mode = "preferred", position = "-277x-1080", scale = "1" })

---------------------
--- MY PROGRAMS ---
---------------------
local terminal = "ghostty"
local fileManager = "dolphin"
local fileManagerTerminal = "kitty yazi"
local menu = "rofi -show drun"
local browser = "qutebrowser"
local firefoxbrowser = "firefox"
local editor = "kitty nvim"
local noteTaking = "obsidian"

-----------------
--- AUTOSTART ---
-----------------
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar &")
    hl.exec_cmd("mako &")
    -- hl.exec_cmd("anki-bin &")
end)

-----------------------------
--- ENVIRONMENT VARIABLES ---
-----------------------------
-- hl.env("XCURSOR_SIZE", "24")
-- hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Apple-X-Cursor")
hl.env("XCURSOR_SIZE", "22")

---------------------
--- LOOK AND FEEL ---
---------------------
hl.config({
    general = {
        gaps_in = 1,
        gaps_out = 0,
        border_size = 1,
        col = {
            active_border = "rgba(004687ff)",
            inactive_border = "rgba(4c566aff)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 0,
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
        }
    },
    animations = {
        enabled = false,
    },
    dwindle = {
        -- pseudotile = true
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
    input = {
        kb_layout = "es",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
    gestures = {
        -- workspace_swipe = false
    },
})

---------------------
--- INPUT DEVICES ---
---------------------
hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

--------------------
--- WINDOW RULES ---
--------------------
hl.window_rule({
    name = "kitty_opacity",
    match = { class = "^(kitty)$" },
    opacity = "1.0 0.8",
})

hl.window_rule({
    name = "ghostty_opacity",
    match = { class = "^(ghostty|Ghostty|dev\\.ghostty\\.Ghostty|com\\.mitchellh\\.ghostty)$" },
    opacity = "0.98 override 0.9 override",
})

hl.window_rule({
    name = "ignore_maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix_wayland",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

-------------------
--- KEYBINDINGS ---
-------------------
local mainMod = "SUPER"

-- Core Application Binds
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
--hl.bind(mainMod .. " + C", hl.dsp.window.kill())
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(firefoxbrowser))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd(fileManagerTerminal))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(editor))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(noteTaking))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("anki"))

-- Custom Scripts
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("~/nix-config/home/bin/rofi-power"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("~/nix-config/home/bin/rofi-wallpaper"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("~/nix-config/home/bin/float-sdcv-kitty"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("~/nix-config/home/bin/rofi-newfile.sh"))

-- Timer controls
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("~/nix-config/home/waybar/waybar-timer.sh toggle && pkill -RTMIN+5 waybar"))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("~/nix-config/home/waybar/waybar-timer.sh reset && pkill -RTMIN+5 waybar"))

-- Screen Filter
hl.bind(mainMod .. " + F9", hl.dsp.exec_cmd("hyprsunset --temperature 4500"))
hl.bind(mainMod .. " + F10", hl.dsp.exec_cmd("pkill hyprsunset"))

-- Move focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Move window
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

-- Workspaces (Using standard Lua loop to replace repetitive bindings)
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. tostring(i), hl.dsp.focus({ workspace = tostring(i) }))
    hl.bind(mainMod .. " + SHIFT + " .. tostring(i), hl.dsp.window.move({ workspace = tostring(i), silent = true }))
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = "10" }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = "10", silent = true }))

-- Special workspace
hl.bind(mainMod .. " + S", hl.dsp.focus({ workspace = "special:magic" }))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse window controls
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Keyboard resize (repeating)
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })

-- Volume (repeating allowed for up/down)
hl.bind(mainMod .. " + F3", hl.dsp.exec_cmd("pamixer -i 5"), { repeating = true })
hl.bind(mainMod .. " + F2", hl.dsp.exec_cmd("pamixer -d 5"), { repeating = true })
hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd("pamixer -t"))

-- Brightness (repeating)
hl.bind(mainMod .. " + F6", hl.dsp.exec_cmd("brightnessctl set +5%"), { repeating = true })
hl.bind(mainMod .. " + F5", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true })

-- Media controls (Requires playerctl, set to trigger even on lock screen)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Screenshots
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output"))
