{

  description = "flake duro";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";

    # Tracks latest upstream releases, used only for fast-moving packages
    # (e.g. code-cursor) that lag too far behind on the stable channel.
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, stylix, ... }:
      let
        lib = nixpkgs.lib;
        system = "x86_64-linux";
        unstablePkgs = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };

        # One machine = the shared config (./system + ./home) plus its own
        # folder in ./hosts. Anything under hosts/<name>/ only ever reaches
        # that machine; everything else reaches all of them.
        mkHost = hostDir: lib.nixosSystem {
          inherit system;
          modules = [
            hostDir
            ./system

            # Several of stylix's system-level (NixOS) targets reference
            # options that don't exist / were renamed on this nixpkgs
            # release (e.g. regreet, kmscon), and none of them apply to
            # this setup anyway (no grub/lightdm/gnome/qt/chromium/etc
            # here). Only `console` (TTY colors) is actually wanted, so
            # drop the rest outright instead of fighting each one.
            {
              disabledModules = map (m: "${stylix}/modules/${m}/nixos.nix") [
                "chromium" "feh" "fish" "fontconfig" "font-packages" "glance" "gnome" "gnome-text-editor" "grub" "gtk" "gtksourceview" "kmscon" "lightdm" "limine" "neovim" "plymouth" "qt" "regreet" "spicetify"
              ];
            }

            stylix.nixosModules.stylix

            # Include the Home Manager NixOS module
            home-manager.nixosModules.home-manager

            # Configure Home Manager settings inline
            {
              home-manager.backupFileExtension = "oldcopy";
              # Use the system-level nixpkgs instead of instantiating a separate one
              home-manager.useGlobalPkgs = true;
              # Install user packages directly to /etc/profiles instead of ~/.nix-profile
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit unstablePkgs; };
              # Shared home config; each host adds its own hosts/<name>/home.nix on top.
              home-manager.users.agallas.imports = [ ./home/home.nix ];
            }
          ];
        };
      in {
        # `nixos-rebuild --flake <dir>` with no `#name` picks the entry
        # matching the machine's hostname, so these names = hostnames.
        nixosConfigurations = {
          laptop = mkHost ./hosts/laptop;
        };
      };

}
