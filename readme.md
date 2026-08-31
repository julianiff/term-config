# Terminal Configuration Setup

Dotfiles for reproducing this terminal environment: zsh (with zinit, starship,
autosuggestions, syntax highlighting), WezTerm, Ghostty, and lazygit.

## Directory Structure

```
~/.config/term-config/
├── zsh/
│   └── .zshrc          # ZSH configuration (ZDOTDIR target)
├── starship/
│   └── starship.toml   # Starship prompt configuration
├── ghostty/
│   └── config          # Ghostty terminal configuration
├── wezterm/
│   └── wezterm.lua     # WezTerm terminal configuration
└── lazygit/
    └── config.yml      # lazygit configuration (currently empty/defaults)
```

## 1. Clone the repo

```bash
git clone <this-repo-url> ~/.config/term-config
```

## 2. Install required tools (Homebrew)

```bash
# Shell prompt & plugins
brew install starship
brew install autojump

# TUIs used by aliases/functions (lg, lzd, y)
brew install lazygit
brew install lazydocker
brew install yazi

# Editor
brew install neovim

# Terminals (pick one or both)
brew install --cask wezterm
brew install --cask ghostty

# Font used by both terminals
brew install --cask font-hack
```

`zsh-autosuggestions` and `fast-syntax-highlighting` do **not** need to be
installed via Homebrew — `.zshrc` bootstraps
[zinit](https://github.com/zdharma-continuum/zinit) on first launch, which
then installs and loads both plugins automatically.

## 3. Point zsh at this config

```bash
echo 'export ZDOTDIR="$HOME/.config/term-config/zsh"' > ~/.zshenv
```

Open a new shell. On first launch, zinit will clone itself and install the
`fast-syntax-highlighting` / `zsh-autosuggestions` plugins automatically —
this can take a few seconds.

## 4. Symlink terminal configs

```bash
# WezTerm
ln -s ~/.config/term-config/wezterm/wezterm.lua ~/.wezterm.lua

# Ghostty (create the target dir first if needed)
mkdir -p ~/.config/ghostty
ln -s ~/.config/term-config/ghostty/config ~/.config/ghostty/config

# lazygit (optional — config.yml is currently empty, so lazygit defaults apply either way)
mkdir -p ~/Library/Application\ Support/lazygit
ln -s ~/.config/term-config/lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml
```

Starship doesn't need a symlink — `.zshrc` points `STARSHIP_CONFIG` directly
at `~/.config/term-config/starship/starship.toml`.

## 5. Other tools referenced in `.zshrc`

These aren't strictly required to get a shell working, but `.zshrc` expects
them for full functionality:

```bash
# Node Version Manager (lazy-loaded on first `node`/`npm`/`npx`/`nvm` call)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Bun
curl -fsSL https://bun.sh/install | bash

# Go (sets up $GOPATH/bin on PATH)
brew install go

# pnpm (only $PNPM_HOME/bin is added to PATH — install pnpm itself separately)
brew install pnpm

# GPG (GPG_TTY is exported for commit signing / gpg prompts)
brew install gnupg
```

`.zshrc` also sets `DOCKER_HOST` to OrbStack's docker socket
(`~/.orbstack/run/docker.sock`). Install [OrbStack](https://orbstack.dev) if
you want `docker`/`lazydocker` to work out of the box; otherwise remove that
line.

There's also a hardcoded `PATH` entry for PhpStorm
(`/Applications/PhpStorm.app/Contents/MacOS`) — remove it from `.zshrc` if
you don't use PhpStorm.

## 6. Verify

Open a new terminal (WezTerm or Ghostty) and confirm:

- Prompt shows the starship format (directory, git branch/status, cmd duration)
- `lg` opens lazygit, `lzd` opens lazydocker, `n` opens neovim, `y` opens yazi
- `alt+h/j/k/l` moves focus between splits (Ghostty) / panes (WezTerm)

## Customization

- Prompt: `~/.config/term-config/starship/starship.toml`
- WezTerm: `~/.config/term-config/wezterm/wezterm.lua`
- Ghostty: `~/.config/term-config/ghostty/config`
- Shell aliases/functions/env vars: `~/.config/term-config/zsh/.zshrc`
