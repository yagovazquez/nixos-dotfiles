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

  c = config.lib.stylix.colors.withHashtag;
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
    # workspace underline); it's themed by hand in home/programs/waybar.nix
    # instead, so it stays pixel-identical for TokyoNight specifically.
    waybar.enable = false;
    # alternatePattern off: default stylix behavior gives every other row
    # a lighter background (base01), which read as a jarring checkerboard.
    rofi = {
      enable = true;
      alternatePattern = false;
    };
    zathura.enable = true;
    qutebrowser.enable = true;
    mako.enable = true;

    # Only the "Firefox Color" lightweight-theme route (toolbar/popup/
    # sidebar colors via the browser's native theme API) — it doesn't
    # touch userChrome/userContent, so it can't interfere with the
    # tab-bar-hiding/no-rounded-corners rules in configs/firefox. Pulls in
    # stylix's own NUR input to install the extension.
    firefox = {
      enable = true;
      profileNames = [ "3z7tqry0.default" ];
      colorTheme.enable = true;
    };
  };

  # The startpage (shared by Firefox's homepage and qutebrowser's start
  # page, see home/programs/{firefox,qutebrowser}.nix) is loaded straight
  # off disk via a file:// URL rather than deployed by home-manager, so it
  # can't read stylix's colors directly. style.css's `:root` block already
  # defines every color it uses as a custom property with the current
  # TokyoNight Moon look as the default; this just redefines those same
  # properties from the live palette in a second stylesheet index.html
  # loads right after it, so the override wins the cascade.
  home.file."nix-config/home/configs/firefox/startpage/_theme.css".text = ''
    :root {
      --bg: ${c.base00};
      --card: ${c.base01};
      --fg: ${c.base07};
      --muted: ${c.base04};
      --link: ${c.base0D};
      --border: ${c.base02};
      --border-strong: ${c.base0D};
    }
  '';

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
