{config, nixpkgs, lib, ... }:

{

  programs.git = {
    enable = true;
    settings = {
      user.Name = "yago";
      user.Email = "vazquezsanchezyago@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
  programs.gh.enable = true;

}
