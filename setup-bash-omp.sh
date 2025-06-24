#!/bin/bash

set -e

echo "🔧 Installing Bash + Oh My Posh"

# 1. Ensure .local/bin is in PATH
export PATH="$HOME/.local/bin:$PATH"
mkdir -p "$HOME/.local/bin"

# 2. Install Oh My Posh if not present
if ! command -v oh-my-posh &> /dev/null; then
  echo "📦 Installing Oh My Posh..."
  curl -s https://ohmyposh.dev/install.sh | bash -s
else
  echo "✅ Oh My Posh already installed."
fi

# 3. Download themes
echo "🎨 Downloading Oh My Posh themes..."
mkdir -p ~/.poshthemes
wget -q https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip -o ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.omp.json

# 4. Install Nerd Font (FiraCode)
echo "🔠 Installing FiraCode Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip -O "$FONT_DIR/FiraCode.zip"
unzip -qo "$FONT_DIR/FiraCode.zip" -d "$FONT_DIR"
fc-cache -fv "$FONT_DIR"

# 5. Add init to .bashrc (only if not already present)
THEME="$HOME/.poshthemes/jandedobbeleer.omp.json"
BASHRC="$HOME/.bashrc"
INIT_LINE="eval \"\$(oh-my-posh init bash --config $THEME)\""

if ! grep -q "$THEME" "$BASHRC"; then
  echo "" >> "$BASHRC"
  echo "# 🧠 Oh My Posh prompt" >> "$BASHRC"
  echo "$INIT_LINE" >> "$BASHRC"
  echo "✅ Oh My Posh initialized in .bashrc"
else
  echo "ℹ️ Oh My Posh is already configured in .bashrc"
fi

echo
echo "🎉 Setup Complete!"
echo "👉 Restart your terminal to see the new prompt."
echo "📁 Themes are stored in: ~/.poshthemes"
echo "🎨 To change theme, edit this line in .bashrc:"
echo "$INIT_LINE"
