# nix-config

One NixOS flake for two machines, with the same user (`agallas`) on both. The repo
lives at `~/nix-config` on both machines and is pushed to
`github.com/yagovazquez/nixos-dotfiles` (public: never commit secrets).

| Host (= hostname) | Hardware | Used for |
|---|---|---|
| `laptop` | Laptop, 1366x768 eDP-1, plus an AOC monitor and Philips TV when docked. Dead battery. | Daily driver; Claude Code usually runs here |
| `pc` | i5-9400F, GTX 1060 6GB (Pascal), 16 GB, 240 GB SSD (system) + 1 TB HDD | Casual gaming, ML over SSH. Not on 24/7 |

Check `hostname` first to know which machine you're on.

## Layout: where a change goes

- `flake.nix`: `mkHost` builds each host from `hosts/<name>/` + `./system` + home-manager (`home/home.nix`). Inputs are nixpkgs `nixos-26.05`, home-manager `release-26.05`, stylix, and `nixpkgs-unstable` (only as `unstablePkgs`, for fast-moving apps such as claude-code and code-cursor).
- `system/`: NixOS modules **shared by both machines** (`default.nix`, `common.nix`, `desktop.nix`, `theme.nix`).
- `home/`: home-manager config **shared by both machines** (`programs/`, `configs/`, `scripts.nix`, `theme.nix`).
- `hosts/laptop/`, `hosts/pc/`: **one machine only**. `default.nix` holds the NixOS side: hardware, hostname, `system.stateVersion`. `home.nix` holds the home-manager side: `home.stateVersion`, monitors, waybar modules. The PC adds `nvidia.nix`, `gaming.nix`, `remote.nix`, `labwc.nix` and `labwc/`.

Rule: if only one machine needs something, it goes in `hosts/<name>/`. Shared files set a default with `lib.mkDefault` and hosts override it. Current examples:
- the keyboard layout: Spanish by default, US on the PC;
- the greeter command;
- waybar `modules-left`/`modules-right`.

Never change a `stateVersion`. `hardware-configuration.nix` files are generated; don't hand-edit them.

## Mechanisms worth knowing

- **Hyprland config** is `home/configs/hypr/hyprland.lua`, a Lua file, with placeholders replaced in `home/configs/hypr/default.nix`:
  - `__ACTIVE_BORDER__` and the other color placeholders come from stylix;
  - `--[[__MONITORS__]]` comes from the per-host option `my.hyprland.monitors`;
  - `__KB_LAYOUT__` comes from `osConfig.services.xserver.xkb.layout`.
- **Live-edited configs** are linked straight to this repo with `mkOutOfStoreSymlink`, so edits apply without a rebuild: nvim, vis, `hyprpaper.conf`, `hosts/pc/labwc/*`. This is why the repo has to be at `~/nix-config`.
- **Theme**: stylix with a base16 scheme. The switch is `variant` in `system/theme.nix`. `flake.nix` disables most of stylix's NixOS targets on purpose.
- **Login**: greetd + tuigreet. On the PC, F3 picks Hyprland or labwc, a light floating session for gaming that exists only on the PC.
- **PC GPU**: Pascal needs `nvidiaPackages.legacy_580` with `open = false`, because the default 595+ driver dropped Pascal. Don't "upgrade" this, and don't switch to `linuxPackages_latest`.
- **PC disks**: `/data` is the HDD's btrfs partition, mounted with `nofail`, for the Steam library and datasets. The other HDD partitions hold a broken, unused Windows. Leave them alone.
- **Networking**: Tailscale runs on both machines. The PC's sshd listens only on `tailscale0` and accepts only keys. `ssh pc` from the laptop works through MagicDNS.

## Applying changes

- On the machine itself, run `update`, an alias for `sudo nixos-rebuild switch --flake path:/home/agallas/nix-config`. It picks the config by hostname.
- From the laptop to the PC, run `deploy-pc [switch|boot|test]`. It refuses to run if the git tree is dirty, then pushes, SSHes to the PC, pulls and rebuilds there, so the PC's packages never land in the laptop's store.
- `sudo` needs a password, so the user runs these themselves. Claude prepares the change and checks that it evaluates.

Verify before handing over:
- `nix eval --raw .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath` evaluates a host without building it.
- To prove a shared or PC change leaves the laptop untouched, compare `nix eval --raw .#nixosConfigurations.laptop.config.system.build.toplevel.outPath` with `readlink /run/current-system`. They match when the laptop is unaffected.
- For a real diff, run `nixos-rebuild build --flake path:.#<host>`, then `nix store diff-closures /run/current-system ./result`. `/result` is gitignored.
- Flakes only see tracked files, so `git add` new files before evaluating.

## Working with the user

- **Ask before changing the other machine.** Check `hostname` to see which machine this session is on. Before any change that would affect the *other* one, say what would change there and wait for a yes. That means:
  - anything in its `hosts/<name>/`;
  - anything in shared `system/` or `home/` that changes its build.

  Changes that touch only the current machine don't need this. If unsure whether a shared edit leaks, evaluate the other host's `drvPath` before and after the edit. If it doesn't change, the other machine is unaffected.
- Claude Code runs in a terminal inside the user's desktop session. **Never plan a reboot or logout mid-task**, because it kills the conversation. Use `switch` or `test` instead. If a reboot is truly needed, put it last and tell the user to resume with `cd ~/nix-config && claude --continue`.
- For commands the user pastes:
  - one command per line, no `\` line continuations;
  - no inline `# comments`, since zsh passes them on as arguments.
- `cat` is aliased to `bat`. Use `command cat` in scripts.
- Commit messages are short. Prefix them `pc:` or `laptop:` when the change touches one host only. Keep unrelated working-tree changes out of commits.
