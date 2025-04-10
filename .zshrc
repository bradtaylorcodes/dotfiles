eval "$(/opt/homebrew/bin/brew shellenv)"

if command -v fzf >/dev/null; then
  source <(fzf --zsh)
fi

export DEV_ENV_HOME="$HOME/dev-env"
source $DEV_ENV_HOME/utils
source $HOME/.zshrc.work

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

addToPath $HOME/.local/scripts

export GOPATH=$HOME/go

# Autosuggestions for zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# Syntax highlighting for zsh installed with homebrew
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias v="nvim"
alias vim="nvim"
alias ls="ls -G"
alias gs='git switch $(git branch -a | fzf)'

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
