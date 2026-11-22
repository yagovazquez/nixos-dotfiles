# PC ONLY: labwc, a lightweight floating desktop next to Hyprland.
# Its config files are in ./labwc/ (linked by ./home.nix).
{ config, pkgs, ... }:

let
  # The sessions offered at login. Listed explicitly so stray entries
  # (e.g. Hyprland's unused "uwsm" variant) don't show up.
  sessions = pkgs.linkFarm "greeter-sessions" [
    { name = "hyprland.desktop"; path = "${config.programs.hyprland.package}/share/wayland-sessions/hyprland.desktop"; }
    { name = "labwc.desktop"; path = "${config.programs.labwc.package}/share/wayland-sessions/labwc.desktop"; }
  ];
in
{
  programs.labwc.enable = true;

  environment.systemPackages = with pkgs; [
    swaybg # wallpaper (hyprpaper is Hyprland-only)
    grim   # screenshots
  ];

  # Login screen: F3 picks the session; the last one picked is remembered.
  services.greetd.settings.default_session.command =
    "tuigreet --remember --remember-session --time --sessions ${sessions} --session-wrapper dbus-run-session";
}
