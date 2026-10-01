# modules/Python.nix
{ config, pkgs, lib, ... }:

let
  py = pkgs.python312;
  pyEnv = py.withPackages (pypkgs: with pypkgs; [
    notebook
    numpy
    pandas
    scikit-learn
    matplotlib
    manim
  ]);
in
{
  # Append to your existing home.packages (won't override it)
  home.packages = lib.mkAfter [ pyEnv ];
}

