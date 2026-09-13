{ config, pkgs, lib, ... }:

{
  # Enable Emacs and configure it for Wayland (Pure GTK)
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk; # Native Wayland rendering
  };

  # Packages highly recommended for Doom Emacs (dependencies and tools)
  home.packages = with pkgs; [
    # Core Doom dependencies
    ripgrep
    fd
    findutils

    # Fonts (Doom uses these for icons in the modeline and treemacs)
    emacs-all-the-icons-fonts

    # For compiling some Emacs packages natively (like vterm or sqlite for org-roam)
    cmake
    libtool
  ];
}
