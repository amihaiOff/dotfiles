#!/usr/bin/env bash

# Still need to manually add git ssh key and clone the dotfiles repo. Then after setup need to manually use stow to create the symlinks.

set -e  # Exit if a command fails

DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    echo "Running in DRY RUN mode — no changes will be made."
fi

# Function to run commands or just print them
run_cmd() {
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] $*"
    else
        eval "$@"
    fi
}

# Detect OS
OS="$(uname -s)"
case "$OS" in
    Darwin)
        echo "Detected macOS"
        IS_MAC=true
        ;;
    Linux)
        echo "Detected Linux"
        IS_MAC=false
        ;;
    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

# macOS-specific installs
if [ "$IS_MAC" = true ]; then
    # Install Homebrew if missing
    if ! command -v brew >/dev/null 2>&1; then
        echo "Installing Homebrew..."
        run_cmd '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        run_cmd eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # Ensure zsh is installed
    if ! command -v zsh >/dev/null 2>&1; then
        echo "Installing zsh..."
        run_cmd brew install zsh
    fi

    echo "Installing macOS packages via brew..."
    run_cmd brew install --cask arc karabiner-elements ghostty flux
    run_cmd brew install starship atuin bpytop lazygit dust tldr eza bat trash-cli watch
fi

# Linux-specific installs
if [ "$IS_MAC" = false ]; then
    # Ensure zsh is installed
    if ! command -v zsh >/dev/null 2>&1; then
        echo "Installing zsh..."
        run_cmd sudo apt update -y
        run_cmd sudo apt install -y zsh
    fi

    echo "Installing Linux packages..."
    run_cmd sudo apt update -y
    run_cmd sudo apt install -y curl wget git unzip starship atuin bpytop lazygit \
        dust tldr eza bat trash-cli watch
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    run_cmd RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install zsh plugins (no .zshrc edits)
ZSH_PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
run_cmd mkdir -p "$ZSH_PLUGIN_DIR"

declare -A PLUGINS=(
    [fzf-zsh]="https://github.com/unixorn/fzf-zsh-plugin.git"
    [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    [zsh-z]="https://github.com/agkozak/zsh-z.git"
    [fzf-tab]="https://github.com/Aloxaf/fzf-tab.git"
    [zsh-vi-mode]="https://github.com/jeffreytse/zsh-vi-mode.git"
)

for plugin in "${!PLUGINS[@]}"; do
    if [ ! -d "$ZSH_PLUGIN_DIR/$plugin" ]; then
        echo "Installing $plugin..."
        run_cmd git clone "${PLUGINS[$plugin]}" "$ZSH_PLUGIN_DIR/$plugin"
    fi
done


echo "Setup complete! Restart your terminal or run 'exec zsh'."

