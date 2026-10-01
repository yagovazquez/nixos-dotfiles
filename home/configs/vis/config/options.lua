-- Minimal editor options (grow this as you learn vis)

vis.events.subscribe(vis.events.INIT, function()
	vis:command('set theme tokyonight')
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	vis:command('set number')
	vis:command('set autoindent on')
	vis:command('set expandtab on')
	vis:command('set tabwidth 2')
end)

-- Nix is not in vis's bundled filetypes; register it (lexer: lexers/nix.lua)
vis.ftdetect.filetypes.nix = {
	ext = { '%.nix$' },
}
