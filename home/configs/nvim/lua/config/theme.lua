-- Shared base16 palette, read once and reused by anything that needs to
-- theme itself off the live system colorscheme (mini.base16, lualine, …).
-- Values come from NIX_THEME_* env vars exported by home/theme.nix; the
-- fallback below is the vanilla Tokyo Night Moon palette, for a bare
-- `nvim` run outside that environment.
local fallback = {
  base00 = "#222436", base01 = "#2f334d", base02 = "#2d3f76", base03 = "#636da6",
  base04 = "#828bb8", base05 = "#c8d3f5", base06 = "#c8d3f5", base07 = "#d5dbf7",
  base08 = "#ff757f", base09 = "#ff966c", base0A = "#ffc777", base0B = "#c3e88d",
  base0C = "#86e1fc", base0D = "#82aaff", base0E = "#c099ff", base0F = "#c53b53",
}

local M = {}

function M.get()
  local palette = {}
  for slot, default in pairs(fallback) do
    palette[slot] = vim.env["NIX_THEME_" .. slot:upper()] or default
  end
  return palette
end

return M
