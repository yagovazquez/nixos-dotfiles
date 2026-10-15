require('vis')

-- Select multiple words (to change them just press "c")
vis:map(vis.modes.NORMAL, 'gx', function()
	vis:feedkeys(':x//<Left>')
end)

-- LSP completion (fzf). Ctrl+Space is the vis-lspc default; Ctrl+n as a fallback.
local function lsp_complete()
	vis:command('lspc-completion')
	if vis.mode ~= vis.modes.INSERT then
		vis.mode = vis.modes.INSERT
	end
end

vis:map(vis.modes.INSERT, '<C-n>', lsp_complete, 'lspc: completion')
vis:map(vis.modes.NORMAL, '<C-n>', function()
	vis:command('lspc-completion')
end, 'lspc: completion')

