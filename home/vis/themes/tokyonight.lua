-- Tokyo Night (moon) for vis — adapted from folke/tokyonight.nvim
-- Status styles mimic lualine's tokyonight theme (single bar colors; vis has no segments).

local lexers = vis.lexers

local colors = {
	bg          = '#222436',
	bg_dark     = '#1e2030',
	bg_highlight = '#2f334d',
	bg_visual   = '#2d3f76',
	fg          = '#c8d3f5',
	fg_dark     = '#828bb8',
	fg_gutter   = '#3b4261',
	comment     = '#636da6',
	black       = '#1b1d2b',
	blue        = '#82aaff',
	blue0       = '#3e68d7',
	cyan        = '#86e1fc',
	green       = '#c3e88d',
	magenta     = '#c099ff',
	purple      = '#fca7ea',
	orange      = '#ff966c',
	red         = '#ff757f',
	yellow      = '#ffc777',
	teal        = '#4fd6be',
	terminal_black = '#444a73',
}

lexers.colors = colors

local fg = ',fore:' .. colors.fg .. ','
local bg = ',back:' .. colors.bg .. ','

lexers.STYLE_DEFAULT = bg .. fg
lexers.STYLE_NOTHING = bg
lexers.STYLE_CLASS = 'fore:' .. colors.yellow
lexers.STYLE_COMMENT = 'fore:' .. colors.comment .. ',italics'
lexers.STYLE_CONSTANT = 'fore:' .. colors.orange
lexers.STYLE_DEFINITION = 'fore:' .. colors.blue
lexers.STYLE_ERROR = 'fore:' .. colors.red .. ',italics'
lexers.STYLE_FUNCTION = 'fore:' .. colors.blue
lexers.STYLE_KEYWORD = 'fore:' .. colors.magenta .. ',bold'
lexers.STYLE_LABEL = 'fore:' .. colors.blue
lexers.STYLE_NUMBER = 'fore:' .. colors.orange
lexers.STYLE_OPERATOR = 'fore:' .. colors.cyan
lexers.STYLE_REGEX = 'fore:' .. colors.teal
lexers.STYLE_STRING = 'fore:' .. colors.green
lexers.STYLE_PREPROCESSOR = 'fore:' .. colors.cyan
lexers.STYLE_TAG = 'fore:' .. colors.red
lexers.STYLE_TYPE = 'fore:' .. colors.cyan
lexers.STYLE_VARIABLE = 'fore:' .. colors.fg
lexers.STYLE_WHITESPACE = ''
lexers.STYLE_EMBEDDED = 'back:' .. colors.bg_highlight
lexers.STYLE_IDENTIFIER = fg

lexers.STYLE_LINENUMBER = 'fore:' .. colors.fg_gutter
lexers.STYLE_LINENUMBER_CURSOR = 'fore:' .. colors.fg_dark
lexers.STYLE_CURSOR = 'fore:' .. colors.bg .. ',back:' .. colors.fg
lexers.STYLE_CURSOR_PRIMARY = 'fore:' .. colors.bg .. ',back:' .. colors.blue
lexers.STYLE_CURSOR_LINE = 'back:' .. colors.bg_highlight
lexers.STYLE_COLOR_COLUMN = 'back:' .. colors.bg_highlight
lexers.STYLE_SELECTION = 'back:' .. colors.bg_visual
lexers.STYLE_STATUS = 'back:' .. colors.bg_dark .. ',fore:' .. colors.fg_dark
lexers.STYLE_STATUS_FOCUSED = 'back:' .. colors.bg_dark .. ',fore:' .. colors.fg
lexers.STYLE_SEPARATOR = lexers.STYLE_DEFAULT
lexers.STYLE_INFO = 'fore:' .. colors.blue .. ',bold'
lexers.STYLE_EOF = 'fore:' .. colors.fg_gutter
