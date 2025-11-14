# modules/Python.nix
{ config, pkgs, lib, ... }:

let
  py = pkgs.python312;
  pyEnv = py.withPackages (pypkgs: with pypkgs; [
    numpy
    pandas
    torch
    scikit-learn
    matplotlib
    yfinance
    tqdm
  ]);
in
{
  # Append to your existing home.packages (won't override it)
  home.packages = lib.mkAfter [ pyEnv ];
}

