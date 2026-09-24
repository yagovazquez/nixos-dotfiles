{
  description = "OCaml command-line todo app";

  inputs.nixpkgs.url = "nixpkgs/nixos-26.05";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      ocamlPackages = pkgs.ocamlPackages;
    in {
      packages.${system}.default = ocamlPackages.buildDunePackage {
        pname = "todo";
        version = "0.1.0";
        src = ./.;
        duneVersion = "3";
      };

      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/todo";
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          ocamlPackages.ocaml
          ocamlPackages.dune_3
          ocamlPackages.findlib
          pkgs.ocamlformat
          ocamlPackages.ocaml-lsp
        ];
      };
    };
}
