{ config, pkgs, lib, ... }:

{

programs.firefox = {
  enable = true;
  profiles."3z7tqry0.default" = {
    isDefault = true;

    settings = {
      "browser.startup.homepage" = "file:///home/agallas/nix-config/home/firefox/startpage/index.html";
      "browser.startup.page" = 1;
      "browser.newtabpage.activity-stream.enabled" = false;
    };
  };
};

}
