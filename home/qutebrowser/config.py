# ignore the configurations impose from inside qutebrowser
config.load_autoconfig(False)

# Force dark interface colors
c.colors.webpage.darkmode.enabled = True

# Open this page on new tabs
c.url.default_page = "file:///home/agallas/nix-config/home/firefox/startpage/index.html"
c.url.start_pages = ["file:///home/agallas/nix-config/home/firefox/startpage/index.html"]


c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "g": "https://www.google.com/search?q={}",
    "ddg": "https://duckduckgo.com/?q={}",
    "gh": "https://github.com/search?q={}",
    "yt": "https://www.youtube.com/results?search_query={}"
}

# === TokyoNight Moon theme for qutebrowser ===

bg = "#222436"
bg_alt = "#2f334d"
fg = "#c8d3f5"
blue = "#82aaff"
cyan = "#86e1fc"
magenta = "#c099ff"
yellow = "#ffc777"
red = "#ff757f"
comment = "#444a73"

# Completion menu
c.colors.completion.fg = fg
c.colors.completion.odd.bg = bg
c.colors.completion.even.bg = bg_alt
c.colors.completion.category.bg = bg_alt
c.colors.completion.category.fg = blue
c.colors.completion.item.selected.bg = blue
c.colors.completion.item.selected.fg = bg
c.colors.completion.item.selected.border.top = blue
c.colors.completion.item.selected.border.bottom = blue
c.colors.completion.match.fg = yellow

# Statusbar
c.colors.statusbar.normal.bg = bg
c.colors.statusbar.normal.fg = fg
c.colors.statusbar.insert.bg = cyan
c.colors.statusbar.insert.fg = bg
c.colors.statusbar.command.bg = bg_alt
c.colors.statusbar.command.fg = fg
c.colors.statusbar.url.success.https.fg = blue
c.colors.statusbar.url.error.fg = red
c.colors.statusbar.url.hover.fg = cyan
c.colors.statusbar.url.warn.fg = yellow

# Tabs
c.colors.tabs.bar.bg = bg
c.colors.tabs.odd.bg = bg
c.colors.tabs.even.bg = bg_alt
c.colors.tabs.selected.odd.bg = blue
c.colors.tabs.selected.even.bg = blue
c.colors.tabs.selected.odd.fg = bg
c.colors.tabs.selected.even.fg = bg

# Downloads
c.colors.downloads.bar.bg = bg
c.colors.downloads.start.bg = blue
c.colors.downloads.stop.bg = cyan
c.colors.downloads.error.bg = red

# Hints
c.colors.hints.bg = yellow
c.colors.hints.fg = bg
c.colors.hints.match.fg = red

# Messages
c.colors.messages.error.bg = red
c.colors.messages.error.fg = bg
c.colors.messages.info.bg = bg_alt
c.colors.messages.info.fg = fg
c.colors.messages.warning.bg = yellow
c.colors.messages.warning.fg = bg

# Prompts
c.colors.prompts.bg = bg_alt
c.colors.prompts.fg = fg
c.colors.prompts.selected.bg = blue

# Webpage background
c.colors.webpage.bg = bg

