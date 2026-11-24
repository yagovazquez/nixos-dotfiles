# PC ONLY: remote access from the laptop, only through Tailscale.
# - SSH (`ssh pc`): a terminal.
# - Sunshine: streams the desktop/games; the laptop watches with Moonlight.
{ pkgs, ... }:

{
  services.openssh = {
    enable = true;
    # Port 22 stays closed on the normal network (home Wi-Fi/LAN)...
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "agallas" ];
    };
  };

  # The laptop's key (its ~/.ssh/id_ed25519.pub). Public keys are safe to commit.
  users.users.agallas.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3Tjd0DrFS0fO4SKvMzk8+JdocTJm+hd8wP9vnxMdQI vazquezsanchezyago@gmail.com"
  ];

  # --- Sunshine (game streaming host) ---
  services.sunshine = {
    enable = true;
    # Ports stay closed on the LAN, opened on tailscale0 below.
    openFirewall = false;
    # Needed for KMS capture, the fallback when Wayland screen capture fails.
    capSysAdmin = true;
    # Its unit starts with graphical-session.target, which our greetd
    # sessions never reach. The compositors run `start-sunshine` instead
    # (Hyprland: my.hyprland.autostart in ./home.nix; labwc: ./labwc/autostart).
    autoStart = false;
  };
  # Moonlight is added by hand over Tailscale; no need to announce the PC on the LAN.
  services.avahi.enable = false;

  # Hands the session's Wayland display to the user unit, then (re)starts it,
  # so it always captures the session that's logged in now.
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "start-sunshine";
      text = ''
        systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE
        systemctl --user restart sunshine
      '';
    })
  ];

  networking.firewall.interfaces."tailscale0" = {
    # 22: SSH. 47984/47989/48010: Sunshine (pairing, control). The web UI
    # (47990) stays closed: reach it with an SSH tunnel to localhost.
    allowedTCPPorts = [ 22 47984 47989 48010 ];
    # Sunshine's video, control, audio and mic streams.
    allowedUDPPorts = [ 47998 47999 48000 48002 48010 ];
  };
}
