{ config, pkgs, lib, ... }:

{
  programs.zathura = {
    enable = true;
    options = {
      # Tokyo Night Moon palette
      notification-error-bg = "#ff757f";
      notification-error-fg = "#c8d3f5";
      notification-warning-bg = "#ffc777";
      notification-warning-fg = "#444a73";
      notification-bg = "#222436";
      notification-fg = "#c8d3f5";
      completion-bg = "#222436";
      completion-fg = "#828bb8";
      completion-group-bg = "#222436";
      completion-group-fg = "#828bb8";
      completion-highlight-bg = "#444a73";
      completion-highlight-fg = "#c8d3f5";
      index-bg = "#222436";
      index-fg = "#c8d3f5";
      index-active-bg = "#444a73";
      index-active-fg = "#c8d3f5";
      inputbar-bg = "#222436";
      inputbar-fg = "#c8d3f5";
      statusbar-bg = "#222436";
      statusbar-fg = "#c8d3f5";
      highlight-color = "#ffc777";
      highlight-active-color = "#c3e88d";
      default-bg = "#222436";
      default-fg = "#c8d3f5";
      render-loading = true;
      render-loading-fg = "#222436";
      render-loading-bg = "#c8d3f5";
      recolor-lightcolor = "#222436";
      recolor-darkcolor = "#c8d3f5";

      font = "inconsolata 10";
      # Settings
      recolor = true;
      recolor-keephue = true;
      smooth-scroll = true;
      statusbar-h-padding = 0;
      statusbar-v-padding = 0;
      page-padding = 1;
    };
  };
}
