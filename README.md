# dotfiles

Personal development environment for macOS and Linux, built around a
terminal-centric workflow: **WezTerm + tmux + Neovim + zsh**.

The repo has two responsibilities, split into two entry-point scripts:

- `install` installs the software (Homebrew, tmux, Neovim, etc.).
- `dev-env` deploys the config files from this repo into `$HOME`.

## Layout

```
install            # installs tools by running everything in installs/
dev-env            # copies config files from this repo into $HOME
installs/          # one script per tool (OS-aware: brew on macOS, apt on Linux)
.config/
  nvim/            # Neovim config (lazy.nvim); see .config/nvim/README.md
  wezterm/         # WezTerm terminal config
.local/scripts/    # helper scripts added to PATH (tmux-sessionizer, gs, ...)
.zshrc             # shell config
.tmux.conf         # tmux config
.ideavimrc         # IdeaVim (Vim emulation in IntelliJ)
```

## Install

`./install` runs every executable in `installs/`. Each script is OS-aware and
branches on `uname` (Homebrew/cask on macOS, `apt` on Linux).

```sh
./install              # run everything
./install neovim       # run only scripts whose name matches "neovim"
./install --dry        # print what would run without doing it
```

Covered tools: Homebrew, fzf, tmux, WezTerm, nvm + node, ripgrep, the zsh
plugins (powerlevel10k, zsh-autosuggestions, zsh-syntax-highlighting), and
Neovim built from source at a pinned version (`v0.11.0`, override with
`NVIM_VERSION`).

## Deploy config (dev-env)

`./dev-env` copies configs from this repo into `$HOME`. It reads the repo
location from `$DEV_ENV_HOME` (set in `.zshrc` to `~/personal/dotfiles`).

```sh
./dev-env              # deploy all config files
./dev-env --dry        # print what would be copied without doing it
```

It **copies** files (it does not symlink), removing the target first and then
copying fresh. What it deploys:

- `.config/nvim` and `.config/wezterm` into `~/.config`
- `.local/scripts` into `~/.local`
- `.tmux.conf`, `.zshrc`, `.ideavimrc` into `~`

Because it copies rather than symlinks, edit the files **in this repo** and
re-run `dev-env` to sync changes. The convenience wrapper `~/.local/scripts/dev-env`
runs it from anywhere and refreshes the shell's command cache.

## Shell (`.zshrc`)

- Powerlevel10k prompt (with instant prompt), zsh-autosuggestions, and
  zsh-syntax-highlighting.
- fzf key bindings and completion.
- nvm for node version management.
- Java toolchain switching: `java21` / `java17` aliases flip `JAVA_HOME`
  between versions resolved via `/usr/libexec/java_home`.
- Sources `~/.zshrc.work` for machine/work-specific config that is **not**
  tracked in this repo.
- `Ctrl-f` launches the tmux sessionizer (see below); `v` / `vim` alias to
  `nvim`.

## tmux (`.tmux.conf`)

- Prefix remapped to `C-a`.
- vi-style copy mode (`v` to select, `y` to copy); mouse enabled.
- Vim-style split and resize bindings; splits open in the current pane's path.
- Windows and panes are 1-indexed and renumber on close.
- Plugins via TPM: `vim-tmux-navigator` (seamless `Ctrl-hjkl` between tmux
  panes and Neovim) and `minimal-tmux-status` (status bar).

## Neovim (`.config/nvim`)

lazy.nvim-managed config with the lockfile committed. Core settings live under
`lua/bradleytaylor/` (keymaps, options, autocmds, diagnostics) and plugins are
one file each under `lua/plugins/` (LSP, Telescope, Treesitter, completion,
conform, harpoon, oil, git, dadbod, lualine, mini, and more). Space is the
leader key. See `.config/nvim/README.md` for details.

## WezTerm (`.config/wezterm`)

tokyonight color scheme, font size 18, tab bar disabled, blinking-block cursor,
and a `home` default workspace. `keymaps.lua` defines LEADER-based bindings
(tab activation `1`-`8`, debug overlay).

## IntelliJ (`.ideavimrc`)

Vim emulation inside IntelliJ that mirrors the Neovim ergonomics: space leader,
relative numbers, `surround`, `NERDTree` toggle on `<leader>e`, and `Alt-hjkl`
pane navigation.

## Helper scripts (`.local/scripts`)

Added to `PATH` via `.zshrc`.

- `tmux-sessionizer` - fzf project switcher (see next section).
- `gs` - fzf-driven `git switch` (handles remote branches).
- `idea` - launch IntelliJ IDEA Ultimate from the CLI.
- `ready-tmux` - hydrate a new tmux session (opens Neovim + a scratch window).
- `tmux-startup` - attach to tmux, or create a `home` session.
- `dev-env` - wrapper that runs the repo's `dev-env` from anywhere.

## tmux sessionizer

`tmux-sessionizer` is a project switcher: it fuzzy-finds a project directory,
then creates or switches to a tmux session named after it (dots in the name
become underscores). New sessions are hydrated via `ready-tmux`. It is bound to
`Ctrl-f` in `.zshrc` and to `prefix + f` in `.tmux.conf`.

Usage:

```sh
tmux-sessionizer                 # fuzzy-pick a project directory
tmux-sessionizer ~/some/project  # jump straight to a specific directory
```

### Search roots

The directories offered in the picker come from two places:

1. **Built-in defaults** (in the script), searched on every machine:
   - `~/personal`
   - `~/personal/dotfiles/.config`
2. **Per-machine config file** at `~/.config/tmux-sessionizer/paths`, whose
   entries are **added on top of** the defaults. This file lives outside the
   repo, so it is per-machine and survives `dev-env` redeploys. Work
   directories that should not appear on other machines belong here.

Each root is scanned one level deep (`find -mindepth 1 -maxdepth 1 -type d`) for
its immediate subdirectories. Roots that do not exist are skipped, and
duplicates across defaults and the config file are removed.

Config file format: one directory per line, `#` comments and blank lines
allowed, and a leading `~` is expanded to `$HOME`.

```
# ~/.config/tmux-sessionizer/paths
~/work
~/work/repos
```
