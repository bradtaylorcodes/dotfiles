if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"
fi

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
addToPath $HOME/.local/scripts

alias v="nvim"
alias vim="nvim"
alias ls="ls -G"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# export GOPATH=$HOME/go

if command -v brew >/dev/null 2>&1; then
  [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
    source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
    source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

eval "$(starship init zsh)"
