# Linux-Helper-Files
This repository contains helper scripts for setting up and optimizing Linux machines

Z-SH
# ⚡ Zsh Setup Script

A simple shell script to fully configure Zsh with [Oh My Zsh](https://ohmyz.sh/), plugins, and a beautiful theme on a fresh Linux system.

## 🚀 Features

- Installs **Zsh** if not already installed
- Installs **Oh My Zsh**
- Sets **Zsh as the default shell**
- Installs useful plugins:
  - [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions)
  - [`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting)
- Installs the **Powerlevel10k** theme for an enhanced prompt
- Automatically updates `.zshrc` with your plugins and theme

## 🛠️ Supported Systems

- Debian / Ubuntu
- Fedora / RHEL
- Arch Linux

## 📦 Installation

### 1. Clone the repository

git clone https://github.com/your-username/zsh-setup.git](https://github.com/csnhawkins/Linux-Helper-Files.git
cd zsh-setup

### 2. Run the script

chmod +x setup-zsh.sh
./setup-zsh.sh

### 3. Restart zsh

exec zsh

