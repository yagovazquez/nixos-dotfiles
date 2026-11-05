{ config, lib, ... }:

let
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  programs.rofi = {
    enable = true;
    # Color theme comes from stylix.targets.rofi (see home/theme.nix).
    # Layout/sizing below restores what the old tokyonight-moon.rasi theme
    # set (stylix's rofi target only supplies colors, not layout).
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      "drun-display-format" = "{name}";
      "icon-theme" = "NineIcons";
    };

    theme = {
      "*" = {
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        spacing = mkLiteral "0px";
      };

      # The old tokyonight-moon.rasi (home/configs/rofi/themes/, pre-stylix)
      # kept the window itself plain dark (nord0, same slot as base00) and
      # used its accent blue (nord8/base0D) only for the border and the
      # prompt text — stylix's template doesn't set either, so they fall
      # back to a plain foreground-colored border. Restore both to accent
      # blue (`@blue`, stylix's own base0D alias) to match that look.
      window = {
        location = mkLiteral "center";
        width = mkLiteral "480px";
        border = mkLiteral "1px";
        "border-color" = mkLiteral "@blue";
      };

      prompt.text-color = lib.mkForce (mkLiteral "@blue");

      inputbar = {
        padding = mkLiteral "8px 12px";
        spacing = mkLiteral "12px";
        children = mkLiteral "[ prompt, entry ]";
      };

      "prompt, entry, element-text, element-icon" = {
        "vertical-align" = mkLiteral "0.5";
      };

      listview = {
        lines = mkLiteral "8";
        columns = mkLiteral "1";
        "fixed-height" = mkLiteral "false";
      };

      element = {
        padding = mkLiteral "8px";
        spacing = mkLiteral "8px";
      };

      "element-icon" = {
        size = mkLiteral "1.25em";
      };
    };
  };
}
