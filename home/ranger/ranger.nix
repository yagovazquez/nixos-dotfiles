{ config, pkgs, lib, ... }:

{

  programs.ranger = {
    enable = true;
    # Basic settings. `settings` writes to rc.conf as `set key value`.
    settings = {
      show_hidden = true;      # show dotfiles
      colorscheme = "default";
    };
    # Extra ranger config (also ends up in rc.conf)
    extraConfig = ''
      # ---- devicons ----
      default_linemode devicons

      set show_hidden true
      set preview_images true
      # Works with ueberzug++ (compatible with the old "ueberzug" method)
      set preview_images_method ueberzug
      set use_preview_script true
    '';
  };

  # Make sure ranger uses the stock scope.sh (which already knows poppler/ffmpegthumbnailer)
  # If you don’t set this, ranger will still ship one internally; this just makes it explicit.
  #xdg.configFile."ranger/scope.sh".source = "${pkgs.ranger}/share/doc/ranger/config/scope.sh";

}

#Download devicons:
#in a new computer do:
#git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
