{ pkgs, ... }:

let
  # === THE ONE SWITCH ===
  # "personal" = tokyonight-night with comments brightened for this screen.
  # "vanilla" = unmodified tokyonight-night. Flip and `update` to apply.
  variant = "personal";

  # Plain tokyonight-moon (https://github.com/folke/tokyonight.nvim), as a
  # base16 scheme. No longer the active scheme (see `night` below) — kept
  # around unused as a reference for what "moon" looked like.
  moon = {
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

  # tokyonight-night (https://github.com/folke/tokyonight.nvim), as a base16
  # scheme — same palette family as moon, but swapped to the "night" accent
  # set and, for base00, to tokyonight's own `bg_dark` (#16161e, the color it
  # already uses for sidebars/floats) instead of its main `bg` (#1a1b26).
  # `bg_dark` is darker and noticeably less blue-saturated than moon's
  # #222436, while still reading as "tokyonight". base02 is recomputed with
  # tokyonight's own bg_visual formula (blend #3d59a1 at 40% onto base00) so
  # selection highlight keeps the same relationship to the background that
  # moon had. This single swap also raises bg/fg contrast across the board
  # (checked with WCAG contrast ratios): fg 10.26:1 -> 11.14:1, fg_dark
  # 4.61:1 -> 8.52:1 (good enough it no longer needs the override below),
  # comment+override 7.17:1 -> 8.43:1.
  night = {
    scheme = "Tokyo Night";
    author = "folke/tokyonight.nvim, adapted to base16";
    slug = "tokyonight-night";
    base00 = "16161e"; # bg (using tokyonight's bg_dark) #16161e
    base01 = "292e42"; # bg_highlight  #292e42
    base02 = "263152"; # bg_visual/sel #263152
    base03 = "565f89"; # comment, dim  #565f89
    base04 = "a9b1d6"; # fg_dark       #a9b1d6
    base05 = "c0caf5"; # fg            #c0caf5
    base06 = "c0caf5"; # light fg      #c0caf5
    base07 = "cdd5f7"; # lightest fg   #cdd5f7
    base08 = "f7768e"; # red           #f7768e
    base09 = "ff9e64"; # orange        #ff9e64
    base0A = "e0af68"; # yellow        #e0af68
    base0B = "9ece6a"; # green         #9ece6a
    base0C = "7dcfff"; # cyan          #7dcfff
    base0D = "7aa2f7"; # blue          #7aa2f7
    base0E = "bb9af7"; # magenta/purp  #bb9af7
    base0F = "db4b4b"; # rarely used   #db4b4b
  };

  # Brightens comments, the one thing still flagged as hard to read on this
  # screen against the new, darker base00. fg_dark (base04) doesn't need a
  # bump here — swapping to bg_dark already pushed its contrast from 4.61:1
  # to 8.52:1 on its own.
  personalOverride = {
    base03 = "a3b0e0"; # #a3b0e0
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

  stylix.base16Scheme = night;
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
