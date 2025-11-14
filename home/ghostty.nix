{ config, pkgs, lib, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      #font-family = "Inconsolata Nerd Font Mono";
      font-family = "MxPlus IBM VGA 9x16";
      font-size = 12;
      #background-opacity = 0.9; #i control it through hyprland
      gtk-titlebar = false;
      resize-overlay = "never";
      confirm-close-surface = false;
      window-padding-x = 4;
      window-padding-y = 4;
      window-vsync = true;
      window-decoration = "none";
      background-blur = false;
      #theme = "nord";
      theme = "tokyonight_moon";
      #keybind = [];
    };
  };
}
