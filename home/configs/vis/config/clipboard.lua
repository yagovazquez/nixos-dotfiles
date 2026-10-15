-- OS clipboard via wl-paste / wl-copy.
-- Avoids vis-clipboard's `wl-paste -t text`, which often fails on browser MIME types.

local function wl_paste()
	local _, out = vis:pipe('', 'wl-paste --no-newline 2>/dev/null')
	if not out or out == '' then
		_, out = vis:pipe('', 'wl-paste --no-newline --primary 2>/dev/null')
	end
	if not out or out == '' then
		vis:info('clipboard empty')
		return nil
	end
	return out
end

local function wl_copy(text)
	if not text or text == '' then return end
	vis:pipe(text, 'wl-copy >/dev/null 2>&1')
end

local function paste()
	local out = wl_paste()
	if not out then return end
	local prev = vis.mode
	if prev == vis.modes.NORMAL or prev == vis.modes.VISUAL or prev == vis.modes.VISUAL_LINE then
		vis.mode = vis.modes.INSERT
		vis:insert(out)
		vis.mode = vis.modes.NORMAL
	else
		vis:insert(out)
	end
end

local function yank_visual()
	local win = vis.win
	local range = win.selection.range
	if not range or range.finish <= range.start then
		vis:info('no selection')
		return
	end
	wl_copy(win.file:content(range.start, range.finish - range.start))
	vis:info('yanked to clipboard')
end

vis.events.subscribe(vis.events.INIT, function()
	vis:map(vis.modes.NORMAL, '<C-v>', paste, 'Paste clipboard')
	vis:map(vis.modes.NORMAL, 'gp', paste, 'Paste clipboard')
	vis:map(vis.modes.INSERT, '<C-v>', paste, 'Paste clipboard')
	vis:map(vis.modes.INSERT, '<C-S-v>', paste, 'Paste clipboard')
	vis:map(vis.modes.REPLACE, '<C-v>', paste, 'Paste clipboard')
	vis:map(vis.modes.VISUAL, '<C-v>', paste, 'Paste clipboard')
	vis:map(vis.modes.VISUAL_LINE, '<C-v>', paste, 'Paste clipboard')

	vis:map(vis.modes.VISUAL, '<C-c>', yank_visual, 'Yank to clipboard')
	vis:map(vis.modes.VISUAL_LINE, '<C-c>', yank_visual, 'Yank to clipboard')
	vis:map(vis.modes.VISUAL, 'gy', yank_visual, 'Yank to clipboard')
	vis:map(vis.modes.VISUAL_LINE, 'gy', yank_visual, 'Yank to clipboard')
end)
