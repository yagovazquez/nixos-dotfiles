{ config, pkgs, lib, ... }:

{
  
  programs = {
    
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history = {
        ignoreDups = true;
        save = 50000;
        share = true;
      };

      shellAliases = {
      
        ll = "eza -lah";
        la = "eza -lha";       # incluye archivos ocultos
        lt = "eza -T";         # vista en árbol
        lg = "eza --git";       #info de Git

        cat = "bat";   #mejor vista de archivos

        #help = "bat ~/Desktop/comandos_terminal.txt";
        #helpvim = "bat ~/Desktop/comandos_neovim.txt";
        update = "sudo nixos-rebuild switch --flake ~/nix-config#nixos";
	      updatehome = "home-manager switch --flake ~/nix-config#agallas";
        note = ''nvim ~/Desktop/notes/$(date +"%m-%d_%H:%M").txt'';
        tasks = "cat ~/Desktop/notes/tasks.txt";
        newtask = "nvim ~/Desktop/notes/tasks.txt";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true; # provee "use flake"
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    bat.enable = true;
    eza.enable = true;
    ripgrep.enable = true;
    starship.enable = true;
  };
  
}
