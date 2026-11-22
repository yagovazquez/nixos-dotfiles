{config, pkgs, lib, ... }:
{

  services.greetd.enable = true;
  services.greetd.settings = {
    default_session = {
      #command = "tuigreet --remember --time --cmd 'dbus-run-session Hyprland'";
      # mkDefault: a host with more than one session (the PC) replaces this
      # with a greeter that lets you pick.
      command = lib.mkDefault "tuigreet --remember --time --cmd 'dbus-run-session start-hyprland'";
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


  services.xserver.enable = true;


}
