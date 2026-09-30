-- load standard vis module, providing parts of the Lua API
require('vis')

-- Bootstrap vis-plug (plugin manager); plugins install under ~/.cache/vis-plug
local plug = (function()
	if not pcall(require, 'plugins/vis-plug') then
		local conf = (os.getenv('XDG_CONFIG_HOME') or (os.getenv('HOME') .. '/.config')) .. '/vis'
		os.execute('mkdir -p "' .. conf .. '/plugins" && git clone --quiet https://github.com/erf/vis-plug "' .. conf .. '/plugins/vis-plug"')
	end
	return require('plugins/vis-plug')
end)()

plug.init({
	-- https://codeberg.org/muhq/vis-lspc
	{ url = 'https://codeberg.org/muhq/vis-lspc', file = 'init', alias = 'lspc' },
}, true)

-- Modular config (same idea as nvim/lua/config/*)
require('config/options')
require('config/lsp').setup(plug.plugins.lspc)
require('config/colorizer')
require('config/statusline')
require('config/keymaps')
