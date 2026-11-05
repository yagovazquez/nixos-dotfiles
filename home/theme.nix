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

  # Hands the active base16 colors to nvim (and anything else outside
  # stylix's reach) as env vars, so editing system/theme.nix actually
  # changes what nvim shows instead of nvim re-declaring its own copies.
  # `config.lib.stylix.colors` is already the vanilla scheme merged with
  # whatever override is active, so no variant branching is needed here.
  home.sessionVariables = {
    NIX_THEME_BASE03 = config.lib.stylix.colors.withHashtag.base03;
    NIX_THEME_BASE04 = config.lib.stylix.colors.withHashtag.base04;
  };
}
