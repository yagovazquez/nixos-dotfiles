{ config, pkgs, lib, ... }:

{
  #home.file.".config/nvim/init.lua".source = ./nvim/init.lua;
  xdg.configFile."nvim".source = ./nvim;
  home.file.".config/qutebrowser/config.py".source = ./qutebrowser/config.py;
  home.file.".config/yazi/yazi.toml".source = ./yazi/yazi.toml;
  home.file.".config/hypr/hyprpaper.conf".source = ./hypr/hyprpaper.conf;
  home.file.".config/hypr/hyprland.conf".source = ./hypr/hyprland.conf;
  home.file.".config/hypr/hyprland.lua".source = ./hypr/hyprland.lua;
  #xdg.configFile."hypr".source = ./hypr;
  xdg.configFile."niri".source = ./niri;
  xdg.configFile."rofi".source = ./rofi;
  xdg.configFile."waybar".source = ./waybar;
}
