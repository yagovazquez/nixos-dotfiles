-- External plugins via vis-plug (installed under ~/.cache/vis-plug).
-- Local plugins stay in ./plugins and are required from visrc.lua.

local function bootstrap_vis_plug()
	local ok, plug = pcall(require, 'plugins/vis-plug')
	if ok then
		return plug
	end

	local conf = (os.getenv('XDG_CONFIG_HOME') or (os.getenv('HOME') .. '/.config'))
		.. '/vis/plugins/vis-plug'
	os.execute('git clone --quiet https://github.com/erf/vis-plug ' .. conf)
	return require('plugins/vis-plug')
end

local plug = bootstrap_vis_plug()

plug.init({
	-- LSP client (completions, goto-def, hover, diagnostics, …)
	{ url = 'https://codeberg.org/muhq/vis-lspc', alias = 'lspc' },
}, true)

return plug
