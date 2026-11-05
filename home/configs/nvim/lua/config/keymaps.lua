-- QoL keymaps (moved from init.lua)
local map = vim.keymap.set

-- Change word under cursor across its occurrences, like vis's "gx" (select
-- all matches, then "c" changes them all). Neovim has no live multi-cursor,
-- so this starts the edit on the first match via "cgn"; press "." to repeat
-- the same change on each following occurrence. Replaces the default
-- "gx" (open URL/file under cursor).
map("n", "gx", function()
  vim.fn.setreg("/", "\\<" .. vim.fn.expand("<cword>") .. "\\>")
  vim.opt.hlsearch = true
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("cgn", true, false, true), "n", false)
end, { desc = "Change word under cursor (repeat with .)" })

-- LSP-related keymaps
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
map("n", "gd", vim.lsp.buf.definition,    { desc = "Go to definition" })
map("n", "K",  vim.lsp.buf.hover,         { desc = "Hover" })
map("n", "<leader>qq", "<cmd>qa<cr>",      { desc = "Quit all" })
map("n", "<leader>ws", "<cmd>w<cr>",       { desc = "Save" })

-- Neo-tree keymaps
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Explorer: toggle" })
map("n", "<leader>E", "<cmd>Neotree reveal<cr>", { desc = "Explorer: reveal file" })

-- LaTeX (VimTeX). Localleader is `\`; leader maps below are spacespace-free shortcuts.
map("n", "<leader>lc", "<cmd>VimtexCompile<cr>", { desc = "LaTeX: compile (toggle)" })
map("n", "<leader>lv", "<cmd>VimtexView<cr>", { desc = "LaTeX: view PDF (SyncTeX)" })
map("n", "<leader>ls", "<cmd>VimtexStop<cr>", { desc = "LaTeX: stop compiler" })
map("n", "<leader>le", "<cmd>VimtexErrors<cr>", { desc = "LaTeX: error list" })
map("n", "<leader>lt", "<cmd>VimtexTocToggle<cr>", { desc = "LaTeX: table of contents" })
map("n", "<leader>lk", "<cmd>VimtexClean<cr>", { desc = "LaTeX: clean aux files" })
map("n", "<leader>lf", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "LaTeX: format (texlab)" })

-- Session management with persistence.nvim
map("n", "<leader>qs", function() require("persistence").load() end,             { desc = "Session: restore" })
map("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Session: last" })
map("n", "<leader>qd", function() require("persistence").stop() end,             { desc = "Session: stop" })
