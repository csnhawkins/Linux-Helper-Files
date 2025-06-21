#!/bin/bash

set -e

echo "🔧 Starting Zsh setup..."

# 1. Install Zsh if not present
if ! command -v zsh &> /dev/null; then
    echo "📦 Zsh not found. Installing..."
    if [ -f /etc/debian_version ]; then
        sudo apt update && sudo apt install -y zsh git curl
    elif [ -f /etc/redhat-release ]; then
        sudo dnf install -y zsh git curl
    elif [ -f /etc/arch-release ]; then
        sudo pacman -Syu --noconfirm zsh git curl
    else
        echo "❌ Unsupported OS. Please install Zsh manually."
        exit 1
    fi
else
    echo "✅ Zsh is already installed."
fi

# 2. Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🎉 Installing Oh My Zsh..."
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "✅ Oh My Zsh already installed."
fi

# 3. Set Zsh as the default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "🔄 Changing default shell to Zsh..."
    chsh -s "$(which zsh)"
else
    echo "✅ Zsh is already the default shell."
fi

# 4. Install useful plugins
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
echo "🧩 Installing zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" || echo "Already installed"
echo "🧩 Installing zsh-syntax-highlighting..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" || echo "Already installed"

# 5. Install Powerlevel10k theme (optional but nice)
echo "🎨 Installing Powerlevel10k theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k" || echo "Already installed"

# 6. Update .zshrc
echo "⚙️ Updating .zshrc..."

sed -i.bak \
    -e 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' \
    -e 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' \
    ~/.zshrc

# Add plugin sourcing if not present
grep -qxF "source \$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ~/.zshrc || echo "source \$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
grep -qxF "source \$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ~/.zshrc || echo "source \$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

echo "✅ Zsh setup complete! Please restart your terminal or run \`zsh\` to use Zsh now."
