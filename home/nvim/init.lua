--
-- =========================
-- Bootstrap lazy.nvim
-- =========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =========================
-- Core options
-- =========================
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

-- =========================
-- Plugins
-- =========================
require("lazy").setup({
  -- Theme: tokyonight (moon)
  { "folke/tokyonight.nvim", lazy = false, priority = 1000,
    opts = { style = "moon", transparent = false },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end
  },

  -- Statusline
  { "nvim-lualine/lualine.nvim",
    opts = { options = { theme = "tokyonight", globalstatus = true } },
    config = function(_, opts) require("lualine").setup(opts) end
  },

  -- Treesitter (syntax/indent/highlight)
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "bash", "python", "json", "markdown", "r", "rnoweb", "yaml", "ocaml", "ocaml_interface" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  -- Telescope (finder)
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local t = require("telescope")
      t.setup({})
      -- keymaps for telescope
      local map = vim.keymap.set
      map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
      map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",  { desc = "Live grep" })
      map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",    { desc = "Buffers" })
      map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",  { desc = "Help tags" })
    end
  },

  -- Git signs
  { "lewis6991/gitsigns.nvim",
    opts = {},
    config = function(_, opts) require("gitsigns").setup(opts) end
  },

  -- Which-key
  { "folke/which-key.nvim",
    opts = {},
    config = function(_, opts) require("which-key").setup(opts) end
  },

  -- Comments & autopairs
  { "numToStr/Comment.nvim",
    opts = {},
    config = function(_, opts) require("Comment").setup(opts) end
  },
  { "windwp/nvim-autopairs",
    opts = {},
    config = function(_, opts) require("nvim-autopairs").setup(opts) end
  },

  -- LSP base
  { "neovim/nvim-lspconfig" },

  -- Completion (nvim-cmp)
  { "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end,
          ["<S-Tab>"]   = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end,
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip"  },
          -- Add more completion sources here if desired
        },
      })
    end
  },

  -- ===== Core UX additions =====
  { "stevearc/dressing.nvim", opts = {} },
  { "rcarriga/nvim-notify", config = function() vim.notify = require("notify") end },
  -- -- -- -- -- -- -- -- -- { "max397574/better-escape.nvim", opts = { mapping = { "jk" } } },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = { scope = { enabled = true } } },
  { "echasnovski/mini.surround", version = "*", opts = {} },
  { "echasnovski/mini.ai",       version = "*", opts = {} },
  { "folke/persistence.nvim", event = "BufReadPre", opts = {} },

  -- ===== File Explorer (Neo-tree) =====
  { "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          filtered_items = { hide_dotfiles = false, hide_gitignored = true },
          follow_current_file = { enabled = true },
          use_libuv_file_watcher = true,
        },
        window = { width = 32 },
        default_component_configs = {
          git_status = { symbols = { added = "A", modified = "M", deleted = "D" } },
        },
      })
    end
  },

  -- ===== Startup & aesthetics =====
  { "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local ok, alpha = pcall(require, "alpha")
      if not ok then return end
      local dashboard = require("alpha.themes.dashboard")
      -- LazyVim-style logo
      
      local logo = [[
       ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
       ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
       ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
       ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
       ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           
       ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           
 ]]
      logo = string.rep("\n", 8) .. logo .. "\n\n"
      dashboard.section.header.val = vim.split(logo, "\n")


      -- Buttons menu
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
        dashboard.button("r", "  Recent",    ":Telescope oldfiles<CR>"),
        dashboard.button("g", "  Grep",      ":Telescope live_grep<CR>"),
        dashboard.button("e", "  New file",  ":ene | startinsert<CR>"),
        dashboard.button("c", "  Config",    ":e $MYVIMRC | cd %:p:h<CR>"),
        dashboard.button("q", "  Quit",      ":qa<CR>"),
      }
      -- Footer: show number of loaded plugins
      local stats = require("lazy").stats()
      dashboard.section.footer.val = ("󰒲  %d plugins loaded"):format(stats.count)
      -- Set up dashboard
      alpha.setup(dashboard.config)
    end
  },

  -- Icons (used by neo-tree, lualine, telescope, etc.)
  { "nvim-tree/nvim-web-devicons", lazy = true },
})

-- which-key reacts faster
vim.opt.timeoutlen = 300

-- =========================
-- LSP setup (Neovim 0.11+ API)
-- =========================

-- Completion capabilities (optional)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- Helper: define+enable a server only if its binary exists
local function setup_if_present(server, opts)
  opts = opts or {}
  -- if opts.cmd is set, check that binary; otherwise check the server name
  local cmd = (opts.cmd and opts.cmd[1]) or server
  if vim.fn.executable(cmd) ~= 1 then
    return
  end
  -- merge capabilities
  opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, capabilities)
  -- define/extend the config, then enable it for its filetypes
  vim.lsp.config(server, opts)
  vim.lsp.enable(server)
end

-- Servers (enabled only when present on PATH)
setup_if_present("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
})
setup_if_present("r_language_server", {
  cmd = { "R", "--slave", "-e", "languageserver::run()" },
})
setup_if_present("bashls")
setup_if_present("pyright")
setup_if_present("jsonls")
setup_if_present("yamlls")
setup_if_present("html")
setup_if_present("cssls")
setup_if_present("nixd")
setup_if_present("clangd")
setup_if_present("texlab")
setup_if_present("ocamllsp")



-- =========================
-- QoL keymaps
-- =========================
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
