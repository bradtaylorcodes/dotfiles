# dotfiles

Personal development environment for macOS and Fedora, built around a
terminal-centric workflow: **WezTerm + Neovim + zsh**.

Config is deployed with [GNU Stow](https://www.gnu.org/software/stow/): each
top-level directory is a Stow "package" that mirrors the `$HOME` layout it
targets, and `stow` symlinks it into place.

## Layout

```
zsh/.zshrc                     # shell config
nvim/.config/nvim/             # Neovim config (lazy.nvim); see nvim/.config/nvim/README.md
wezterm/.config/wezterm/       # WezTerm terminal config
starship/.config/starship.toml # prompt config
herdr/.config/herdr/           # herdr terminal workspace manager config
claude/.claude/                # Claude Code CLAUDE.md and status line script
scripts/.local/scripts/        # helper scripts added to PATH (gs, herdr-sessionizer)
```

## Deploy config (Stow)

Install Stow first: `brew install stow` (macOS) or `sudo dnf install stow`
(Fedora).

### First-time setup

```sh
mkdir -p ~/personal
git clone https://github.com/bradtaylorcodes/dotfiles.git ~/personal/dotfiles
cd ~/personal/dotfiles

stow -t ~ zsh nvim starship scripts herdr claude    # core packages
stow -t ~ wezterm                                   # skip on a headless box

exec zsh
```

`stow -t ~ <package...>` symlinks each package's files into `$HOME`. Packages
are opt-in per machine — e.g. skip `wezterm` on a headless Fedora box.

To remove a package's symlinks: `stow -D -t ~ <package>`. To re-link after
moving files within a package: `stow -R -t ~ <package>`.

Package installation (Homebrew, WezTerm, Neovim, etc.) is currently manual.

### herdr

The herdr config uses tmux-style keys (`ctrl+a` prefix, `|`/`-` splits,
`hjkl` resize, `f` for the `herdr-sessionizer` project picker, `L` to toggle to
the previous workspace). One-time setup
per machine, after Neovim has installed its plugins:

```sh
brew install jq fzf    # jq is needed by smart-splits' herdr script
herdr plugin link ~/.local/share/nvim/lazy/smart-splits.nvim
herdr plugin link ~/.config/herdr/plugins/last-workspace
```

The smart-splits link makes `ctrl+h/j/k/l` move between herdr panes and Neovim
splits. The `last-workspace` plugin (in this repo) remembers workspace focus so
`prefix+L` can switch back to the previous workspace.

#### Sessionizer search paths

`prefix+f` runs `herdr-sessionizer`, which lists the immediate subdirectories
of each search root in fzf (the roots themselves aren't listed). Picking one
focuses the workspace with that directory's name, or creates it.

`~/personal` is always searched. To add roots on every machine, add them to
`default_paths` in `scripts/.local/scripts/herdr-sessionizer`:

```bash
default_paths=(
  "$HOME/personal"
  "$HOME/work"
)
```

To add roots on one machine only, list them in
`~/.config/herdr-sessionizer/paths`. That file isn't in this repo, so it stays
local to the machine:

```sh
mkdir -p ~/.config/herdr-sessionizer
cat >> ~/.config/herdr-sessionizer/paths <<'EOF'
# one directory per line
~/work
/opt/projects
EOF
```

In that file, `#` starts a comment, blank lines are ignored and a leading `~`
expands to your home directory (other variables such as `$HOME` don't).
Roots from the file add to `default_paths` rather than replacing them, and
directories that don't exist or are listed twice are skipped.

### Claude Code status line

`claude/.claude/statusline-command.sh` shows model, effort, directory, git
branch and context usage on one line (needs `jq`). Only the script is stowed,
since Claude Code rewrites `~/.claude/settings.json` itself; add this to that
file once per machine:

```json
"statusLine": {
  "type": "command",
  "command": "bash ~/.claude/statusline-command.sh"
}
```
