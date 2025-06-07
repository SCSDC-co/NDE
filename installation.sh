#!/usr/bin/env bash
set -e

clear

if ! command -v figlet &>/dev/null; then
    echo "📥 Installing Figlet..."
    if   command -v apt     &>/dev/null; then sudo apt update && sudo apt install -y figlet
    elif command -v pacman  &>/dev/null; then sudo pacman -Syu --noconfirm figlet
    elif command -v dnf     &>/dev/null; then sudo dnf install -y figlet
    elif command -v zypper  &>/dev/null; then sudo zypper install -y figlet
    elif command -v emerge  &>/dev/null; then sudo emerge figlet
    else
        echo "⚠️ No supported package manager found for figlet."
        exit 1
    fi
fi

figlet -f big -w 200 "INSTALLATION"
echo
echo "🧠 Full Language Toolchain Setup + Nerd Font Check"
echo

detect_package_manager() {
    if   command -v apt    &>/dev/null; then echo "apt"
    elif command -v pacman &>/dev/null; then echo "pacman"
    elif command -v dnf    &>/dev/null; then echo "dnf"
    elif command -v zypper &>/dev/null; then echo "zypper"
    elif command -v emerge &>/dev/null; then echo "emerge"
    else echo "unknown"
    fi
}
PKG_MANAGER=$(detect_package_manager)

install_package() {
    local bin_check="$1" package="$2" display="$3"
    echo
    echo "🔍 Checking: $display"
    if command -v "$bin_check" &>/dev/null; then
        echo "✅ $display is already installed."
    else
        echo "📥 Installing: $display"
        case $PKG_MANAGER in
            apt)    sudo apt update && sudo apt install -y "$package" ;;
            pacman) sudo pacman -Syu --noconfirm "$package" ;;
            dnf)    sudo dnf install -y "$package" ;;
            zypper) sudo zypper install -y "$package" ;;
            emerge) sudo emerge "$package" ;;
        esac
        echo "✅ $display installation complete."
    fi
}

check_nerd_font_installed() {
    fc-list | grep -qi "Nerd Font"
}

install_nerd_font() {
    echo
    echo "🎨 Nerd Font not detected. Installing now..."
    echo "  1) FiraCode Nerd Font (Recommended)"
    echo "  2) JetBrainsMono Nerd Font"
    read -rp "Select [1/2]: " FONT_CHOICE
    FONT_NAME="FiraCode"
    [[ "$FONT_CHOICE" == "2" ]] && FONT_NAME="JetBrainsMono"
    echo
    echo "💾 Downloading $FONT_NAME Nerd Font..."
    mkdir -p ~/.local/share/fonts/"$FONT_NAME"
    FONT_URL_BASE="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"
    wget -O "/tmp/${FONT_NAME}.zip" "$FONT_URL_BASE/${FONT_NAME}.zip"
    echo "📂 Extracting fonts..."
    unzip -qo "/tmp/${FONT_NAME}.zip" -d ~/.local/share/fonts/"$FONT_NAME"
    echo "🔄 Refreshing font cache..."
    fc-cache -fv
    echo "✅ $FONT_NAME Nerd Font installed!"
}

if check_nerd_font_installed; then
    echo
    echo "✅ Nerd Font already installed!"
else
    install_package wget   wget   "Wget"
    install_package unzip  unzip  "Unzip"
    install_nerd_font
fi

install_package node    nodejs        "Node.js"
install_package npm     npm           "npm"
install_package python3 python3       "Python 3"
install_package pip3    python3-pip   "pip"
install_package python3 python3-venv  "python3-venv"
install_package dotnet  dotnet-sdk    ".NET SDK"
install_package clangd  clangd        "Clangd (C/C++)"

npm_install() {
    local pkg="$1"
    echo
    echo "🔍 Checking: $pkg (npm)"
    if npm list -g "$pkg" &>/dev/null; then
        echo "✅ $pkg is already installed."
    else
        echo "📥 Installing: $pkg (npm)"
        sudo npm install -g "$pkg"
        echo "✅ $pkg installation complete."
    fi
}
npm_install pyright
npm_install vscode-langservers-extracted
npm_install bash-language-server

pipx_check() {
    if command -v pipx &>/dev/null; then
        echo
        echo "✅ pipx is already installed."
    else
        echo
        echo "📥 Installing pipx..."
        case $PKG_MANAGER in
            apt)    sudo apt update && sudo apt install -y pipx python3-venv ;;
            pacman) sudo pacman -Syu --noconfirm pipx ;;
            dnf)    sudo dnf install -y pipx ;;
            zypper) sudo zypper install -y python3-pipx ;;
            emerge) sudo emerge pipx ;;
        esac
        export PATH="$HOME/.local/bin:$PATH"
        echo "✅ pipx installation complete."
    fi
}
pipx_check

echo
echo "🔍 Checking: python-lsp-server (pipx)"
if pipx list | grep -q python-lsp-server; then
    echo "✅ python-lsp-server is already installed."
else
    echo "📥 Installing: python-lsp-server (pipx)"
    pipx install --system-site-packages --break-system-packages python-lsp-server
    echo "✅ python-lsp-server installation complete."
fi

# Rust toolchain
echo
if command -v rustup &>/dev/null; then
    echo "✅ rustup is already installed."
else
    echo "📥 Installing rustup and Cargo..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    SHELL_NAME=$(basename "$SHELL")
    case "$SHELL_NAME" in
      zsh)  RC_FILE="$HOME/.zshrc" ;;
      bash) RC_FILE="$HOME/.bashrc" ;;
      fish) RC_FILE="$HOME/.config/fish/config.fish" ;;
      *)     RC_FILE="$HOME/.profile" ;;
    esac
    echo "export PATH=\"\$HOME/.cargo/bin:\$PATH\"" >> "$RC_FILE"
    export PATH="$HOME/.cargo/bin:$PATH"
    echo "✅ rustup and Cargo installed; PATH updated in $RC_FILE."
fi

clear
figlet -f big -w 200 "DONE"
echo "🎉 All done!"
