{ pkgs, ... }:

let
  # === THE ONE SWITCH ===
  # "personal" = tokyonight-moon with comments/dim text brightened for this
  # screen. "vanilla" = unmodified tokyonight-moon. Flip and `update` to apply.
  variant = "personal";

  # Plain tokyonight-moon (https://github.com/folke/tokyonight.nvim), as a
  # base16 scheme. Kept untouched so "vanilla" is always available.
  vanilla = {
    scheme = "Tokyo Night Moon";
    author = "folke/tokyonight.nvim, adapted to base16";
    slug = "tokyonight-moon";
    base00 = "222436"; # bg            #222436
    base01 = "2f334d"; # bg_highlight  #2f334d
    base02 = "2d3f76"; # bg_visual/sel #2d3f76
    base03 = "636da6"; # comment, dim  #636da6
    base04 = "828bb8"; # fg_dark       #828bb8
    base05 = "c8d3f5"; # fg            #c8d3f5
    base06 = "c8d3f5"; # light fg      #c8d3f5
    base07 = "d5dbf7"; # lightest fg   #d5dbf7
    base08 = "ff757f"; # red           #ff757f
    base09 = "ff966c"; # orange        #ff966c
    base0A = "ffc777"; # yellow        #ffc777
    base0B = "c3e88d"; # green         #c3e88d
    base0C = "86e1fc"; # cyan          #86e1fc
    base0D = "82aaff"; # blue          #82aaff
    base0E = "c099ff"; # magenta/purp  #c099ff
    base0F = "c53b53"; # rarely used   #c53b53
  };

  # Only touches what was flagged as hard to read on this screen: comments
  # and other "dim" text (base03/base04). Everything else stays identical
  # to vanilla tokyonight-moon.
  personalOverride = {
    base03 = "a3b0e0"; # #a3b0e0
    base04 = "97a4d4"; # #97a4d4
  };
in
{
  stylix.enable = true;
  stylix.polarity = "dark";

  # stylix tracks our nixpkgs (nixos-26.05) via `inputs.nixpkgs.follows`,
  # which is ahead of what stylix's maintainers have verified. We already
  # found and worked around the real incompatibilities this causes (see the
  # disabledModules list in flake.nix), so this check is just noise now.
  stylix.enableReleaseChecks = false;

  # Only enable system-level targets explicitly: some of stylix's
  # auto-enabled ones (e.g. regreet) reference options that don't exist on
  # this nixpkgs release and fail to evaluate. Home-manager app targets are
  # set explicitly in home/theme.nix regardless of this.
  stylix.autoEnable = false;
  stylix.targets.console.enable = true;

  stylix.base16Scheme = vanilla;
  stylix.override = if variant == "personal" then personalOverride else { };

  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.inconsolata;
      name = "Inconsolata Nerd Font Mono";
    };
    sansSerif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };
    serif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };
    sizes = {
      terminal = 14;
      applications = 11;
      desktop = 13;
      popups = 12;
    };
  };
}
