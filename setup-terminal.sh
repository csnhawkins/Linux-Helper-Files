#!/bin/bash
set -e

# ----------------------------------------
# 📦 Install Required Dependencies
# ----------------------------------------
echo "Installing required packages..."
sudo apt update
sudo apt install -y unzip curl wget fontconfig git zsh tmux

# ----------------------------------------
# 🛠️ Add ~/.local/bin to PATH for this session
# ----------------------------------------
export PATH="$HOME/.local/bin:$PATH"

# ----------------------------------------
# 🔧 Ask the user to choose a shell setup
# ----------------------------------------
echo "Which shell setup do you want?"
echo "1) Bash + Oh My Posh"
echo "2) Zsh + Oh My Posh"
echo "3) Zsh + Oh My Zsh (with Powerlevel10k)"
read -p "Enter your choice [1-3]: " choice

# ----------------------------------------
# 🎨 Install FiraCode Nerd Font (for icons)
# ----------------------------------------
install_nerd_font() {
  FONT_NAME="FiraCode"
  FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
  FONT_DIR="$HOME/.local/share/fonts"

  echo "Installing $FONT_NAME Nerd Font..."
  mkdir -p "$FONT_DIR"
  wget -q "$FONT_URL" -O "$FONT_DIR/FiraCode.zip"
  unzip -qo "$FONT_DIR/FiraCode.zip" -d "$FONT_DIR"
  fc-cache -fv "$FONT_DIR"
  echo "✅ $FONT_NAME Nerd Font installed."
}

# ----------------------------------------
# 💅 Install Oh My Posh (prompt tool)
# ----------------------------------------
install_oh_my_posh() {
  if ! command -v oh-my-posh &> /dev/null; then
    echo "Installing Oh My Posh..."
    curl -s https://ohmyposh.dev/install.sh | bash -s
  else
    echo "Oh My Posh is already installed."
  fi
}

# ----------------------------------------
# 🔁 Change default shell
# ----------------------------------------
set_default_shell() {
  SHELL_PATH=$(command -v "$1")
  echo "Setting default shell to $SHELL_PATH..."
  if ! echo "$SHELL" | grep -q "$SHELL_PATH"; then
    if ! chsh -s "$SHELL_PATH"; then
      echo "⚠️  Could not change default shell. You may need to do this manually."
    fi
  fi
}

# ----------------------------------------
# ⚡ Install Powerlevel10k for Oh My Zsh
# ----------------------------------------
install_powerlevel10k() {
  if [[ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then
    echo "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
      "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
  fi
}

# ----------------------------------------
# 📄 Install default cheatsheet for tmux
# ----------------------------------------
install_cheatsheet() {
  mkdir -p "$HOME/.cheats"
  cat <<EOF > "$HOME/.cheatsheet.txt"
# 🧠 Terminal Cheat Sheet

# Navigation
cd       # change directory
ls -la   # list all files with details
pwd      # print current directory

# Git
git status
git add .
git commit -m "message"
git push

git checkout -b new-branch

# Zsh Shortcuts
Ctrl + R  # reverse search
Ctrl + A  # beginning of line
Ctrl + E  # end of line

# tmux
Ctrl + B, D  # detach
Ctrl + B, %  # vertical split
Ctrl + B, "  # horizontal split
EOF
}

# ----------------------------------------
# 📟 Setup tmux with cheatsheet panel
# ----------------------------------------
setup_tmux_cheatsheet() {
  if command -v tmux &> /dev/null; then
    echo "Setting up tmux split pane with cheatsheet..."
    tmux new-session -d -s cheats
    tmux split-window -v -p 30 "watch -n 10 cat ~/.cheatsheet.txt"
    tmux select-pane -t 0
    tmux attach-session -t cheats
  else
    echo "tmux not installed. Skipping split cheatsheet."
  fi
}

# Run font and cheatsheet setup for all users
install_nerd_font
install_cheatsheet

# ----------------------------------------
# 🧠 Handle Shell Setup Based on Choice
# ----------------------------------------
if [[ "$choice" == "1" ]]; then
  echo "Installing Bash + Oh My Posh setup..."
  install_oh_my_posh

  PROFILE="$HOME/.bashrc"
  THEME_PATH="$HOME/.poshthemes/cramer.omp.json"
  mkdir -p ~/.poshthemes
  curl -s https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/cramer.omp.json -o "$THEME_PATH"

  if ! grep -q "oh-my-posh init bash" "$PROFILE"; then
    echo "eval \"\\$(oh-my-posh init bash --config $THEME_PATH)\"" >> "$PROFILE"
  fi
  set_default_shell bash

elif [[ "$choice" == "2" ]]; then
  echo "Installing Zsh + Oh My Posh setup..."
  install_oh_my_posh

  PROFILE="$HOME/.zshrc"
  THEME_PATH="$HOME/.poshthemes/cramer.omp.json"
  mkdir -p ~/.poshthemes
  curl -s https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/cramer.omp.json -o "$THEME_PATH"

  if ! grep -q "oh-my-posh init zsh" "$PROFILE"; then
    echo "eval \"\\$(oh-my-posh init zsh --config $THEME_PATH)\"" >> "$PROFILE"
  fi
  set_default_shell zsh

elif [[ "$choice" == "3" ]]; then
  echo "Installing Zsh + Oh My Zsh + Powerlevel10k..."

  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  install_powerlevel10k
  sed -i 's|^ZSH_THEME=.*|ZSH_THEME=\"powerlevel10k/powerlevel10k\"|' "$HOME/.zshrc"

  # Auto-run Powerlevel10k config on next login
  echo '[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh' >> "$HOME/.zshrc"
  echo "exec zsh -l && p10k configure" >> "$HOME/.zprofile"

  set_default_shell zsh

else
  echo "❌ Invalid choice. Exiting."
  exit 1
fi

# ----------------------------------------
# 🎯 Launch tmux session with cheatsheet
# ----------------------------------------
setup_tmux_cheatsheet

echo
echo "✅ Shell setup complete."
echo "👉 Make sure your terminal font is set to: FiraCode Nerd Font"
echo "🔄 Restart your terminal or logout/login for changes to apply."
echo "🧾 Cheatsheet panel is available in tmux (bottom split)."
