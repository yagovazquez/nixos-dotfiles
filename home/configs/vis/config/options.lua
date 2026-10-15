-- Per-window editor options.

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	vis:command('set numbers')
	vis:command('set cursorline')
	vis:command('set showtabs')
	vis:command('set tabwidth 4')
	-- Copy previous line's leading whitespace onto new lines
	vis:command('set autoindent')

	-- filetype WIN_OPEN runs before this handler, so re-apply the line style here
	win:style_define(win.STYLE_CURSOR_LINE, vis.lexers.STYLE_CURSOR_LINE)
end)
