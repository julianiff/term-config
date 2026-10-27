typeset -U path PATH
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

# Lazy load nvm (deferred until first use)
export NVM_DIR="$HOME/.nvm"
_load_nvm() {
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm() { unfunction nvm node npm npx 2>/dev/null; _load_nvm; nvm "$@"; }
node() { unfunction nvm node npm npx 2>/dev/null; _load_nvm; node "$@"; }
npm() { unfunction nvm node npm npx 2>/dev/null; _load_nvm; npm "$@"; }
npx() { unfunction nvm node npm npx 2>/dev/null; _load_nvm; npx "$@"; }

# Environment variables
export GOPATH="$HOME/go"
export PNPM_HOME="$HOME/Library/pnpm"
export EDITOR=nvim
export GPG_TTY=$(tty)

# Path configurations (consolidated)
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$PNPM_HOME:$PATH"
export PATH="/Applications/PhpStorm.app/Contents/MacOS:$PATH"
export PATH="/opt/homebrew/opt/openvpn/sbin:$PATH"

# Aliases
alias lg='lazygit'
alias gco='git checkout'
alias lzd='lazydocker'
alias n='nvim'

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

# Load completions (with caching for faster startup)
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# fzf
source <(fzf --zsh)

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# Shell options
setopt AUTO_CD
setopt CORRECT
setopt NO_BEEP

# Terminal title function
function set_terminal_title() {
    # Set terminal title to current directory
    print -Pn "\e]0;%~\a"
}

# Set up precmd and preexec hooks
autoload -Uz add-zsh-hook
add-zsh-hook precmd set_terminal_title

# Configure nvim to keep terminal title
if [ -n "$NVIM" ]; then
    export NVIM_TERM_TITLE="%~"
fi

# OrbStack Docker socket
export DOCKER_HOST=unix://$HOME/.orbstack/run/docker.sock

# bun completions
[ -s "/Users/julianiff/.bun/_bun" ] && source "/Users/julianiff/.bun/_bun"

# pnpm
export PNPM_HOME="/Users/julian.iff/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

export PATH="$HOME/.cargo/bin:$PATH"
