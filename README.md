# Dotfiles

Personal Linux desktop config, based on [JaKooLit's Hyprland-Dots](https://github.com/JaKooLit).

This repo tracks a curated subset of `~/.config` — see `.gitignore` for the
full allowlist of managed directories. Everything else living in `~/.config`
(browser profiles, editor caches, container state, etc.) is intentionally
untracked.

## Managed via Makefile

| Tool | Directory |
|------|-----------|
| Ghostty (terminal) | `ghostty/` |
| tmux | `tmux/` |
| Neovim | `nvim/` |
| Hyprland | `hypr/` |

```
make all        # link all managed tool configs into ~/.config
make ghostty     # link a single tool: ghostty | tmux | nvim | hypr
make status      # show link status for managed tools
```

`make` is idempotent and non-destructive: if `~/.config/<tool>` already
exists as a real file/directory, it's moved aside to
`~/.config/<tool>.bak-<timestamp>` before the symlink is created. If this
repo is already checked out directly at `~/.config` (as on the machine it
was authored on), each tool is its own source — `make` detects this and
leaves it alone.

Other tracked directories (`waybar/`, `starship/`, `shellrc/`, `scripts/`)
aren't wired into the Makefile yet; add a target following the existing
pattern in `Makefile` when ready.

## Setup on a new machine

1. Install the tools you want (see per-tool notes below).
2. Clone this repo — either directly as `~/.config` on a fresh machine with
   nothing there yet, or elsewhere (e.g. `~/dotfiles`) if `~/.config`
   already has content you want to keep.
3. From the repo root, run `make all` (safe to skip if you cloned directly
   as `~/.config`).

### Prerequisites

- **Ghostty**: install the [Ghostty](https://ghostty.org) terminal emulator.
- **tmux**: install `tmux`, then install
  [TPM](https://github.com/tmux-plugins/tpm) (the plugin manager) and press
  `prefix + I` inside a tmux session to fetch the plugins listed in
  `tmux/tmux.conf`. TPM installs into `tmux/plugins/`, which is gitignored.
- **Neovim**: install a recent Neovim; plugins are managed by
  [lazy.nvim](https://github.com/folke/lazy.nvim) and will bootstrap
  themselves on first launch from `nvim/lazy-lock.json`.
- **Hyprland**: install Hyprland and the JaKooLit dependency stack (see
  `hypr/initial-boot.sh`); this repo does not automate that install.

## Architecture

See `CLAUDE.md` (local-only, not tracked in this repo) for a full breakdown
of the Hyprland, Wallust theming, Waybar, and Rofi configuration structure.
