require('vis')

-- Default theme sets STYLE_CURSOR_LINE to 'underlined'; override after it loads.
vis.events.subscribe(vis.events.INIT, function()
	vis.lexers.STYLE_CURSOR_LINE = 'back:#3f3f3f'
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	vis:command('set numbers')
	vis:command('set cursorline')
	--vis:command('set shownewlines')
	vis:command('set showtabs')
	vis:command('set tabwidth 4')
	-- filetype WIN_OPEN runs before this handler, so re-apply the line style here
	win:style_define(win.STYLE_CURSOR_LINE, vis.lexers.STYLE_CURSOR_LINE)
end)


--Pluggins
require('plugins.vis-autoclose')

--Modular config
require('config/colorizer')
require('config/lsp')
require('config/statusline')
require('config/keybind')

-- Nix is not in vis's bundled filetypes (lexer lives in lexers/nix.lua)
vis.ftdetect.filetypes.nix = {
	ext = { '%.nix$' },
}
