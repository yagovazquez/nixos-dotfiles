-- Plugin list (lazy.nvim)
require("lazy").setup({
  -- place lazy's lockfile in a writable XDG data directory on NixOS
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",

  -- Theme: the exact base16 palette from system/theme.nix (same colors as
  -- every other themed program), passed in via env vars from
  -- home/theme.nix. Falls back to the vanilla Tokyo Night Moon palette
  -- when run outside that environment (e.g. a bare `nvim`).
  { "echasnovski/mini.base16", lazy = false, priority = 1000,
    config = function()
      local palette = require("config.theme").get()
      require("mini.base16").setup({ palette = palette })

      -- mini.base16 puts LineNr/SignColumn on base01, a different bg than
      -- the editor body (base00) — that reads as a wide colored sidebar.
      -- Blend them into the body instead, and make the cursor's own line
      -- number stand out (the one thing that *should* grab attention).
      local hi = vim.api.nvim_set_hl
      -- Drop the explicit RGB background on the editor body so Ghostty's
      -- background-opacity (which only blends cells with no explicit bg
      -- color set) actually applies to nvim too. Floats/popups/statusline
      -- keep their solid backgrounds for legibility.
      hi(0, "Normal", { bg = "NONE" })
      hi(0, "NormalNC", { bg = "NONE" })
      hi(0, "EndOfBuffer", { bg = "NONE" })
      hi(0, "LineNr", { fg = palette.base03, bg = "NONE" })
      hi(0, "LineNrAbove", { fg = palette.base03, bg = "NONE" })
      hi(0, "LineNrBelow", { fg = palette.base03, bg = "NONE" })
      hi(0, "SignColumn", { bg = "NONE" })
      hi(0, "CursorLine", { bg = palette.base01 })
      hi(0, "CursorLineNr", { fg = palette.base0D, bold = true, bg = palette.base01 })

      -- Diagnostic signs link to the "Floating" variants by default, which
      -- carry a base01 box background — fine in a float, but it leaves a
      -- stray highlighted square around the icon in the (now transparent)
      -- sign column. Keep the severity color, drop the box.
      for _, sev in ipairs({ "Error", "Warn", "Info", "Hint", "Ok" }) do
        local base = vim.api.nvim_get_hl(0, { name = "Diagnostic" .. sev })
        hi(0, "DiagnosticSign" .. sev, { fg = base.fg, bg = "NONE" })
      end

      -- base16's spec puts "Type" (classes, and everything that default-
      -- links to it: StorageClass/Structure/Typedef, plus the @type
      -- treesitter capture) on base0A, and "Identifier" (plus @property,
      -- which default-links to it) on base08. That's the right call for a
      -- scheme ported faithfully to base16 (gruvbox's classes really are
      -- base0A-yellow), but our tokyonight ports were built by copying
      -- tokyonight's own named colors slot-for-slot (red->base08,
      -- yellow->base0A, ...) to keep ANSI/search-highlight colors sane
      -- system-wide — and tokyonight itself doesn't use yellow for types or
      -- red for object fields, so those two groups end up visibly wrong:
      -- every class/type name reads as a warning, every `.field` access
      -- reads as an error. Point them at base0C instead (closest to
      -- tokyonight's actual type/property hue, and still a calm, non-
      -- alarming color for any other scheme) without touching the palette
      -- itself, so ANSI yellow/red stay intact everywhere else.
      hi(0, "Type", { fg = palette.base0C })
      hi(0, "@property", { fg = palette.base0C })
      -- These two aren't shared with anything ANSI-sensitive, and happen to
      -- land exactly on tokyonight's real colors already (constructors in
      -- magenta, builtin vars like self/this in red), so just repoint them
      -- off their current, less accurate default links (both currently
      -- inherit cyan via "Special").
      hi(0, "@constructor", { fg = palette.base0E })
      hi(0, "@variable.builtin", { fg = palette.base08 })

      -- "Delimiter" is base16's one group for all punctuation, and both
      -- @punctuation.bracket and @punctuation.delimiter default-link to it
      -- — so brackets and , . : currently share one color. Split them:
      -- brackets fade into fg_dark (they're structural, not meaningful),
      -- while delimiters and operators pick up the cyan accent instead of
      -- base16's plain fg, so they read as punctuation rather than text.
      hi(0, "Delimiter", { fg = palette.base04 })
      hi(0, "@punctuation.bracket", { fg = palette.base04 })
      hi(0, "Operator", { fg = palette.base0C })
      hi(0, "@punctuation.delimiter", { fg = palette.base0C })
      hi(0, "@operator", { fg = palette.base0C })

      -- vis (like most terminal apps) renders every syntax color in bold —
      -- Scintillua lexer themes default every non-neutral STYLE_* to
      -- "...,bold" (see vis's own base-16.lua theme). mini.base16 leaves
      -- all of these at regular weight, so the exact same colors read
      -- visibly thinner here than they do in vis. Match the weight on the
      -- groups that actually carry syntax color (not Comment, which stays
      -- on the dim/neutral base03 by design, or Delimiter/@punctuation.
      -- bracket, deliberately kept plain above).
      for _, name in ipairs({
        "Boolean", "Character", "Conditional", "Constant", "Debug", "Define",
        "Exception", "Float", "Function", "Identifier", "Include", "Keyword",
        "Label", "Macro", "Number", "Operator", "PreCondit", "PreProc",
        "Repeat", "Special", "SpecialChar", "SpecialComment", "Statement",
        "StorageClass", "String", "Structure", "Tag", "Todo", "Type", "Typedef",
        "@constructor", "@operator", "@property", "@punctuation.delimiter",
        "@variable.builtin",
      }) do
        local def = vim.api.nvim_get_hl(0, { name = name, link = false })
        def.bold = true
        hi(0, name, def)
      end
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

  -- Statusline: mode-colored like vis's statusline.lua (blue=normal,
  -- magenta=insert, green=visual, red=replace, cyan=command), driven by
  -- the same live palette instead of lualine's generic "auto" theme.
  { "nvim-lualine/lualine.nvim",
    config = function()
      local palette = require("config.theme").get()
      local function section(bg)
        return {
          a = { bg = bg, fg = palette.base00, gui = "bold" },
          b = { bg = palette.base01, fg = palette.base05 },
          c = { bg = palette.base01, fg = palette.base04 },
        }
      end
      local inactive = { bg = palette.base01, fg = palette.base03 }

      require("lualine").setup({
        options = {
          theme = {
            normal = section(palette.base0D),
            insert = section(palette.base0E),
            visual = section(palette.base0B),
            replace = section(palette.base08),
            command = section(palette.base0C),
            terminal = section(palette.base0C),
            inactive = { a = inactive, b = inactive, c = inactive },
          },
          globalstatus = true,
        },
      })
    end
  },

  -- Treesitter (syntax/indent/highlight)
  { "nvim-treesitter/nvim-treesitter", branch = "master", build = ":TSUpdate",
    config = function()
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.baml = {
        install_info = {
          url = "https://github.com/BoundaryML/baml-treesitter",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "baml",
      }
      vim.filetype.add({
        extension = {
          baml = "baml",
          -- NASM sources (default Vim often tags .asm as generic "asm")
          asm = "nasm",
          nasm = "nasm",
        },
      })

      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "bash", "python", "json", "markdown", "r",
        "rnoweb", "yaml", "ocaml", "ocaml_interface", "jinja", "baml", "c", "cpp",
        "latex", "bibtex", "nasm", "asm" },
        -- VimTeX owns LaTeX syntax; treesitter highlight fights it on .tex buffers
        highlight = {
          enable = true,
          disable = { "latex" },
        },
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
    config = function(_, opts)
      require("which-key").setup(opts)
      -- Without a group name, which-key collapses multi-key prefixes to a
      -- bare "+N keymaps" count instead of showing what they're for.
      require("which-key").add({
        { "<leader>f", group = "Find" },
        { "<leader>l", group = "LaTeX" },
        { "<leader>q", group = "Quit/Session" },
        { "<leader>r", group = "LSP" },
        { "<leader>w", group = "Save" },
      })
    end
  },

  -- Multiple cursors (Ctrl-N to select word & add cursor, then edit all at once)
  { "mg979/vim-visual-multi", branch = "master" },

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

  -- LaTeX: compile, SyncTeX ↔ Zathura, motions, conceals, TOC
  { "lervag/vimtex",
    lazy = false,
    dependencies = { "micangl/cmp-vimtex" },
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_view_forward_search_on_start = false
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = ".texout",
        out_dir = ".",
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }
      -- Quickfix window for latexmk / chktex messages
      vim.g.vimtex_quickfix_mode = 1
      vim.g.vimtex_syntax_enabled = 1
      -- Folding via VimTeX (optional; keep light)
      vim.g.vimtex_fold_enabled = false
    end,
  },

  -- Completion (nvim-cmp)
  { "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "micangl/cmp-vimtex",
      "onsails/lspkind.nvim",
    },
    config = function()
      local ok, cmp = pcall(require, "cmp")
      if not ok then return end
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      local lspkind = require("lspkind")

      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          format = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50, ellipsis_char = "..." }),
        },
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
          { name = "path" },
        },
      })

      -- Richer completions inside .tex buffers (VimTeX + path)
      cmp.setup.filetype({ "tex", "plaintex", "latex" }, {
        sources = {
          { name = "vimtex" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
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
  { "rcarriga/nvim-notify",
    config = function()
      -- nvim-notify's default background_colour = "NotifyBackground" links to
      -- "Normal", which we deliberately leave with no bg (see Normal above,
      -- for terminal transparency) -- so notify can't tell what to blend
      -- against and warns on every startup. Give it an explicit solid color.
      local palette = require("config.theme").get()
      require("notify").setup({ background_colour = palette.base00 })
      vim.notify = require("notify")
    end
  },
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
