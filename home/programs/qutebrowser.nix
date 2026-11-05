{ config, lib, ... }:

{
  programs.qutebrowser = {
    enable = true;
    loadAutoconfig = false;

    searchEngines = {
      DEFAULT = "https://www.google.com/search?q={}";
    };

    settings = {
      colors.webpage.darkmode.enabled = true;
      colors.webpage.bg = config.lib.stylix.colors.withHashtag.base00;

      # Stylix's qutebrowser template uses base03 (a dim/comment color) for
      # the active tab, which reads as grey. Force the accent blue instead
      # so the active tab stays legible, like before stylix.
      colors.tabs.selected.odd.bg = lib.mkForce config.lib.stylix.colors.withHashtag.base0D;
      colors.tabs.selected.even.bg = lib.mkForce config.lib.stylix.colors.withHashtag.base0D;
      colors.tabs.selected.odd.fg = lib.mkForce config.lib.stylix.colors.withHashtag.base00;
      colors.tabs.selected.even.fg = lib.mkForce config.lib.stylix.colors.withHashtag.base00;

      url = {
        default_page = "file:///home/agallas/nix-config/home/configs/firefox/startpage/index.html";
        start_pages = [ "file:///home/agallas/nix-config/home/configs/firefox/startpage/index.html" ];
      };
    };
  };
}
