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
  # CUDA is built only for the GTX 1060's compute capability (6.1, Pascal):
  # nixpkgs' default list starts at 7.5 and leaves Pascal out. Stay on the
  # default cudaPackages (12.9): CUDA 13 dropped Pascal.
  nixpkgs.config.cudaCapabilities = [ "6.1" ];

  services.sunshine = {
    enable = true;
    # With CUDA, NVENC encodes the captured frames straight from video
    # memory. Without it Sunshine copies each frame GPU -> RAM -> GPU
    # (~1.5 CPU cores at 1080p60).
    package = pkgs.sunshine.override { cudaSupport = true; };
    # Ports stay closed on the LAN, opened on tailscale0 below.
    openFirewall = false;
    # Off: it's only for KMS capture, and wlroots screencopy works here.
    capSysAdmin = false;
    # Only on demand: `empezar` on the laptop runs `start-sunshine` here.
    autoStart = false;
  };
  # No LD_LIBRARY_PATH needed for NVENC: the CUDA build finds the driver's
  # libcuda.so.1 through its RUNPATH (/run/opengl-driver/lib), and its
  # wrapper overwrites LD_LIBRARY_PATH anyway.

  # Moonlight is added by hand over Tailscale; no need to announce the PC on the LAN.
  services.avahi.enable = false;

  # Hands the logged-in session's Wayland display to the user unit, then
  # (re)starts it. Usually run over SSH, where WAYLAND_DISPLAY isn't set, so
  # it finds the session's socket itself. Stop it: `systemctl --user stop sunshine`.
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "start-sunshine";
      text = ''
        if [ -z "''${WAYLAND_DISPLAY:-}" ]; then
          for s in "$XDG_RUNTIME_DIR"/wayland-*; do
            case "$s" in *.lock) continue ;; esac
            [ -S "$s" ] && WAYLAND_DISPLAY=$(basename "$s") && break
          done
        fi
        if [ -z "''${WAYLAND_DISPLAY:-}" ]; then
          echo "El PC no tiene sesión iniciada (Hyprland o labwc); inicia sesión y vuelve a probar." >&2
          exit 1
        fi
        export WAYLAND_DISPLAY
        systemctl --user import-environment WAYLAND_DISPLAY
        systemctl --user restart sunshine
        echo "Sunshine arrancado en el PC. Abre Moonlight."
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
