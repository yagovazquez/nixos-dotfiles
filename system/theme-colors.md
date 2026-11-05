# What each color in `theme.nix` controls

`system/theme.nix` defines one base16 palette (`vanilla`) plus an optional
`personalOverride` for a couple of slots. Everything below comes from
reading the actual stylix target source for every target enabled in
`home/theme.nix` (`stylix.targets.*.enable = true`), so it reflects what's
really wired up in this config, not the generic base16 convention.

Hex values shown are the current `vanilla` scheme; where `personalOverride`
changes a slot, the override value is shown too (`variant = "personal"` is
what's active right now).

| slot | hex (vanilla) | hex (personal) | role | used by |
|------|---------------|-----------------|------|---------|
| base00 | `#222436` | — | background | qutebrowser (page/UI bg), rofi (bg), zathura (page/inputbar/notification bg), ghostty (bg, ANSI black), mako (bg), tty console (ANSI black), hyprland (shadow color) |
| base01 | `#2f334d` | — | secondary surface | qutebrowser (alternating completion/tab rows, disabled context-menu bg), zathura (**default text fg**, completion-list bg) |
| base02 | `#2d3f76` | — | subtle highlight | ghostty (text-selection bg), zathura (statusbar bg), mako (progress-bar track) |
| base03 | `#636da6` | `#a3b0e0` | dim text / selection accent | **nvim** (comment color, via `NIX_THEME_BASE03`), qutebrowser (the generic "selected" bg across completion items, context menu, hints, statusbar caret-selection, prompts, pinned tabs — *tabs.selected itself is force-overridden to base0D, see qutebrowser.nix*), ghostty (ANSI bright-black), hyprland (inactive window border) |
| base04 | `#828bb8` | `#97a4d4` | dim fg #2 | **nvim** (`fg_dark`, via `NIX_THEME_BASE04`), zathura (statusbar fg) |
| base05 | `#c8d3f5` | — | main foreground | qutebrowser (most text), rofi (main text), ghostty (fg, cursor color, selection fg, ANSI white), mako (text), tty console (ANSI white) |
| base06 | `#c8d3f5` | — | light fg | rofi (**background** of a plain selected/hovered list item — not urgent/active), zathura (recolor "dark" replacement color for PDF recoloring) |
| base07 | `#d5dbf7` | — | lightest fg | zathura (inputbar fg, normal notification fg, completion-highlight fg), ghostty + tty console (ANSI bright white) |
| base08 | `#ff757f` | — | red / error / urgent | qutebrowser (errors, tab-load-error indicator), rofi (urgent window/workspace), zathura (error **and** warning notification fg — stylix's zathura target reuses red for warnings too), ghostty + console (ANSI red), mako (critical-urgency border) |
| base09 | `#ff966c` | — | orange | not used by any currently-enabled target (defined but inert here) |
| base0A | `#ffc777` | — | yellow / search highlight | zathura (search-match highlight), ghostty + console (ANSI yellow) |
| base0B | `#c3e88d` | — | green / "info" | qutebrowser (completion category labels, download-start, info messages, **insert-mode statusbar**, `https://` success indicator, pinned tabs), ghostty + console (ANSI green) |
| base0C | `#86e1fc` | — | cyan / "secondary info" | qutebrowser (download-stop, plain `http://` success indicator), ghostty + console (ANSI cyan) |
| base0D | `#82aaff` | — | **blue / primary accent** | rofi (active/matched item), zathura (active search match, completion accent), mako (default notification border), hyprland (**active window border**), ghostty + console (ANSI blue), qutebrowser **active tab** (forced in `qutebrowser.nix` — stylix's own template doesn't use base0D at all, which is why it looked grey before that fix) |
| base0E | `#c099ff` | — | magenta / warning | qutebrowser (warning messages, `warn` url color), ghostty + console (ANSI magenta) |
| base0F | `#c53b53` | — | rare/special | not used by any currently-enabled target |

## Gotchas when editing colors here

- **nvim mostly ignores this file.** `stylix.targets.neovim.enable = false`
  (see `home/theme.nix`) — nvim keeps its own `tokyonight.nvim` colorscheme.
  The *only* two slots that reach nvim are base03/base04, piped through as
  the `NIX_THEME_BASE03`/`NIX_THEME_BASE04` env vars
  (`home/theme.nix` → `home/configs/nvim/lua/config/plugins.lua`). Changing
  any other slot (base00, base05, base0D, ...) will never affect nvim.
- **Waybar and GTK are fully decoupled.** `stylix.targets.waybar.enable =
  false` and `gtk.enable = false` — waybar's colors live only in
  `home/configs/waybar/style.css`, hand-written.
- **Hyprland isn't a stylix target either.** `hyprland.enable = false`;
  `home/configs/hypr/default.nix` templates just three slots
  (base0D/base03/base00) directly into `hyprland.lua` by string
  replacement, bypassing stylix entirely.
- A color change only takes effect after a rebuild/switch (e.g.
  `nixos-rebuild switch --flake .#nixos`) **and**, for nvim/ghostty/etc.,
  restarting the program so it re-reads its config/env.
- `base05` and `base06` are identical in the vanilla scheme (`#c8d3f5`) —
  rofi's base06 usage (selected-item background) is the one place that
  distinction would actually show up if you ever split them apart.
