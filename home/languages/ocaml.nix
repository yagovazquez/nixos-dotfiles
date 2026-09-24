{ config, pkgs, lib, ... }:
let
  todo = pkgs.ocamlPackages.buildDunePackage {
    pname = "todo";
    version = "0.1.0";
    src = lib.cleanSource ../todo;
    duneVersion = "3";
  };
in
{
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.packages = with pkgs; [
    ocamlformat
    ocamlPackages.ocaml-lsp
    todo
  ];

  home.sessionVariables.OCAMLFORMAT = "enable-outside-detected-project";
}
