{ config, pkgs, lib, ... }:
{
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Opcional (comodidad)
  home.packages = with pkgs; [
    ocamlformat
    ocamlPackages.ocaml-lsp # o de ocaml-ng (ver abajo)
  ];

  home.sessionVariables.OCAMLFORMAT = "enable-outside-detected-project";
}

