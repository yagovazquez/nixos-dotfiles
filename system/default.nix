# SHARED by every machine (laptop and PC). Machine-specific settings,
# including hardware and stateVersion, live in hosts/<name>/.
{ config, pkgs, ... }:

{
  imports =
    [
      ./desktop.nix
      ./common.nix
      ./theme.nix
    ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.agallas = {
    isNormalUser = true;
    description = "agallas";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # qutebrowser 3.7.0 is flagged insecure upstream for still accepting
  # eMudhra TLS certs; we don't rely on that CA, so allow it through.
  nixpkgs.config.permittedInsecurePackages = [
    "qutebrowser-3.7.0"
  ];

  environment.systemPackages = with pkgs; [
     neovim      
     wget
     tree
     tuigreet
     blueman  # bluetooth
     kitty
     pavucontrol
     upower
     ];

  programs.nix-ld.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Weekly cleanup: drop generations older than 14 days, then GC the store.
  # (Without --delete-older-than, gc only removes unreferenced paths and
  # never touches old generations, which is where the space goes.)
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  # Hard-link identical files in the store.
  nix.optimise.automatic = true;
}

