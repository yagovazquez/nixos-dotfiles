{ pkgs, ... }:

let
  # === THE ONE SWITCH ===
  # "personal" = tokyonight-night with comments brightened for this screen.
  # "vanilla" = unmodified tokyonight-night. Flip and `update` to apply.
  variant = "vanilla";

  custom = {
    scheme = "Tokyo Night Custom";
    author = "Yago, adapted to base16";
    slug = "tokyonight-custom";
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
    base0B = "00fa9a";                 #00FA9A      #2DC937
    base0C = "7dcfff"; # cyan          #7dcfff
    base0D = "7aa2f7"; # blue          #7aa2f7
    base0E = "bb9af7"; # magenta/purp  #bb9af7
    base0F = "db4b4b"; # rarely used   #db4b4b
  };
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

  # tokyonight's own bg_visual formula (blend #3d59a1 at 40% onto base00) so
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

  mfd = {
    scheme = "MFD Mono";
    author = "kungfusheep/mfd.nvim, adapted to base16";
    slug = "mfd-mono";
    base00 = "000000"; # bg            #08080C
    base01 = "0C0C10"; # float_bg      #0C0C10
    base02 = "1A1A22"; # visual/sel    #1A1A22
    base03 = "343440"; # dim, comments (brightened from #282830)
    base04 = "585860"; # subtle        (brightened from #383840)
    base05 = "DCDCE4"; # fg            (brightened from #D0D0D8)
    base06 = "ECECF4"; # light fg      (brightened from #E0E0E8)
    base07 = "FCFCFF"; # bright        (brightened from #F0F0FF)
    base08 = "808088"; # red slot -> gray (brightened from #606068)
    base09 = "909098"; # orange slot -> gray (brightened from #707078)
    base0A = "A0A0A8"; # yellow slot -> gray (brightened from #808088)
    base0B = "B0B0B8"; # green slot -> gray (brightened from #909098)
    base0C = "C0C0C8"; # cyan slot -> gray (brightened from #A0A0A8)
    base0D = "D0D0D8"; # blue slot -> gray (brightened from #B0B0B8)
    base0E = "E0E0E8"; # magenta slot -> gray (brightened from #C0C0C8)
    base0F = "606068"; # rarely used -> gray (brightened from #404048)
  };

  gruvbox = {
    scheme = "Gruvbox dark, hard";
    author = "Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)";
    slug = "gruvbox-dark-hard";
    base00 = "1d2021"; # bg            #1d2021
    base01 = "3c3836"; # bg_highlight  #3c3836
    base02 = "504945"; # bg_visual/sel #504945
    base03 = "665c54"; # comment, dim  #665c54
    base04 = "bdae93"; # fg_dark       #bdae93
    base05 = "d5c4a1"; # fg            #d5c4a1
    base06 = "ebdbb2"; # light fg      #ebdbb2
    base07 = "fbf1c7"; # lightest fg   #fbf1c7
    base08 = "fb4934"; # red           #fb4934
    base09 = "fe8019"; # orange        #fe8019
    base0A = "fabd2f"; # yellow        #fabd2f
    base0B = "b8bb26"; # green         #b8bb26
    base0C = "8ec07c"; # cyan          #8ec07c
    base0D = "83a598"; # blue          #83a598
    base0E = "d3869b"; # magenta/purp  #d3869b
    base0F = "d65d0e"; # rarely used   #d65d0e
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

  #################
  # Scheme on use #
  #################

  stylix.base16Scheme = custom;
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
