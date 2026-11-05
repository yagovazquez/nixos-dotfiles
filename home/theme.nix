{ config, lib, ... }:

let
  # The 16 standard base16 slots. Stylix's color set also exposes extended
  # base10-base17/named aliases, but only these are meant to be a stable
  # cross-program contract, so only these get exported.
  base16Slots = [
    "base00" "base01" "base02" "base03"
    "base04" "base05" "base06" "base07"
    "base08" "base09" "base0A" "base0B"
    "base0C" "base0D" "base0E" "base0F"
  ];
in
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
    # nvim isn't managed via programs.neovim (it's a hand-rolled
    # lazy.nvim setup), so this target would have nothing to attach to.
    # It's themed directly instead, via the env vars below.
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

  # Hands the active base16 palette to nvim (and anything else outside
  # stylix's reach) as env vars, so editing system/theme.nix's colors
  # actually changes what nvim shows instead of nvim keeping its own copy.
  # `config.lib.stylix.colors` is already the vanilla scheme merged with
  # whatever override is active, so no variant branching is needed here.
  home.sessionVariables = lib.listToAttrs (map (slot: {
    name = "NIX_THEME_" + lib.toUpper slot;
    value = config.lib.stylix.colors.withHashtag.${slot};
  }) base16Slots);
}
