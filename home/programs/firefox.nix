{ config, pkgs, lib, ... }:

{
  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";
    profiles."3z7tqry0.default" = {
      isDefault = true;

      settings = {
        "browser.startup.homepage" = "file:///home/agallas/nix-config/home/configs/firefox/startpage/index.html";
        "browser.startup.page" = 1;
        "browser.newtabpage.activity-stream.enabled" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "sidebar.revamp" = false;
      };

      userChrome = builtins.readFile ../configs/firefox/userChrome.css;

      # Acknowledges that stylix's firefox colorTheme target (home/theme.nix)
      # owns the FirefoxColor extension's settings outright — fine since we
      # don't declare any settings of our own for it.
      extensions.settings."FirefoxColor@mozilla.com".force = true;
    };
  };
}
