{ config, pkgs, ... }:
{
	home.packages = with pkgs; [
		hyprpaper
		hyprlock
		hyprshot
		hyprsunset
	];

	home.file.".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
	home.file.".config/hypr/hyprland.lua".source = ./hyprland.lua;
}
