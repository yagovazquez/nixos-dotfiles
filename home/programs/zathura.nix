{ config, pkgs, lib, ... }:

{
  programs.zathura = {
    enable = true;
    # Colors come from stylix.targets.zathura (see home/theme.nix).
    options = {
      font = "inconsolata 10";
      recolor = true;
      recolor-keephue = true;
      smooth-scroll = true;
      statusbar-h-padding = 0;
      statusbar-v-padding = 0;
      page-padding = 1;
    };
  };
}
