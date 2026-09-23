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
ideavim/.ideavimrc             # IdeaVim (Vim emulation in IntelliJ)
scripts/.local/scripts/        # helper scripts added to PATH (gs, idea)
```

## Deploy config (Stow)

Install Stow first: `brew install stow` (macOS) or `sudo dnf install stow`
(Fedora).

### First-time setup

```sh
mkdir -p ~/personal
git clone https://github.com/bradtaylorcodes/dotfiles.git ~/personal/dotfiles
cd ~/personal/dotfiles

# Optional machine/work-specific shell settings are loaded from this file.
touch ~/.zshrc.work

stow -t ~ zsh nvim wezterm starship scripts    # core packages
stow -t ~ ideavim                              # only if IntelliJ is installed
stow -t ~ wezterm                              # skip on a headless box

exec zsh
```

`stow -t ~ <package...>` symlinks each package's files into `$HOME`. Packages
are opt-in per machine — e.g. skip `wezterm`/`ideavim` on a headless Fedora
box. Because targets are symlinks rather than copies, edits made either in
this repo or at the deployed path are the same file; there's nothing to
re-sync.

To remove a package's symlinks: `stow -D -t ~ <package>`. To re-link after
moving files within a package: `stow -R -t ~ <package>`.

Package installation (Homebrew, WezTerm, Neovim, etc.) is currently manual —
the old `install`/`installs/` scripts were removed since they only supported
`apt` and didn't work on Fedora; a replacement isn't in place yet.

## Shell (`.zshrc`)

- [Starship](https://starship.rs) prompt, zsh-autosuggestions, and
  zsh-syntax-highlighting.
- fzf key bindings and completion.
- nvm for node version management.
- Java toolchain switching: `java21` / `java17` aliases flip `JAVA_HOME`
  between versions resolved via `/usr/libexec/java_home`.
- Sources `~/.zshrc.work` for machine/work-specific config that is **not**
  tracked in this repo.
- `v` / `vim` alias to `nvim`.

## Neovim (`.config/nvim`)

lazy.nvim-managed config with the lockfile committed. Core settings live under
`lua/bradleytaylor/` (keymaps, options, autocmds, diagnostics) and plugins are
one file each under `lua/plugins/` (LSP, Telescope, Treesitter, completion,
conform, harpoon, oil, git, dadbod, lualine, mini, and more). Space is the
leader key. See `nvim/.config/nvim/README.md` for details.

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

- `gs` - fzf-driven `git switch` (handles remote branches).
- `idea` - launch IntelliJ IDEA Ultimate from the CLI.
