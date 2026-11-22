{ config, lib, pkgs, ... }:
let
	colors = config.lib.stylix.colors;
	hyprlandLua = builtins.replaceStrings
		[ "__ACTIVE_BORDER__" "__INACTIVE_BORDER__" "__SHADOW_COLOR__" "--[[__MONITORS__]]" ]
		[
			"rgba(${colors.base0D}ff)"
			"rgba(${colors.base03}ff)"
			"rgba(${colors.base00}ee)"
			config.my.hyprland.monitors
		]
		(builtins.readFile ./hyprland.lua);
in
{
	options.my.hyprland.monitors = lib.mkOption {
		type = lib.types.lines;
		# Any monitor, its preferred mode, placed automatically.
		default = ''
			hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1" })
		'';
		description = "Lua hl.monitor(...) rules for this machine, spliced into hyprland.lua at __MONITORS__.";
	};

	config = {
		home.packages = with pkgs; [
			hyprpaper
			hyprlock
			hyprshot
			hyprsunset
		];

		# Out-of-store so editing hyprpaper.conf directly takes effect without a rebuild
		home.file.".config/hypr/hyprpaper.conf".source =
			config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/home/configs/hypr/hyprpaper.conf";
		# Colors templated in from the shared palette (see home/theme.nix) and
		# monitors from the host (see above); everything else in this file is
		# edited directly.
		home.file.".config/hypr/hyprland.lua".text = hyprlandLua;
	};
}
