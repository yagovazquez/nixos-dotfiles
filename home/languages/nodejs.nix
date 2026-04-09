# home/languages/nodejs.nix
{ config, pkgs, lib, ... }:

{
  # Append to your existing home.packages
  home.packages = with pkgs; [
    nodejs 

    # Optional: Common global Node.js tools installed declaratively
    nodePackages.pnpm
    nodePackages.yarn
    nodePackages.typescript
    nodePackages.typescript-language-server
  ];
}
