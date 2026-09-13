-- QoL keymaps (moved from init.lua)
local map = vim.keymap.set
local colorscheme_names = { "tokyonight", "catppuccin", "rose-pine", "gruvbox" }

local function set_colorscheme(name)
  local ok = pcall(vim.cmd.colorscheme, name)
  if ok then
    vim.notify("Theme: " .. name, vim.log.levels.INFO)
    return true
  end

  vim.notify("Theme unavailable: " .. name, vim.log.levels.WARN)
  return false
end

local function cycle_colorscheme(direction)
  local current = vim.g.colors_name or "tokyonight"
  local index = 1

  for i, scheme in ipairs(colorscheme_names) do
    if scheme == current then
      index = i
      break
    end
  end

  local next_index = ((index - 1 + direction) % #colorscheme_names) + 1
  set_colorscheme(colorscheme_names[next_index])
end

-- Colorscheme switching
map("n", "<leader>tt", function() set_colorscheme("tokyonight") end, { desc = "Theme: Tokyo Night Moon" })
map("n", "<leader>th", function() cycle_colorscheme(1) end, { desc = "Theme: next colorscheme" })
map("n", "<leader>tH", function() cycle_colorscheme(-1) end, { desc = "Theme: previous colorscheme" })

-- LSP-related keymaps
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
map("n", "gd", vim.lsp.buf.definition,    { desc = "Go to definition" })
map("n", "K",  vim.lsp.buf.hover,         { desc = "Hover" })
map("n", "<leader>qq", "<cmd>qa<cr>",      { desc = "Quit all" })
map("n", "<leader>ws", "<cmd>w<cr>",       { desc = "Save" })

-- Neo-tree keymaps
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Explorer: toggle" })
map("n", "<leader>E", "<cmd>Neotree reveal<cr>", { desc = "Explorer: reveal file" })

-- Session management with persistence.nvim
map("n", "<leader>qs", function() require("persistence").load() end,             { desc = "Session: restore" })
map("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Session: last" })
map("n", "<leader>qd", function() require("persistence").stop() end,             { desc = "Session: stop" })
