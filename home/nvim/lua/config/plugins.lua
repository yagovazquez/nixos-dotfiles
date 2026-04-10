-- Plugin list (lazy.nvim)
require("lazy").setup({
  -- place lazy's lockfile in a writable XDG data directory on NixOS
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
  -- Theme: tokyonight (moon)
  { "folke/tokyonight.nvim", lazy = false, priority = 1000,
    opts = { style = "moon", transparent = false },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end
  },

  -- Highlight color codes in their actual color
  { "brenoprata10/nvim-highlight-colors",
    opts = {
      enable_hex = true,
      enable_short_hex = true,
      enable_rgb = true,
    },
    config = function(_, opts)
      require("nvim-highlight-colors").setup(opts)
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
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local ok, cmp = pcall(require, "cmp")
      if not ok then return end
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
        },
      })

      -- Command-line completion: enable suggestions for '/', '?' (search) and ':' (commands)
      -- Uses cmp-buffer for searches and cmp-path + cmp-cmdline for commands
      pcall(function()
        -- search (/) and (?) use buffer source
        cmp.setup.cmdline({ "/", "?" }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = { { name = "buffer" } },
        })

        -- command-line (:) uses path first, then cmdline source
        cmp.setup.cmdline(":", {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
        })
      end)
    end
  },

  -- ===== Core UX additions =====
  { "stevearc/dressing.nvim", opts = {} },
  { "rcarriga/nvim-notify", config = function() vim.notify = require("notify") end },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = { scope = { enabled = true } } },
  { "echasnovski/mini.surround", version = "*", opts = {} },
  { "echasnovski/mini.ai",       version = "*", opts = {} },
  { "folke/persistence.nvim", event = "BufReadPre", opts = {} },

  -- null-ls for formatters/linters (will only enable formatters found on PATH)
  { "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local ok, null_ls = pcall(require, "null-ls")
      if not ok then return end
      local b = null_ls.builtins
      local sources = {}
      if vim.fn.executable("stylua") == 1 then table.insert(sources, b.formatting.stylua) end
      if vim.fn.executable("black") == 1 then table.insert(sources, b.formatting.black) end
      if vim.fn.executable("prettier") == 1 then table.insert(sources, b.formatting.prettier) end
      null_ls.setup({ sources = sources })
    end
  },

  -- noice (nicer cmdline/messages)
  { "folke/noice.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {},
    config = function(_, opts)
      require("noice").setup(opts)
    end,
  },

  -- trouble (diagnostics list)
  { "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function() require("trouble").setup({}) end },

  -- better folding (ufo)
  { "kevinhwang91/nvim-ufo", dependencies = { "kevinhwang91/promise-async" }, config = function() require('ufo').setup() end },

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
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
        dashboard.button("r", "  Recent",    ":Telescope oldfiles<CR>"),
        dashboard.button("g", "  Grep",      ":Telescope live_grep<CR>"),
        dashboard.button("e", "  New file",  ":ene | startinsert<CR>"),
        dashboard.button("c", "  Config",    ":e $MYVIMRC | cd %:p:h<CR>"),
        dashboard.button("q", "  Quit",      ":qa<CR>"),
      }
      local stats = require("lazy").stats()
      dashboard.section.footer.val = ("󰒲  %d plugins loaded"):format(stats.count)
      alpha.setup(dashboard.config)
    end
  },

  -- Icons (used by neo-tree, lualine, telescope, etc.)
  { "nvim-tree/nvim-web-devicons", lazy = true },
})
