{ config, pkgs, lib, ... }:

{
  programs.ghostty = {
    enable = true;
    # Colors and font come from stylix.targets.ghostty (see home/theme.nix).
    settings = {
      #background-opacity = 0.9; #i control it through hyprland
      gtk-titlebar = false;
      resize-overlay = "never";
      confirm-close-surface = false;
      window-padding-x = 4;
      window-padding-y = 4;
      window-vsync = true;
      window-decoration = "none";
      background-blur = false;
      # keybind = [];
    };
  };
}
