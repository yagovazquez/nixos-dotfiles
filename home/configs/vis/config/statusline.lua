-- Mode-colored statusline + / search match index (current/total).

local mode_styles = {
	[vis.modes.NORMAL] = 'fore:#1b1d2b,back:#82aaff,bold',
	[vis.modes.INSERT] = 'fore:#1b1d2b,back:#c099ff,bold',
	[vis.modes.REPLACE] = 'fore:#1b1d2b,back:#ff757f,bold',
	[vis.modes.VISUAL] = 'fore:#1b1d2b,back:#c3e88d,bold',
	[vis.modes.VISUAL_LINE] = 'fore:#1b1d2b,back:#c3e88d,bold',
	[vis.modes.OPERATOR_PENDING] = 'fore:#1b1d2b,back:#86e1fc,bold',
}

local mode_labels = {
	[vis.modes.NORMAL] = 'NORMAL',
	[vis.modes.OPERATOR_PENDING] = '',
	[vis.modes.VISUAL] = 'VISUAL',
	[vis.modes.VISUAL_LINE] = 'VISUAL-LINE',
	[vis.modes.INSERT] = 'INSERT',
	[vis.modes.REPLACE] = 'REPLACE',
}

local unfocused_style = 'fore:#828bb8,back:#1e2030'

-- Cache match positions: invalidated when pattern/file changes
local cache = {
	key = nil,
	starts = {}, -- 0-based byte offsets
}

local function search_pattern()
	local reg = vis.registers['/']
	if not reg then return nil end
	local pat = reg[1]
	if type(pat) ~= 'string' then return nil end
	-- register_put0 stores strlen+1, so Lua strings include a trailing '\0'
	pat = pat:gsub('%z', '')
	if pat == '' then return nil end
	return pat
end

local function shell_quote(s)
	return "'" .. s:gsub("'", "'\\''") .. "'"
end

local function looks_like_regex(pattern)
	return pattern:find('[\\.*+?^$()%[%]|{}]') ~= nil
end

local function collect_matches(file, content, pattern)
	local starts = {}

	if looks_like_regex(pattern) then
		-- Approximate vis regex with grep -E; byte offsets via -b -o
		local cmd = 'grep -bo -E ' .. shell_quote(pattern) .. ' || true'
		local _, out = vis:pipe(file, { start = 0, finish = file.size }, cmd)
		if out and out ~= '' then
			for offset in out:gmatch('(%d+):') do
				starts[#starts + 1] = tonumber(offset)
			end
		end
		return starts
	end

	-- Literal count (covers /word, *, #)
	local pos = 1
	while true do
		local s = content:find(pattern, pos, true)
		if not s then break end
		starts[#starts + 1] = s - 1
		pos = s + 1
	end
	return starts
end

local function match_info(win)
	local pattern = search_pattern()
	if not pattern then return nil end

	local file = win.file
	-- Skip huge files to keep the statusline snappy
	if file.size > 2 * 1024 * 1024 then return nil end

	local key = string.format('%s\0%d\0%s\0%s',
		file.path or file.name or '',
		file.size,
		tostring(file.modified),
		pattern)

	if cache.key ~= key then
		local content = file:content(0, file.size)
		cache.key = key
		cache.starts = collect_matches(file, content, pattern)
	end

	local total = #cache.starts
	if total == 0 then return nil end

	local cursor = win.selection.pos or 0
	local current = 0
	for i, start in ipairs(cache.starts) do
		if start <= cursor then
			current = i
		else
			break
		end
	end
	if current == 0 then current = 1 end

	return string.format('%d/%d', current, total)
end

local function paint_status(win, style)
	win:style_define(win.STYLE_STATUS_FOCUSED, style)
	win:style_define(win.STYLE_STATUS, style)
	local y = win.height - 1
	local id = win.STYLE_STATUS_FOCUSED
	for x = 0, win.width - 1 do
		win:style_pos(id, x, y)
	end
end

vis.events.subscribe(vis.events.WIN_STATUS, function(win)
	local focused = (win == vis.win)
	local style = focused
		and (mode_styles[vis.mode] or mode_styles[vis.modes.NORMAL])
		or unfocused_style
	paint_status(win, style)

	local file = win.file
	local sel = win.selection
	local left, right = {}, {}

	if focused then
		local label = mode_labels[vis.mode]
		if label and label ~= '' then
			table.insert(left, label)
		end
	end

	table.insert(left, (file.name or '[No Name]')
		.. (file.modified and ' [+]' or '')
		.. (vis.recording and ' @' or ''))

	local keys = vis.input_queue
	if keys ~= '' then
		table.insert(right, keys)
	elseif vis.count then
		table.insert(right, tostring(vis.count))
	end

	if focused then
		local info = match_info(win)
		if info then
			table.insert(right, info)
		end
	end

	if #win.selections > 1 then
		table.insert(right, sel.number .. '/' .. #win.selections)
	end

	local size = file.size
	local pos = sel.pos or 0
	table.insert(right, (size == 0 and '0' or math.ceil(pos / size * 100)) .. '%')

	if not win.large then
		table.insert(right, sel.line .. ', ' .. sel.col)
		if size > 33554432 or sel.col > 65536 then
			win.large = true
		end
	end

	win:status(
		' ' .. table.concat(left, ' » ') .. ' ',
		' ' .. table.concat(right, ' « ') .. ' '
	)
end)
