-- Highlight color literals in the viewport (#RGB, #RRGGBB, rgb()/rgba()).
-- Inspired by thimc/vis-colorizer and nvim-highlight-colors.

local M = {
	hex3 = true,
	hex6 = true,
	rgb = true,
}

local STYLE_MAX = 64
local style_ids = {}

local function reset_ids()
	style_ids = {}
	for i = 1, STYLE_MAX do
		style_ids[i] = i
	end
end
reset_ids()

local function contrast_fg(hex)
	local r = tonumber(hex:sub(1, 2), 16) or 0
	local g = tonumber(hex:sub(3, 4), 16) or 0
	local b = tonumber(hex:sub(5, 6), 16) or 0
	-- luma-ish threshold
	if (r * 30 + g * 59 + b * 11) > 12000 then
		return '#1b1d2b'
	end
	return '#c8d3f5'
end

local function expand3(h)
	return h:sub(1, 1):rep(2) .. h:sub(2, 2):rep(2) .. h:sub(3, 3):rep(2)
end

local function collect(content)
	local matches = {}

	if M.hex3 or M.hex6 then
		local init = 1
		while true do
			local s, e, hex = content:find('#([0-9a-fA-F]+)', init)
			if not s then break end
			local len = #hex
			if (len == 3 and M.hex3) or (len == 6 and M.hex6) then
				if len == 3 then hex = expand3(hex) end
				table.insert(matches, { start = s, finish = e, hex = hex:lower() })
			end
			init = e + 1
		end
	end

	if M.rgb then
		local init = 1
		while true do
			local s, e, r, g, b = content:find(
				'[Rr][Gg][Bb][Aa]?%(%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)',
				init
			)
			if not s then break end
			-- include closing paren if present
			local close = content:find('%)', e) or e
			r, g, b = tonumber(r), tonumber(g), tonumber(b)
			if r and g and b and r <= 255 and g <= 255 and b <= 255 then
				table.insert(matches, {
					start = s,
					finish = close,
					hex = string.format('%02x%02x%02x', r, g, b),
				})
			end
			init = e + 1
		end
	end

	return matches
end

local function paint(win, matches)
	local offset = win.viewport.bytes.start
	local finish_view = win.viewport.bytes.finish

	for _, m in ipairs(matches) do
		local id = table.remove(style_ids)
		if not id then break end

		local style = 'fore:' .. contrast_fg(m.hex) .. ',back:#' .. m.hex
		if win:style_define(id, style) then
			win:style(id, m.start - 1 + offset, m.finish - 1 + offset)
		end
		table.insert(style_ids, id)

		if m.finish >= finish_view then
			break
		end
	end
end

vis.events.subscribe(vis.events.WIN_HIGHLIGHT, function(win)
	if not win.viewport or not win.viewport.bytes then return end
	local content = win.file:content(win.viewport.bytes)
	paint(win, collect(content))
end)

return M
