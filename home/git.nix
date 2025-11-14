{config, nixpkgs, lib, ... }:

{

  programs.git = {
    enable = true;
    userName = "yago";
    userEmail = "vazquezsanchezyago@gmail.com";
    extraConfig = { init.defaultBranch = "main"; pull.rebase = true; };
  };

}
