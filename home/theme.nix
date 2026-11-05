{ config, lib, ... }:

{
  # Colors/fonts/polarity are set in system/theme.nix and inherited here
  # automatically by stylix's home-manager integration. Only per-app target
  # toggles live here, since those aren't inherited from the system config.
  stylix.targets = {
    # Keep the dedicated Tokyonight-Dark GTK theme package as-is.
    gtk.enable = false;
    # Hyprland config here is plain hyprland.lua, not the HM hyprland module;
    # it's themed by hand in configs/hypr/default.nix instead.
    hyprland.enable = false;
    # nvim keeps its own tokyonight.nvim setup; themed via on_colors instead.
    neovim.enable = false;

    ghostty.enable = true;
    # Waybar keeps its original hand-written look (colors + no active-
    # workspace underline); stylix doesn't touch it.
    waybar.enable = false;
    rofi.enable = true;
    zathura.enable = true;
    qutebrowser.enable = true;
    mako.enable = true;
  };

  # Lets nvim (and anything else outside stylix's reach) know which variant
  # is active, derived from whether system/theme.nix set an override.
  home.sessionVariables.NIX_THEME_VARIANT = lib.optionalString (config.stylix.override != { }) "personal";
}
