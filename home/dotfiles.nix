{ config, pkgs, lib, ... }:

{

  # Neovim
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/home/nvim";

  # qutebrowser
  home.file.".config/qutebrowser/config.py".source = ./qutebrowser/config.py;
  
  # Yazi
  home.file.".config/yazi/yazi.toml".source = ./yazi/yazi.toml;
  
  # Hyprland
  home.file.".config/hypr/hyprpaper.conf".source = ./hypr/hyprpaper.conf;
  #home.file.".config/hypr/hyprland.conf".source = ./hypr/hyprland.conf;
  home.file.".config/hypr/hyprland.lua".source = ./hypr/hyprland.lua;
  #xdg.configFile."hypr".source = ./hypr;

  xdg.configFile."waybar".source = ./waybar;
  
  # Niri
  xdg.configFile."niri".source = ./niri;
  
  # Rofi
  xdg.configFile."rofi".source = ./rofi;
}
