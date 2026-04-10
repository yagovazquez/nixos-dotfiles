-- Core editor options (moved from init.lua)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

-- which-key reacts faster
vim.opt.timeoutlen = 300

-- Persistent undo
local undodir = vim.fn.stdpath("state") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
vim.opt.undofile = true
vim.opt.undodir = undodir

-- Keep signcolumn visible to avoid text shifting
vim.opt.signcolumn = "yes"

-- Comfortable scroll offset
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Folding: keep folds open by default but keep folding functionality available.
-- Some plugins (like ufo) or filetype settings may create folds; use these
-- settings to avoid having functions/classes collapsed on buffer open.
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = false

-- Optional: disable swap/backup files if you prefer
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
