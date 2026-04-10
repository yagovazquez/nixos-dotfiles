-- QoL keymaps (moved from init.lua)
local map = vim.keymap.set

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
