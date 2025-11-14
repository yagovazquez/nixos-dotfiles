{ config, pkgs, lib, ... }:

{
    programs.helix = {
        enable = true;
        settings = {
            theme = "tokyonight_moon";
        };
    };
}   
