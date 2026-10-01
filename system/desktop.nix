{config, pkgs, lib, ... }:
{

  services.greetd.enable = true;
  services.greetd.settings = {
    default_session = {
      #command = "tuigreet --remember --time --cmd 'dbus-run-session Hyprland'";
      command = "tuigreet --remember --time --cmd 'dbus-run-session start-hyprland'";
      user = "agallas";
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];
  };


  # XMonad
  services.xserver.enable = true;
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };


}
