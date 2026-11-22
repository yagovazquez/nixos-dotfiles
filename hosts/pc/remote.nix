# PC ONLY: let the laptop in over SSH, but only through Tailscale.
{ ... }:

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
  # ...and is open only on the Tailscale interface.
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 22 ];

  # The laptop's key (its ~/.ssh/id_ed25519.pub). Public keys are safe to commit.
  users.users.agallas.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3Tjd0DrFS0fO4SKvMzk8+JdocTJm+hd8wP9vnxMdQI vazquezsanchezyago@gmail.com"
  ];
}
