#!/bin/zsh

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root. Please use sudo." >&2
  exit 1
fi

# Install curl
apt update && apt install curl -y

# Update and upgrade the system
apt update && apt upgrade -y

# Install vim
apt install vim -y

# Install Oh My Zsh
if [[ ! -d ~/.oh-my-zsh ]]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
fi

# Define Oh My Zsh custom plugins directory
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

# Install Oh My Zsh plugins
echo "Installing zsh plugins..."
ZSH_PLUGINS=(
  "zsh-users/zsh-syntax-highlighting"
  "zsh-users/zsh-autosuggestions"
  "rupa/z"
  "travisjeffery/fzf-zsh-plugin"
  "Aloxaf/fzf-tab"
  "jeffreytse/zsh-vi-mode"
)

for plugin in $ZSH_PLUGINS; do
  PLUGIN_NAME=${plugin##*/}
  if [[ ! -d "$ZSH_CUSTOM/plugins/$PLUGIN_NAME" ]]; then
    git clone https://github.com/$plugin $ZSH_CUSTOM/plugins/$PLUGIN_NAME
  else
    echo "$PLUGIN_NAME is already installed."
  fi
done

# Add plugins to .zshrc if not already present
PLUGINS_LINE=$(grep "^plugins=" ~/.zshrc || echo "plugins=(git)")
for plugin in zsh-syntax-highlighting zsh-autosuggestions z fzf-zsh-plugin fzf-tab zsh-vi-mode; do
  if ! echo "$PLUGINS_LINE" | grep -q "$plugin"; then
    PLUGINS_LINE=${PLUGINS_LINE%)}" $plugin)"
  fi
done
echo "$PLUGINS_LINE" > ~/.zshrc

# Install exa
apt install eza -y

# Install tldr
apt install tldr -y

# Install pyenv
echo "Installing pyenv..."
if [[ ! -d ~/.pyenv ]]; then
  curl https://pyenv.run | bash
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
  echo 'command -v pyenv > /dev/null && eval "$(pyenv init --path)"' >> ~/.zshrc
  echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
fi

# Install starship
if ! command -v starship > /dev/null 2>&1; then
  echo "Installing Starship..."
  sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y
fi

# Add Starship to .zshrc if not present
if ! grep -q "eval \"\$(starship init zsh)\"" ~/.zshrc; then
  echo "eval \"\$(starship init zsh)\"" >> ~/.zshrc
fi

# Install stow
apt install stow -y

cd .config
stow -t ~/.config .

# Final message
echo "Setup complete. Please restart your terminal or run 'source ~/.zshrc' to apply changes."

cd ~
git clone git@github.com:linnnus/autovenv.git
