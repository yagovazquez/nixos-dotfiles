{

  description = "flake duro";
  
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
      let
        lib = nixpkgs.lib;
        system = "x86_64-linux";
      in {
        nixosConfigurations = {
          nixos = lib.nixosSystem {
            inherit system;
            modules = [
              ./system/configuration.nix
              
              # Include the Home Manager NixOS module
              home-manager.nixosModules.home-manager
              
              # Configure Home Manager settings inline
              {
                # Use the system-level nixpkgs instead of instantiating a separate one
                home-manager.useGlobalPkgs = true;
                # Install user packages directly to /etc/profiles instead of ~/.nix-profile
                home-manager.useUserPackages = true;
                # 3. Import your existing home.nix for the user "agallas"
                home-manager.users.agallas = import ./home/home.nix;
              }
            ];
          };
        };
      };

}
