-- Smarter newlines for C-like *blocks* only (`{}`).
-- Parentheses / brackets keep the same indent (no extra tab after `()`).
-- Complements :set autoindent (config/options.lua) and vis-autoclose.

local function leading_ws(line)
	return (line or ''):match('^[\t ]*') or ''
end

local function indent_unit(win)
	local tw = (win.options and win.options.tabwidth) or 4
	if win.options and win.options.expandtab then
		return string.rep(' ', tw)
	end
	return '\t'
end

local function insert_at_cursor(text, cursor_bytes)
	local win = vis.win
	local pos = win.selection.pos
	if not pos then
		return
	end
	win.file:insert(pos, text)
	win.selection.pos = pos + cursor_bytes
end

local function smart_newline()
	local win = vis.win
	local file = win.file
	local pos = win.selection.pos
	if not pos then
		return
	end

	local line = file.lines[win.selection.line] or ''
	local base = leading_ws(line)
	local deeper = base .. indent_unit(win)

	local before = (pos > 0) and file:content(pos - 1, 1) or ''
	local after = file:content(pos, 1) or ''

	-- {|} → split the pair and indent the middle line
	if before == '{' and after == '}' then
		local text = '\n' .. deeper .. '\n' .. base
		insert_at_cursor(text, 1 + #deeper)
		return
	end

	-- line ends with `{` (cursor right after it) → one level deeper
	local col = win.selection.col or 1
	local before_cursor = line:sub(1, col - 1)
	if before == '{' or before_cursor:match('{%s*$') then
		insert_at_cursor('\n' .. deeper, 1 + #deeper)
		return
	end

	-- everything else (including `()` / `[]`): same indent as current line
	insert_at_cursor('\n' .. base, 1 + #base)
end

vis:map(vis.modes.INSERT, '<Enter>', function()
	smart_newline()
end, 'Newline; deepen indent only inside braces')
