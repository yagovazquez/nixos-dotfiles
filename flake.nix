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
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
	  modules = [
            ./system/configuration.nix
	  ];
	};
      };

      homeConfigurations = {
        agallas = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
	  modules = [
            ./home/home.nix
	  ];
	};
      };
    };

}
