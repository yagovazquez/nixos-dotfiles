require('vis')

-- Default theme sets STYLE_CURSOR_LINE to 'underlined'; override after it loads.
vis.events.subscribe(vis.events.INIT, function()
	vis.lexers.STYLE_CURSOR_LINE = 'back:#3f3f3f'
end)

-- Modular config (order matters for a few things — see comments)
require('config/options')    -- numbers, tabs, autoindent
require('config/indent')     -- Enter deepens only inside { }
require('config/snippets')   -- Tab expands for/while/main/…
require('config/plugins')    -- vis-plug → vis-lspc
require('config/lsp')        -- language servers + Ctrl+Space completion
require('config/colorizer')
require('config/statusline')
require('config/keybind')

-- Local plugins last so their INPUT maps win over anything else
require('plugins.vis-autoclose')

-- Nix is not in vis's bundled filetypes (lexer lives in lexers/nix.lua)
vis.ftdetect.filetypes.nix = {
	ext = { '%.nix$' },
}
