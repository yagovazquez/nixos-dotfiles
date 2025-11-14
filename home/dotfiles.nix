{ config, pkgs, lib, ... }:

{
  home.file.".config/nvim/init.lua".source = ./nvim/init.lua;
  home.file.".config/qutebrowser/config.py".source = ./qutebrowser/config.py;
  xdg.configFile."hypr".source = ./hypr;
  xdg.configFile."niri".source = ./niri;
  xdg.configFile."rofi".source = ./rofi;
  xdg.configFile."waybar".source = ./waybar;
}
