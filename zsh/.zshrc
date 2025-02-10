export PATH="/opt/homebrew/bin:$PATH"

# Install zinit if not installed
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -f ${ZINIT_HOME}/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "${ZINIT_HOME:h}"
    command git clone https://github.com/zdharma-continuum/zinit "${ZINIT_HOME}"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Essential zinit commands
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load plugins with turbo mode
zinit wait lucid for \
    zdharma-continuum/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions

# Load git plugin
zinit snippet OMZP::git

# Autojump configuration
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# Initialize starship
export STARSHIP_CONFIG="$HOME/.config/term-config/starship/starship.toml"

eval "$(starship init zsh)"

# Lazy load nvm
export NVM_DIR="$HOME/.nvm"
alias nvm='unalias nvm && [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && nvm use 20.16 --silent && nvm'

# Path configurations
export PATH="/usr/bin/python3:$PATH"
export PATH="/Applications/PhpStorm.app/Contents/MacOS:$PATH"
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
export GOPATH=$HOME/go
export EDITOR=nvim
export GPG_TTY=$(tty)

# Aliases
alias lg='lazygit'
alias gc='git checkout'
alias lzd='lazydocker'
alias y='y'

# Functions
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# Bun setup
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Load completions
autoload -Uz compinit
compinit

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Terminal title function
function set_terminal_title() {
    # Set terminal title to current directory
    print -Pn "\e]0;%~\a"
}

# Set up precmd and preexec hooks
autoload -Uz add-zsh-hook
add-zsh-hook precmd set_terminal_title

# Configure nvim to keep terminal title
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    export NVIM_TERM_TITLE="%~"
fi
