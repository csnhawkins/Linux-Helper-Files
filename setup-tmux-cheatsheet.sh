#!/bin/bash

# ----------------------------------------
# 📄 Create a default cheat sheet
# ----------------------------------------
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
Ctrl + B, D   # detach session
Ctrl + B, %   # vertical split
Ctrl + B, "   # horizontal split
Ctrl + B, [   # enter scroll mode
EOF

# ----------------------------------------
# 🖥️ Launch tmux with vertical layout and scrollable cheat pane
# ----------------------------------------
if command -v tmux &> /dev/null; then
  echo "Launching tmux with vertical cheat sheet pane..."

  tmux new-session -d -s cheats -n main
  tmux split-window -h -p 30 "less +F ~/.cheatsheet.txt"  # Right-side pane with scrolling support
  tmux select-pane -L  # Focus back to left pane
  tmux attach-session -t cheats

else
  echo "❌ tmux not found. Please install it first."
fi
