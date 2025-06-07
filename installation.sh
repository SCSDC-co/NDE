#!/usr/bin/env bash
set -e

clear

# Banner
echo
if ! command -v figlet &>/dev/null; then
    echo "📥 Installing Figlet..."
    if command -v apt &>/dev/null; then
        sudo apt update && sudo apt install -y figlet
    elif command -v pacman &>/dev/null; then
        sudo pacman -Syu --noconfirm figlet
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y figlet
    elif command -v zypper &>/dev/null; then
        sudo zypper install -y figlet
    elif command -v emerge &>/dev/null; then
        sudo emerge figlet
    fi
fi

figlet -f big -w 200 "INSTALLATION"
echo
echo "🧠 Full Language Toolchain Setup + Nerd Font Check"
echo

# Detect package manager
detect_package_manager() {
    if command -v apt &>/dev/null;     then echo "apt"
    elif command -v pacman &>/dev/null; then echo "pacman"
    elif command -v dnf &>/dev/null;    then echo "dnf"
    elif command -v zypper &>/dev/null; then echo "zypper"
    elif command -v emerge &>/dev/null; then echo "emerge"
    else echo "unknown"
    fi
}
PKG_MANAGER=$(detect_package_manager)

# Helper: install a package if missing
install_package() {
    local bin_check="$1"
    local package="$2"
    local display="$3"

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

# Nerd Font
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

    echo "💾 Downloading $FONT_NAME Nerd Font..."
    mkdir -p ~/.local/share/fonts/"$FONT_NAME"
    wget -qO "/tmp/$FONT_NAME.zip" \
        "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT_NAME}.zip"
    echo "📂 Extracting fonts..."
    unzip -qo "/tmp/$FONT_NAME.zip" -d ~/.local/share/fonts/"$FONT_NAME"
    echo "🔄 Refreshing font cache..."
    fc-cache -fv
    echo "✅ $FONT_NAME Nerd Font installed!"
}

if check_nerd_font_installed; then
    echo
    echo "✅ Nerd Font already installed!"
else
    install_package "wget" "wget" "Wget"
    install_package "unzip" "unzip" "Unzip"
    install_nerd_font
fi

# Core tools
install_package "node"     "nodejs"        "Node.js"
install_package "npm"      "npm"           "npm"
install_package "python3"  "python3"       "Python 3"
install_package "pip3"     "python3-pip"   "pip"
install_package "python3"  "python3-venv"  "python3-venv"
install_package "dotnet"   "dotnet-sdk"    ".NET SDK"
install_package "clangd"   "clangd"        "Clangd (C/C++)"

# npm-based LSPs
npm_install() {
    local package="$1"
    echo
    echo "🔍 Checking: $package (npm)"
    if npm list -g "$package" &>/dev/null; then
        echo "✅ $package is already installed."
    else
        echo "📥 Installing: $package (npm)"
        sudo npm install -g "$package"
        echo "✅ $package installation complete."
    fi
}
npm_install "pyright"
npm_install "vscode-langservers-extracted"
npm_install "bash-language-server"

# pipx and python LSP
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
if pipx list | grep -q "python-lsp-server"; then
    echo "✅ python-lsp-server is already installed."
else
    echo "📥 Installing: python-lsp-server (pipx)"
    pipx install --system-site-packages --break-system-packages python-lsp-server
    echo "✅ python-lsp-server installation complete."
fi

# Icon fonts
echo
read -rp "🌈 Do you want to install icon fonts? [y/N]: " ICONS_YES
if [[ "$ICONS_YES" =~ ^[Yy]$ ]]; then
    echo
    echo "📥 Installing icon fonts..."
    mkdir -p ~/.local/share/fonts/icons

    echo "  • Downloading Font Awesome Free..."
    wget -qO /tmp/fontawesome.zip \
        https://github.com/FortAwesome/Font-Awesome/releases/latest/download/fontawesome-free-6.5.2-desktop.zip
    unzip -qo /tmp/fontawesome.zip -d ~/.local/share/fonts/icons

    echo "  • Downloading Material Design Icons..."
    wget -qO /tmp/material-icons.zip \
        https://github.com/google/material-design-icons/releases/download/3.0.1/material-design-icons-3.0.1.zip
    unzip -qo /tmp/material-icons.zip -d ~/.local/share/fonts/icons

    echo "🔄 Refreshing font cache..."
    fc-cache -fv
    echo "✅ Icon fonts installed!"
else
    echo
    echo "⏭️  Skipping icon fonts."
fi

# Final banner
clear
figlet -f big -w 200 "DONE"
echo "🎉 All done!"
