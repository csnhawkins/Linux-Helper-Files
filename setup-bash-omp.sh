#!/bin/bash
set -e

echo "🔧 Installing Bash + Oh My Posh + Productivity Plugins..."

# 1. Ensure ~/.local/bin is in PATH
export PATH="$HOME/.local/bin:$PATH"
mkdir -p "$HOME/.local/bin"

# 2. Install Oh My Posh if missing
if ! command -v oh-my-posh &> /dev/null; then
  echo "📦 Installing Oh My Posh..."
  curl -s https://ohmyposh.dev/install.sh | bash -s
else
  echo "✅ Oh My Posh already installed."
fi

# 3. Download themes to ~/.poshthemes
echo "🎨 Downloading Oh My Posh themes..."
mkdir -p ~/.poshthemes
wget -q https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip -o ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.omp.json

# 4. Preview and select a theme
echo "🖼️  Available Themes Preview (first 10 shown):"
THEMES=(~/.poshthemes/*.omp.json)
for theme in "${THEMES[@]:0:10}"; do
  echo "Previewing theme: $(basename "$theme")"
  oh-my-posh init bash --config "$theme" | head -n 10
  echo "-----------------------------"
done

read -p "🎨 Enter the name of the theme you want to use (e.g., jandedobbeleer.omp.json), or press Enter to use default: " SELECTED_THEME

if [ -n "$SELECTED_THEME" ] && [ -f "$HOME/.poshthemes/$SELECTED_THEME" ]; then
  THEME="$HOME/.poshthemes/$SELECTED_THEME"
else
  THEME="$HOME/.poshthemes/jandedobbeleer.omp.json"
  echo "✅ Using default theme: jandedobbeleer.omp.json"
fi

# 5. Configure Oh My Posh in .bashrc
BASHRC="$HOME/.bashrc"
OMP_LINE="eval \"\$(oh-my-posh init bash --config $THEME)\""

if ! grep -q "oh-my-posh init bash" "$BASHRC"; then
  echo "" >> "$BASHRC"
  echo "# 🧠 Oh My Posh prompt" >> "$BASHRC"
  echo "$OMP_LINE" >> "$BASHRC"
  echo "✅ Added Oh My Posh to .bashrc"
else
  echo "ℹ️ Oh My Posh already configured in .bashrc"
fi

# 6. Install FiraCode Nerd Font
echo "🔠 Installing FiraCode Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip -O "$FONT_DIR/FiraCode.zip"
unzip -qo "$FONT_DIR/FiraCode.zip" -d "$FONT_DIR"
fc-cache -fv "$FONT_DIR"

# 7. Install bash-it (like oh-my-zsh for Bash)
if [ ! -d "$HOME/.bash_it" ]; then
  echo "🧰 Installing bash-it..."
  git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
  ~/.bash_it/install.sh --silent
else
  echo "✅ bash-it already installed"
fi

# 8. Enable useful bash-it plugins
~/.bash_it/bin/bash-it enable completion git
~/.bash_it/bin/bash-it enable plugin alias-completion base

# 9. Disable bash-it themes (we're using oh-my-posh instead)
sed -i 's/^export BASH_IT_THEME=.*/# Disabled theme, using oh-my-posh/' "$HOME/.bashrc"

# 10. Install bash-autosuggestions
if [ ! -d "$HOME/.bash-autosuggestions" ]; then
  echo "💡 Installing bash-autosuggestions..."
  git clone https://github.com/gh0stzk/bash-autosuggestions ~/.bash-autosuggestions
  echo "source ~/.bash-autosuggestions/autosuggestions.sh" >> "$HOME/.bashrc"
else
  echo "✅ bash-autosuggestions already installed"
fi

# 11. Final message
echo
echo "🎉 Bash + Oh My Posh setup complete!"
echo "👉 Restart your terminal to see the new prompt."
echo "📁 Themes are in: ~/.poshthemes"
echo "🎨 Change your theme by editing your .bashrc line:"
echo "    $OMP_LINE"
echo "🧠 Plugins enabled: bash-it (git, completion, aliases), autosuggestions"
echo "🔤 Make sure your terminal font is set to: FiraCode Nerd Font"
