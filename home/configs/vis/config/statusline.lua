-- Lualine-inspired statusline: whole bar recolors by mode (Tokyo Night moon).

local modes = {
	[vis.modes.NORMAL] = 'NORMAL',
	[vis.modes.OPERATOR_PENDING] = 'OP',
	[vis.modes.VISUAL] = 'VISUAL',
	[vis.modes.VISUAL_LINE] = 'V-LINE',
	[vis.modes.INSERT] = 'INSERT',
	[vis.modes.REPLACE] = 'REPLACE',
}

-- Whole-bar colors (like lualine mode section, applied to the full statusline)
local mode_styles = {
	[vis.modes.NORMAL] = 'fore:#1b1d2b,back:#82aaff,bold',
	[vis.modes.INSERT] = 'fore:#1b1d2b,back:#c3e88d,bold',
	[vis.modes.REPLACE] = 'fore:#1b1d2b,back:#ff757f,bold',
	[vis.modes.VISUAL] = 'fore:#1b1d2b,back:#c099ff,bold',
	[vis.modes.VISUAL_LINE] = 'fore:#1b1d2b,back:#c099ff,bold',
	[vis.modes.OPERATOR_PENDING] = 'fore:#1b1d2b,back:#86e1fc,bold',
}

local unfocused_style = 'fore:#828bb8,back:#1e2030'

local function basename(path)
	if not path then return '[No Name]' end
	return path:match('([^/]+)$') or path
end

local function diagnostic_summary(path)
	local ok, plug = pcall(require, 'plugins/vis-plug')
	if not ok or not plug.plugins or not plug.plugins.lspc then return nil end
	local lspc = plug.plugins.lspc
	if not path or not lspc.open_files then return nil end
	local file = lspc.open_files[path]
	if not file or not file.diagnostics then return nil end

	local counts = { error = 0, warning = 0, information = 0, hint = 0 }
	local severity_name = { 'error', 'warning', 'information', 'hint' }

	for _, diags in pairs(file.diagnostics) do
		for _, d in ipairs(diags) do
			local name = severity_name[d.severity or 1] or 'hint'
			counts[name] = counts[name] + 1
		end
	end

	local parts = {}
	if counts.error > 0 then table.insert(parts, 'E:' .. counts.error) end
	if counts.warning > 0 then table.insert(parts, 'W:' .. counts.warning) end
	if counts.information > 0 then table.insert(parts, 'I:' .. counts.information) end
	if counts.hint > 0 then table.insert(parts, 'H:' .. counts.hint) end
	if #parts == 0 then return nil end
	return table.concat(parts, ' ')
end

local function apply_mode_color(win)
	if vis.win == win then
		local style = mode_styles[vis.mode] or mode_styles[vis.modes.NORMAL]
		win:style_define(win.STYLE_STATUS_FOCUSED, style)
		-- Keep inactive-looking STYLE_STATUS in sync so brief focus blips look right
		win:style_define(win.STYLE_STATUS, style)
	else
		win:style_define(win.STYLE_STATUS, unfocused_style)
		win:style_define(win.STYLE_STATUS_FOCUSED, unfocused_style)
	end
end

vis.events.subscribe(vis.events.WIN_STATUS, function(win)
	apply_mode_color(win)

	local file = win.file
	local sel = win.selection
	local left, right = {}, {}

	if vis.win == win then
		table.insert(left, modes[vis.mode] or '')
	end

	local name = basename(file.name)
	if file.modified then name = name .. '[+]' end
	if vis.recording then name = name .. ' @' end
	table.insert(left, name)

	if win.syntax then
		table.insert(left, win.syntax)
	end

	local diags = diagnostic_summary(file.path)
	if diags then
		table.insert(left, diags)
	end

	local keys = vis.input_queue
	if keys ~= '' then
		table.insert(right, keys)
	elseif vis.count then
		table.insert(right, tostring(vis.count))
	end

	if #win.selections > 1 then
		table.insert(right, sel.number .. '/' .. #win.selections)
	end

	local size = file.size
	local pos = sel.pos or 0
	local pct = (size == 0) and 0 or math.ceil(pos / size * 100)
	table.insert(right, pct .. '%')

	if not win.large then
		table.insert(right, sel.line .. ':' .. sel.col)
		if size > 33554432 or sel.col > 65536 then
			win.large = true
		end
	end

	win:status(
		' ' .. table.concat(left, '  ') .. ' ',
		' ' .. table.concat(right, '  ') .. ' '
	)
end)
