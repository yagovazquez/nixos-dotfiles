{ config, pkgs, ... }:
let
	colors = config.lib.stylix.colors;
	hyprlandLua = builtins.replaceStrings
		[ "__ACTIVE_BORDER__" "__INACTIVE_BORDER__" "__SHADOW_COLOR__" ]
		[
			"rgba(${colors.base0D}ff)"
			"rgba(${colors.base03}ff)"
			"rgba(${colors.base00}ee)"
		]
		(builtins.readFile ./hyprland.lua);
in
{
	home.packages = with pkgs; [
		hyprpaper
		hyprlock
		hyprshot
		hyprsunset
	];

	# Out-of-store so editing hyprpaper.conf directly takes effect without a rebuild
	home.file.".config/hypr/hyprpaper.conf".source =
		config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/home/configs/hypr/hyprpaper.conf";
	# Colors templated in from the shared palette (see home/theme.nix);
	# everything else in this file is edited directly.
	home.file.".config/hypr/hyprland.lua".text = hyprlandLua;
}
