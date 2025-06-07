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
        exit 1
    fi
fi

figlet -f big -w 200 "INSTALLATION"
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
    local bin="$1" pkg="$2" name="$3"
    echo
    echo "🔍 Checking: $name"
    if ! command -v "$bin" &>/dev/null; then
        echo "📥 Installing: $name"
        case $PKG_MANAGER in
            apt)
                if [[ "$pkg" == "dotnet-sdk" ]]; then
                    wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O /tmp/msprod.deb
                    sudo dpkg -i /tmp/msprod.deb
                    sudo apt update
                    sudo apt install -y dotnet-sdk-8.0
                else
                    sudo apt update && sudo apt install -y "$pkg"
                fi
                ;;
            pacman) sudo pacman -Syu --noconfirm "$pkg" ;;
            dnf)
                if [[ "$pkg" == "dotnet-sdk" ]]; then
                    sudo dnf install -y dotnet-sdk-8.0
                else
                    sudo dnf install -y "$pkg"
                fi
                ;;
            zypper) sudo zypper install -y "$pkg" ;;
            emerge) sudo emerge "$pkg" ;;
        esac
        echo "✅ $name installed"
    else
        echo "✅ $name already present"
    fi
}

# Nerd Font selection/install
check_nerd_font_installed() {
    fc-list | grep -qi "Nerd Font"
}
install_nerd_font() {
    echo
    echo "🎨 Nerd Font not detected. Installing one now..."
    echo "  1) FiraCode Nerd Font (Recommended)"
    echo "  2) JetBrainsMono Nerd Font"
    read -rp "Select [1/2]: " FONT_CHOICE

    FONT_NAME="FiraCode"
    [[ "$FONT_CHOICE" == "2" ]] && FONT_NAME="JetBrainsMono"

    echo
    echo "💾 Downloading $FONT_NAME..."
    mkdir -p ~/.local/share/fonts/"$FONT_NAME"
    wget -O "/tmp/${FONT_NAME}.zip" \
        "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT_NAME}.zip"
    echo "📂 Extracting..."
    unzip -qo "/tmp/${FONT_NAME}.zip" -d ~/.local/share/fonts/"$FONT_NAME"
    echo "🔄 Updating font cache..."
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

# Core tools
install_package wget            wget               "Wget"
install_package unzip           unzip              "Unzip"
install_package node            nodejs             "Node.js"
install_package npm             npm                "npm"
install_package python3         python3            "Python 3"
install_package pip3            python3-pip        "pip"
install_package python3         python3-venv       "python3-venv"
install_package dotnet          dotnet-sdk         ".NET SDK"
install_package clangd          clangd             "Clangd (C/C++)"

# npm LSPs
npm_install() {
    local pkg="$1"
    echo
    echo "🔍 Checking: $pkg (npm)"
    if ! npm list -g "$pkg" &>/dev/null; then
        echo "📥 Installing: $pkg"
        sudo npm install -g "$pkg"
        echo "✅ $pkg installed"
    else
        echo "✅ $pkg already present"
    fi
}
npm_install pyright
npm_install vscode-langservers-extracted
npm_install bash-language-server

# pipx and python-lsp-server
pipx_check() {
    if command -v pipx &>/dev/null; then
        echo
        echo "✅ pipx already present"
    else
        echo
        echo "📥 Installing pipx"
        case $PKG_MANAGER in
            apt)    sudo apt update && sudo apt install -y pipx python3-venv ;;
            pacman) sudo pacman -Syu --noconfirm pipx ;;
            dnf)    sudo dnf install -y python3-pipx ;;
            zypper) sudo zypper install -y python3-pipx ;;
            emerge) sudo emerge pipx ;;
        esac
        export PATH="$HOME/.local/bin:$PATH"
        echo "✅ pipx installed"
    fi
}
pipx_check

echo
echo "🔍 Checking: python-lsp-server (pipx)"
if ! pipx list | grep -q python-lsp-server; then
    echo "📥 Installing: python-lsp-server"
    pipx install python-lsp-server --system-site-packages --pip-args="--break-system-packages"
    echo "✅ python-lsp-server installed"
else
    echo "✅ python-lsp-server already present"
fi

# Rust
echo
echo "📥 Installing rustup and Cargo"
if ! command -v rustup &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    SHELL_NAME=$(basename "$SHELL")
    case "$SHELL_NAME" in
        zsh)  RC="$HOME/.zshrc" ;;
        bash) RC="$HOME/.bashrc" ;;
        fish) RC="$HOME/.config/fish/config.fish" ;;
        *)     RC="$HOME/.profile" ;;
    esac
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$RC"
    export PATH="$HOME/.cargo/bin:$PATH"
    echo "✅ rustup and Cargo installed; PATH updated in $RC"
else
    echo "✅ rustup already present"
fi

figlet -f big -w 200 "DONE"
echo "🎉 All done!"

echo
echo "🔄 Reloading shell..."
exec "$SHELL" -l
