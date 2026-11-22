# LAPTOP ONLY home-manager config, layered on top of the shared home/home.nix.
{ ... }:

{
  # Release of the first home-manager install on this machine. Never change it.
  home.stateVersion = "25.05";

  # Spliced into home/configs/hypr/hyprland.lua in place of __MONITORS__.
  my.hyprland.monitors = ''
    hl.monitor({ output = "eDP-1", mode = "1366x768", position = "0x0", scale = "1" })
    hl.monitor({ output = "desc:AOC 24G2W1G4 0x00009CC8", mode = "preferred", position = "-277x-1080", scale = "1" })
    -- TV Philips: its EDID prefers 1080p@50 (EU), force 60 Hz for smoother output.
    -- The TV overscans (crops the edges); `reserved` keeps windows/waybar inside the
    -- visible area (measured with a test pattern). Set to 0 if the TV's picture
    -- format is switched to "Sin escala"/unscaled.
    hl.monitor({
        output = "desc:Philips Consumer Electronics Company Philips FTV 0x01010101",
        mode = "1920x1080@60",
        position = "1366x0",
        scale = "1",
        reserved = { top = 20, right = 60, bottom = 40, left = 60 },
    })
  '';

  # Only a laptop has a battery and a backlight to show.
  programs.waybar.settings.mainBar."modules-right" = [ "battery" "backlight" "pulseaudio" "network" ];
}
