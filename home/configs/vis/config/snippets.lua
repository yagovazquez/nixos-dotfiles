-- Structural snippets (for-loops, main, …).
-- In insert mode: type the trigger, then Tab to expand.
-- Cursor lands on the first `|` marker (removed from the text).
--
-- LSP completions (printf, identifiers, …) stay on Ctrl+Space / Ctrl+n.

local M = {}

-- `|` = final cursor. Use `\t` / `\n` for indent and newlines.
-- Keys are filetype syntax names (`:set syntax`).
M.by_syntax = {
	ansi_c = {
		['for'] = 'for (int i = 0; i < |; i++) {\n\t\n}',
		['fori'] = 'for (int i = 0; i < |; i++) {\n\t\n}',
		['while'] = 'while (|) {\n\t\n}',
		['if'] = 'if (|) {\n\t\n}',
		['ife'] = 'if (|) {\n\t\n} else {\n\t\n}',
		['main'] = 'int main(int argc, char *argv[]) {\n\t|\n\treturn 0;\n}',
		['stdio'] = '#include <stdio.h>\n',
		['stdlib'] = '#include <stdlib.h>\n',
		['pri'] = 'printf("|\\n");',
		['sca'] = 'scanf("|", &);',
	},
	cpp = {
		['for'] = 'for (int i = 0; i < |; i++) {\n\t\n}',
		['while'] = 'while (|) {\n\t\n}',
		['if'] = 'if (|) {\n\t\n}',
		['ife'] = 'if (|) {\n\t\n} else {\n\t\n}',
		['main'] = 'int main(int argc, char *argv[]) {\n\t|\n\treturn 0;\n}',
	},
	python = {
		['for'] = 'for | in :\n\t',
		['while'] = 'while |:\n\t',
		['if'] = 'if |:\n\t',
		['def'] = 'def |():\n\t',
		['main'] = 'def main():\n\t|\n\nif __name__ == "__main__":\n\tmain()\n',
	},
	lua = {
		['for'] = 'for i = 1, | do\n\t\nend',
		['while'] = 'while | do\n\t\nend',
		['if'] = 'if | then\n\t\nend',
		['fn'] = 'local function |()\n\t\nend',
	},
	bash = {
		['for'] = 'for i in |; do\n\t\ndone',
		['if'] = 'if |; then\n\t\nfi',
	},
}

-- Aliases: vis lexer name → table key
M.by_syntax.c = M.by_syntax.ansi_c

local function word_before_cursor(file, pos)
	if not pos or pos == 0 then
		return nil, 0, 0
	end
	local start = pos
	while start > 0 do
		local ch = file:content(start - 1, 1)
		if not ch or not ch:match('[%w_]') then
			break
		end
		start = start - 1
	end
	if start == pos then
		return nil, 0, 0
	end
	return file:content(start, pos - start), start, pos
end

local function snippets_for(win)
	local syntax = win.syntax
	if not syntax then
		return nil
	end
	return M.by_syntax[syntax]
end

local function expand()
	local win = vis.win
	local file = win.file
	local pos = win.selection.pos
	local word, wstart, wfinish = word_before_cursor(file, pos)
	if not word then
		return false
	end

	local list = snippets_for(win)
	local body = list and list[word]
	if not body then
		return false
	end

	file:delete(wstart, wfinish - wstart)
	local cursor_at = body:find('|', 1, true)
	local text = body:gsub('|', '', 1)
	file:insert(wstart, text)
	if cursor_at then
		win.selection.pos = wstart + cursor_at - 1
	else
		win.selection.pos = wstart + #text
	end
	return true
end

vis:map(vis.modes.INSERT, '<Tab>', function()
	if expand() then
		return
	end
	-- no snippet → keep a real tab / indent unit
	local win = vis.win
	local tw = (win.options and win.options.tabwidth) or 4
	if win.options and win.options.expandtab then
		vis:insert(string.rep(' ', tw))
	else
		vis:insert('\t')
	end
end, 'Expand snippet or insert tab')

return M
