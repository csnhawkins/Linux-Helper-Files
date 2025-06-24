# 🧰 Linux Helper Files

This repository contains helper scripts to quickly configure and optimize Linux terminals with powerful and beautiful prompt setups.

---

## 🟩 Bash + Oh My Posh Setup (Recommended)

A streamlined setup script for Bash users that includes [Oh My Posh](https://ohmyposh.dev), useful productivity plugins, and Nerd Fonts.

### 🚀 Features

- Installs **Oh My Posh** with theme selector
- Downloads the latest **Oh My Posh themes**
- Installs **FiraCode Nerd Font**
- Adds **bash-it** (like Oh My Zsh, but for Bash)
- Enables helpful Bash plugins:
  - `git` aliases
  - `alias-completion`
  - `bash completion`
- Adds **autosuggestions**
- Cleanly updates `.bashrc` with your selected theme

### 🛠️ Supported Systems

- Debian / Ubuntu
- Fedora / RHEL
- Arch Linux

### 📦 Installation

#### 1. Clone the repository

```bash
git clone https://github.com/csnhawkins/Linux-Helper-Files.git
cd Linux-Helper-Files
```

#### 2. Run the bash setup script

```bash
chmod +x setup-bash-omp.sh
./setup-bash-omp.sh
```

#### 3. Restart your terminal to apply your theme

```bash
bash
```

---

## ⚡ Zsh Setup (Alternative Option)

A simple shell script to fully configure Zsh with [Oh My Zsh](https://ohmyz.sh/), plugins, and a beautiful Powerlevel10k theme.

### 🚀 Features

- Installs **Zsh** if missing
- Installs **Oh My Zsh**
- Sets **Zsh** as your default shell
- Installs essential plugins:
  - [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions)
  - [`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting)
- Installs the **Powerlevel10k** theme
- Automatically updates your `.zshrc`

### 🛠️ Supported Systems

- Debian / Ubuntu
- Fedora / RHEL
- Arch Linux

### 📦 Installation

#### 1. Clone the repository

```bash
git clone https://github.com/csnhawkins/Linux-Helper-Files.git
cd Linux-Helper-Files
```

#### 2. Run the Zsh setup script

```bash
chmod +x setup-zsh.sh
./setup-zsh.sh
```

#### 3. Restart your terminal to apply your theme

```bash
exec zsh
```
