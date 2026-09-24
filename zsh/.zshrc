if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"
fi

autoload -Uz compinit && compinit

if command -v fzf >/dev/null; then
  source <(fzf --zsh)
fi

addToPath() {
  if [[ "$PATH" != *"$1"* ]]; then
    export PATH=$PATH:$1
  fi
}

addToPathFront() {
  if [[ "$PATH" != *"$1"* ]]; then
    export PATH=$1:$PATH
  fi
}

# my scripts and aliases
addToPathFront $HOME/.local/bin
addToPath $HOME/.local/scripts

alias v="nvim"
alias vim="nvim"

if [[ "$OSTYPE" == darwin* ]]; then
  alias ls="ls -G"
else
  alias ls="ls --color=auto"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Homebrew on macOS, /usr/share from dnf on Fedora
plugin_dirs=(/usr/share)
command -v brew >/dev/null 2>&1 && plugin_dirs=("$(brew --prefix)/share" $plugin_dirs)

for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
  for dir in $plugin_dirs; do
    if [ -f "$dir/$plugin/$plugin.zsh" ]; then
      source "$dir/$plugin/$plugin.zsh"
      break
    fi
  done
done
unset plugin_dirs plugin dir

eval "$(starship init zsh)"
