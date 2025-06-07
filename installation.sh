#!/usr/bin/env bash

set -e

clear
figlet -f big -w 200 "INSTALLATION"
echo
echo "🧠 Full Language Toolchain Setup + Nerd Font Check"
echo

detect_package_manager() {
    if command -v apt &>/dev/null; then
        echo "apt"
    elif command -v pacman &>/dev/null; then
        echo "pacman"
    elif command -v dnf &>/dev/null; then
        echo "dnf"
    elif command -v zypper &>/dev/null; then
        echo "zypper"
    elif command -v emerge &>/dev/null; then
        echo "emerge"
    else
        echo "unknown"
    fi
}

PKG_MANAGER=$(detect_package_manager)

install_package() {
    local bin_check="$1"
    local package="$2"
    local display="$3"

    echo
    echo "🔍 Checking: $display"

    if command -v "$bin_check" &>/dev/null; then
        echo "✅ $display already installed."
    else
        echo "📥 Installing $display..."
        case $PKG_MANAGER in
        apt) sudo apt update && sudo apt install -y "$package" ;;
        pacman) sudo pacman -Syu --noconfirm "$package" ;;
        dnf) sudo dnf install -y "$package" ;;
        zypper) sudo zypper install -y "$package" ;;
        emerge) sudo emerge "$package" ;;
        esac
    fi
}

install_package "figlet" "figlet" "Figlet (ASCII banners)"

check_nerd_font_installed() {
    fc-list | grep -qi "Nerd Font"
}

install_nerd_font() {
    echo
    echo "🎨 Nerd Font not detected. Let's install one!"
    echo "Choose a Nerd Font to install:"
    echo "1) FiraCode Nerd Font (Recommended)"
    echo "2) JetBrainsMono Nerd Font"
    echo
    read -p "Select [1/2]: " FONT_CHOICE

    FONT_NAME="FiraCode"
    [[ "$FONT_CHOICE" == "2" ]] && FONT_NAME="JetBrainsMono"

    echo "💾 Downloading $FONT_NAME Nerd Font..."
    mkdir -p ~/.local/share/fonts

    FONT_URL_BASE="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"
    FONT_FILE="${FONT_NAME}.zip"
    wget "$FONT_URL_BASE/$FONT_FILE" -O "/tmp/$FONT_FILE"

    unzip -o "/tmp/$FONT_FILE" -d ~/.local/share/fonts/"$FONT_NAME"
    fc-cache -fv

    echo "✅ $FONT_NAME Nerd Font installed successfully!"
}

if check_nerd_font_installed; then
    echo "✅ Nerd Font already installed!"
else
    install_package "wget" "wget" "Wget (required to download fonts)"
    install_package "unzip" "unzip" "Unzip (required to extract fonts)"
    install_nerd_font
fi

install_package "node" "nodejs" "Node.js"
install_package "npm" "npm" "npm"
install_package "python3" "python3" "Python 3"
install_package "python3-venv" "python3-venv" "Python3 venv (required for pipx)"
install_package "dotnet" "dotnet-sdk" ".NET SDK"
install_package "clangd" "clangd" "Clangd (C/C++)"

npm_install() {
    local package="$1"
    echo
    echo "🔍 Checking: $package (npm)"
    if npm list -g "$package" &>/dev/null; then
        echo "✅ $package already installed"
    else
        echo "📥 Installing $package via npm..."
        sudo npm install -g "$package"
    fi
}
npm_install "pyright"
npm_install "vscode-langservers-extracted"
npm_install "bash-language-server"

if ! command -v pipx &>/dev/null; then
    echo
    echo "📥 pipx non trovato, lo installo con pip3..."
    python3 -m pip install --user pipx --break-system-packages
    export PATH="$HOME/.local/bin:$PATH"
    echo "✅ pipx installato!"
else
    echo
    echo "✅ pipx già presente"
fi

pipx_install() {
    local module="$1"
    echo
    echo "🔍 Checking: $module (pipx)"
    if pipx list | grep -q "$module"; then
        echo "✅ $module già installato con pipx"
    else
        echo "📥 Installazione $module con pipx..."
        pipx install "$module" --pip-args="--break-system-packages"
    fi
}

pipx_install "python-lsp-server"

echo
read -p "🌈 Do you want to install icon fonts (Font Awesome, Material Symbols)? [y/N]: " ICONS_YES
if [[ "$ICONS_YES" == "y" || "$ICONS_YES" == "Y" ]]; then
    echo "📥 Installing icon fonts..."
    mkdir -p ~/.local/share/fonts/icons
    wget https://github.com/google/material-design-icons/releases/download/4.0.0/materialdesignicons-webfont.zip -O /tmp/materialicons.zip
    unzip -o /tmp/materialicons.zip -d ~/.local/share/fonts/icons
    fc-cache -fv
    echo "✅ Icon fonts installed!"
else
    echo "⏭️ Skipping icon fonts..."
fi

echo
figlet -f big -w 200 "DONE"
echo "🎉 Everything is ready."
