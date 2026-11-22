# PC ONLY: games.
{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    # Community Proton build; runs some games stock Proton doesn't.
    # Choose it per game: Properties → Compatibility.
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  # Add `gamemoderun %command%` to a game's Steam launch options to put the
  # CPU in performance mode while it runs.
  programs.gamemode.enable = true;

  # Run AppImages directly (double-click, or ./game.AppImage).
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  environment.systemPackages = with pkgs; [
    steam-run # `steam-run ./game` for Linux games downloaded from the web
    heroic    # GOG / Epic / Amazon launcher
    lutris    # everything else, Windows installers included
    mangohud  # FPS overlay: `mangohud %command%` in Steam launch options
  ];
}
