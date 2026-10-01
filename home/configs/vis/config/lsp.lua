-- Language servers via vis-lspc
-- Docs: https://codeberg.org/muhq/vis-lspc
-- Keys in ls_map are vis *syntax* names (see :set syntax, or filetype plugin).

local M = {}

function M.setup(lspc)
	if not lspc then
		vis:info('vis-lspc not loaded — run :plug-install')
		return
	end

	lspc.autostart = true
	lspc.menu_cmd = 'fzf'
	lspc.highlight_diagnostics = 'line'
	lspc.universal_root_globs = { '.git' }
	lspc.fallback_dirname_as_root = true

	-- Tokyo Night-ish diagnostic highlights
	lspc.diagnostic_styles = {
		error = 'fore:#ff757f,back:#3b4261',
		warning = 'fore:#ffc777,back:#3b4261',
		information = 'fore:#0db9d7,back:#3b4261',
		hint = 'fore:#4fd6be,back:#3b4261',
	}

	local function fmt(tab, spaces)
		return { tabSize = tab or 2, insertSpaces = spaces ~= false }
	end

	-- Python (pyright — already on PATH in this nix config)
	lspc.ls_map.python = {
		name = 'pyright',
		cmd = 'pyright-langserver --stdio',
		roots = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile' },
		formatting_options = fmt(4),
	}

	-- R (needs R + languageserver: install.packages("languageserver"))
	lspc.ls_map.rstats = {
		name = 'r-languageserver',
		cmd = 'R --slave -e "languageserver::run()"',
		roots = { 'DESCRIPTION', '.Rproj' },
		formatting_options = fmt(2),
	}

	-- C / C++
	lspc.ls_map.c = {
		name = 'clangd',
		cmd = 'clangd --background-index --clang-tidy',
		roots = { 'compile_commands.json', 'compile_flags.txt', '.clangd', 'Makefile' },
		formatting_options = fmt(2),
	}
	lspc.ls_map.cpp = lspc.ls_map.c
	lspc.ls_map.ansi_c = lspc.ls_map.c

	-- TeX / LaTeX
	lspc.ls_map.latex = {
		name = 'texlab',
		cmd = 'texlab',
		roots = { '.latexmkrc', 'latexmkrc', 'Tectonic.toml' },
		settings = {
			texlab = {
				build = {
					executable = 'latexmk',
					args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
					onSave = false,
				},
				forwardSearch = {
					executable = 'zathura',
					args = { '--synctex-forward', '%l:1:%f', '%p' },
				},
				chktex = { onOpenAndSave = true, onEdit = false },
			},
		},
		formatting_options = fmt(2),
	}

	-- OCaml (syntax name in vis is "caml")
	lspc.ls_map.caml = {
		name = 'ocamllsp',
		cmd = 'ocamllsp',
		roots = { 'dune-project', 'dune-workspace', '*.opam', 'esy.json' },
		formatting_options = fmt(2),
	}

	-- Nix
	lspc.ls_map.nix = {
		name = 'nixd',
		cmd = 'nixd',
		roots = { 'flake.nix', 'default.nix', 'shell.nix' },
		formatting_options = fmt(2),
	}

	-- Lua
	lspc.ls_map.lua = {
		name = 'lua-language-server',
		cmd = 'lua-language-server',
		settings = {
			Lua = {
				diagnostics = { globals = { 'vis', 'lpeg', 'lexer' } },
				telemetry = { enable = false },
			},
		},
		formatting_options = fmt(2),
	}

	-- Extras already installed in home.nix
	lspc.ls_map.bash = {
		name = 'bash-language-server',
		cmd = 'bash-language-server start',
		formatting_options = fmt(2),
	}

	lspc.ls_map.json = {
		name = 'json-language-server',
		cmd = 'vscode-json-language-server --stdio',
		formatting_options = fmt(2),
	}

	lspc.ls_map.yaml = {
		name = 'yaml-language-server',
		cmd = 'yaml-language-server --stdio',
		formatting_options = fmt(2),
	}

	lspc.ls_map.html = {
		name = 'html-language-server',
		cmd = 'vscode-html-language-server --stdio',
		formatting_options = fmt(2),
	}

	lspc.ls_map.css = {
		name = 'css-language-server',
		cmd = 'vscode-css-language-server --stdio',
		formatting_options = fmt(2),
	}
end

return M
