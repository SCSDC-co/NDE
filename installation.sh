#!/usr/bin/env bash

# Neovim Development Environment Setup Script
# Description: Automated installer for Neovim development dependencies with kitty terminal support
# Author: Giuliano
# Version: 3.0
# Last Modified: $(date '+%Y-%m-%d')
# Platforms: Linux, macOS, Windows (WSL/GitBash/MSYS2)

set -euo pipefail  # Exit on error, undefined vars, and pipe failures

# Configuration
readonly SCRIPT_NAME="$(basename "$0")"
readonly LOG_FILE="/tmp/nvim-setup-$(date +%Y%m%d-%H%M%S).log"
readonly TEMP_DIR="$(mktemp -d)"

# Platform detection
detect_platform() {
    case "$(uname -s)" in
        Linux*)
            if [[ -n "${WSL_DISTRO_NAME:-}" ]] || grep -qi microsoft /proc/version 2>/dev/null; then
                echo "wsl"
            else
                echo "linux"
            fi
            ;;
        Darwin*) echo "macos" ;;
        CYGWIN*|MINGW*|MSYS*) echo "windows" ;;
        *) echo "unknown" ;;
    esac
}

readonly PLATFORM="$(detect_platform)"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Trap to cleanup on exit
trap 'cleanup' EXIT

cleanup() {
    local exit_code=$?
    if [[ -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
    if [[ $exit_code -ne 0 ]]; then
        log_error "Installation failed. Check log: $LOG_FILE"
    fi
    exit $exit_code
}

# Logging functions
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE" >&2
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should not be run as root"
        exit 1
    fi
}

# Display banner
show_banner() {
    clear
    if command -v figlet &>/dev/null; then
        figlet -f big -w 200 "NVIM SETUP"
    else
        echo "================================================"
        echo "       NEOVIM DEVELOPMENT SETUP"
        echo "================================================"
    fi
    echo
    log_info "Starting Neovim development environment setup"
    log_info "Log file: $LOG_FILE"
    echo
}

# Detect package manager
detect_package_manager() {
    case "$PLATFORM" in
        macos)
            if command -v brew >/dev/null; then
                echo "brew"
                return 0
            elif command -v port >/dev/null; then
                echo "port"
                return 0
            fi
            ;;
        windows)
            if command -v choco >/dev/null; then
                echo "choco"
                return 0
            elif command -v winget >/dev/null; then
                echo "winget"
                return 0
            fi
            ;;
        linux|wsl)
            if [[ -f /etc/os-release ]]; then
                local os_id
                os_id="$(grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')"
                
                case "$os_id" in
                    arch|manjaro|endeavouros|artix)
                        if command -v pacman >/dev/null; then
                            echo "pacman"
                            return 0
                        fi
                        ;;
                    ubuntu|debian|mint|pop|elementary)
                        if command -v apt >/dev/null; then
                            echo "apt"
                            return 0
                        fi
                        ;;
                    fedora|rhel|centos|rocky|alma)
                        if command -v dnf >/dev/null; then
                            echo "dnf"
                            return 0
                        fi
                        ;;
                    opensuse*|sles)
                        if command -v zypper >/dev/null; then
                            echo "zypper"
                            return 0
                        fi
                        ;;
                    gentoo)
                        if command -v emerge >/dev/null; then
                            echo "emerge"
                            return 0
                        fi
                        ;;
                esac
            fi
            ;;
    esac
    
    # Fallback to checking for available package managers
    local managers=("brew" "port" "choco" "winget" "pacman" "apt" "dnf" "zypper" "emerge")
    
    for manager in "${managers[@]}"; do
        if command -v "$manager" &>/dev/null; then
            echo "$manager"
            return 0
        fi
    done
    
    echo "unknown"
    return 1
}

# Install figlet if needed
install_figlet() {
    if command -v figlet &>/dev/null; then
        return 0
    fi
    
    log_info "Installing figlet for better output formatting"
    local pkg_manager="$1"
    
    case "$pkg_manager" in
        apt)    sudo apt update && sudo apt install -y figlet ;;
        pacman) sudo pacman -Syu --noconfirm figlet ;;
        dnf)    sudo dnf install -y figlet ;;
        zypper) sudo zypper install -y figlet ;;
        emerge) sudo emerge figlet ;;
        brew)   brew install figlet ;;
        port)   sudo port install figlet ;;
        choco)  choco install figlet ;;
        winget) winget install figlet ;;
        *)
            log_warning "Cannot install figlet: unsupported package manager"
            return 1
            ;;
    esac
    
    log_success "Figlet installed successfully"
}

# Generic package installation function
install_system_package() {
    local binary="$1"
    local package="$2"
    local display_name="$3"
    local pkg_manager="$4"
    
    log_info "Checking: $display_name"
    
    if command -v "$binary" &>/dev/null; then
        log_success "$display_name already installed"
        return 0
    fi
    
    log_info "Installing: $display_name"
    
    case "$pkg_manager" in
        apt)
            if [[ "$package" == "dotnet-sdk" ]]; then
                install_dotnet_apt
            else
                sudo apt update && sudo apt install -y "$package"
            fi
            ;;
        pacman) 
            sudo pacman -Syu --noconfirm "$package"
            ;;
        dnf)
            if [[ "$package" == "dotnet-sdk" ]]; then
                sudo dnf install -y dotnet-sdk-8.0
            else
                sudo dnf install -y "$package"
            fi
            ;;
        zypper) 
            sudo zypper install -y "$package"
            ;;
        emerge) 
            sudo emerge "$package"
            ;;
        brew)
            if [[ "$package" == "dotnet-sdk" ]]; then
                brew install --cask dotnet-sdk
            else
                brew install "$package"
            fi
            ;;
        port)
            sudo port install "$package"
            ;;
        choco)
            choco install "$package" -y
            ;;
        winget)
            winget install "$package"
            ;;
        *)
            log_error "Unsupported package manager: $pkg_manager"
            return 1
            ;;
    esac
    
    if command -v "$binary" &>/dev/null; then
        log_success "$display_name installed successfully"
    else
        log_error "Failed to install $display_name"
        return 1
    fi
}

# Special .NET installation for Ubuntu/Debian
install_dotnet_apt() {
    local temp_deb="$TEMP_DIR/msprod.deb"
    
    log_info "Installing Microsoft package repository"
    wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O "$temp_deb"
    sudo dpkg -i "$temp_deb"
    sudo apt update
    sudo apt install -y dotnet-sdk-8.0
}

# Check if Nerd Font is installed
check_nerd_font() {
    case "$PLATFORM" in
        linux|wsl)
            fc-list 2>/dev/null | grep -qi "nerd font"
            ;;
        macos)
            fc-list 2>/dev/null | grep -qi "nerd font" || system_profiler SPFontsDataType 2>/dev/null | grep -qi "nerd"
            ;;
        windows)
            powershell.exe -Command "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' | Select-Object -Property PSChildName | Where-Object { \$_.PSChildName -like '*Nerd*' }" 2>/dev/null | grep -qi "nerd"
            ;;
        *)
            return 1
            ;;
    esac
}

# Install Nerd Font
install_nerd_font() {
    if check_nerd_font; then
        log_success "Nerd Font already installed"
        return 0
    fi
    
    log_info "Nerd Font not detected. Installing..."
    
    echo "Available Nerd Fonts:"
    echo "  1) FiraCode Nerd Font (Recommended)"
    echo "  2) JetBrainsMono Nerd Font"
    echo "  3) Skip font installation"
    
    while true; do
        read -rp "Select option [1-3]: " font_choice
        case "$font_choice" in
            1) install_specific_nerd_font "FiraCode"; break ;;
            2) install_specific_nerd_font "JetBrainsMono"; break ;;
            3) log_info "Skipping font installation"; return 0 ;;
            *) echo "Invalid choice. Please select 1, 2, or 3." ;;
        esac
    done
}

# Install specific Nerd Font
install_specific_nerd_font() {
    local font_name="$1"
    local font_zip="$TEMP_DIR/${font_name}.zip"
    local download_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font_name}.zip"
    
    case "$PLATFORM" in
        linux|wsl)
            local font_dir="$HOME/.local/share/fonts/$font_name"
            ;;
        macos)
            local font_dir="$HOME/Library/Fonts"
            ;;
        windows)
            local font_dir="$HOME/AppData/Local/Microsoft/Windows/Fonts"
            ;;
    esac
    
    log_info "Downloading $font_name Nerd Font"
    
    if ! wget -q "$download_url" -O "$font_zip"; then
        log_error "Failed to download $font_name"
        return 1
    fi
    
    log_info "Installing $font_name"
    mkdir -p "$font_dir"
    
    if ! unzip -qo "$font_zip" -d "$font_dir"; then
        log_error "Failed to extract $font_name"
        return 1
    fi
    
    log_info "Updating font cache"
    case "$PLATFORM" in
        linux|wsl)
            fc-cache -fv &>/dev/null
            ;;
        macos)
            # macOS handles font registration automatically
            ;;
        windows)
            # Windows handles font registration automatically
            ;;
    esac
    
    log_success "$font_name Nerd Font installed successfully"
}

# Install npm package globally
install_npm_package() {
    local package="$1"
    
    log_info "Checking npm package: $package"
    
    if npm list -g "$package" &>/dev/null; then
        log_success "$package already installed"
        return 0
    fi
    
    log_info "Installing npm package: $package"
    
    if sudo npm install -g "$package"; then
        log_success "$package installed successfully"
    else
        log_error "Failed to install $package"
        return 1
    fi
}

# Install and configure pipx
setup_pipx() {
    local pkg_manager="$1"
    
    if command -v pipx &>/dev/null; then
        log_success "pipx already installed"
        return 0
    fi
    
    log_info "Installing pipx"
    
    case "$pkg_manager" in
        apt)    sudo apt update && sudo apt install -y pipx python3-venv ;;
        pacman) sudo pacman -Syu --noconfirm python-pipx ;;
        dnf)    sudo dnf install -y python3-pipx ;;
        zypper) sudo zypper install -y python3-pipx ;;
        emerge) sudo emerge dev-python/pipx ;;
        brew)   brew install pipx ;;
        port)   sudo port install py-pipx ;;
        *)
            log_error "Unsupported package manager for pipx: $pkg_manager"
            return 1
            ;;
    esac
    
    # Ensure pipx is in PATH
    export PATH="$HOME/.local/bin:$PATH"
    
    if command -v pipx &>/dev/null; then
        log_success "pipx installed successfully"
    else
        log_error "Failed to install pipx"
        return 1
    fi
}

# Install Python LSP server via pipx
install_python_lsp() {
    log_info "Checking python-lsp-server"
    
    if pipx list 2>/dev/null | grep -q python-lsp-server; then
        log_success "python-lsp-server already installed"
        return 0
    fi
    
    log_info "Installing python-lsp-server via pipx"
    
    if pipx install python-lsp-server --system-site-packages --pip-args="--break-system-packages"; then
        log_success "python-lsp-server installed successfully"
    else
        log_error "Failed to install python-lsp-server"
        return 1
    fi
}

# Install Rust toolchain
install_rust() {
    if command -v rustup &>/dev/null; then
        log_success "Rust toolchain already installed"
        return 0
    fi
    
    log_info "Installing Rust toolchain"
    
    if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; then
        # Update PATH for current session
        export PATH="$HOME/.cargo/bin:$PATH"
        
        # Update shell configuration
        update_shell_path
        
        log_success "Rust toolchain installed successfully"
    else
        log_error "Failed to install Rust toolchain"
        return 1
    fi
}

# Update shell configuration with Cargo path
update_shell_path() {
    local shell_name
    local rc_file
    
    shell_name="$(basename "$SHELL")"
    
    case "$shell_name" in
        zsh)  rc_file="$HOME/.zshrc" ;;
        bash) rc_file="$HOME/.bashrc" ;;
        fish) rc_file="$HOME/.config/fish/config.fish" ;;
        *)    rc_file="$HOME/.profile" ;;
    esac
    
    if ! grep -q 'cargo/bin' "$rc_file" 2>/dev/null; then
        echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$rc_file"
        log_info "Updated PATH in $rc_file"
    fi
}

# Ask user if they want to install kitty terminal
ask_kitty_installation() {
    echo
    echo "================================================"
    echo "              KITTY TERMINAL SETUP"
    echo "================================================"
    echo
    
    while true; do
        read -rp "Do you want to install and configure the kitty terminal? [y/n]: " kitty_choice
        case "$kitty_choice" in
            [Yy]*) install_kitty_terminal; break ;;
            [Nn]*) log_info "Skipping kitty terminal installation"; return 0 ;;
            *) echo "Please answer yes or no." ;;
        esac
    done
}

# Install kitty terminal
install_kitty_terminal() {
    log_info "Checking if kitty is already installed"
    
    if command -v kitty &>/dev/null; then
        log_success "Kitty terminal already installed"
    else
        log_info "Installing kitty terminal"
        
        case "$PLATFORM" in
            linux|wsl)
                case "$pkg_manager" in
                    apt)    sudo apt update && sudo apt install -y kitty ;;
                    pacman) sudo pacman -Syu --noconfirm kitty ;;
                    dnf)    sudo dnf install -y kitty ;;
                    zypper) sudo zypper install -y kitty ;;
                    emerge) sudo emerge kitty ;;
                    *) log_error "Unsupported package manager for kitty: $pkg_manager"; return 1 ;;
                esac
                ;;
            macos)
                case "$pkg_manager" in
                    brew) brew install --cask kitty ;;
                    port) sudo port install kitty ;;
                    *) log_error "Unsupported package manager for kitty: $pkg_manager"; return 1 ;;
                esac
                ;;
            windows)
                case "$pkg_manager" in
                    choco) choco install kitty -y ;;
                    winget) winget install kitty ;;
                    *) log_error "Unsupported package manager for kitty: $pkg_manager"; return 1 ;;
                esac
                ;;
            *)
                log_error "Unsupported platform for kitty installation: $PLATFORM"
                return 1
                ;;
        esac
        
        if command -v kitty &>/dev/null; then
            log_success "Kitty terminal installed successfully"
        else
            log_error "Failed to install kitty terminal"
            return 1
        fi
    fi
    
    configure_kitty
}

# Configure kitty terminal
configure_kitty() {
    local kitty_config_dir
    
    case "$PLATFORM" in
        linux|wsl|macos)
            kitty_config_dir="$HOME/.config/kitty"
            ;;
        windows)
            kitty_config_dir="$HOME/AppData/Roaming/kitty"
            ;;
    esac
    
    mkdir -p "$kitty_config_dir"
    
    log_info "Generating kitty configuration"
    
    # Choose font
    local chosen_font
    echo
    echo "Choose a font for kitty:"
    echo "  1) FiraCode Nerd Font (Recommended)"
    echo "  2) JetBrainsMono Nerd Font"
    echo "  3) Use system default"
    
    while true; do
        read -rp "Select font option [1-3]: " font_choice
        case "$font_choice" in
            1) chosen_font="FiraCode Nerd Font Mono"; break ;;
            2) chosen_font="JetBrainsMono Nerd Font Mono"; break ;;
            3) chosen_font="monospace"; break ;;
            *) echo "Invalid choice. Please select 1, 2, or 3." ;;
        esac
    done
    
    # Create kitty.conf
    create_kitty_config "$kitty_config_dir" "$chosen_font"
    
    # Ask about kanagawa theme
    echo
    while true; do
        read -rp "Do you want to install the Kanagawa theme? [y/n]: " theme_choice
        case "$theme_choice" in
            [Yy]*) install_kanagawa_theme "$kitty_config_dir"; break ;;
            [Nn]*) log_info "Skipping Kanagawa theme installation"; break ;;
            *) echo "Please answer yes or no." ;;
        esac
    done
    
    log_success "Kitty terminal configured successfully!"
    log_info "Configuration location: $kitty_config_dir"
}

# Create kitty configuration file
create_kitty_config() {
    local config_dir="$1"
    local font_family="$2"
    local config_file="$config_dir/kitty.conf"
    
    cat > "$config_file" << EOF
# Font configuration
font_family $font_family
bold_font $font_family Bold
italic_font $font_family Italic
bold_italic_font $font_family Bold Italic
enable_ligatures yes

# Font features (FiraCode specific)
font_features FiraCode-Regular +ss01 +ss02 +ss03 +ss04 +ss05 +ss07 +ss08 +zero +onum

# Symbol mappings (FiraCode specific)
symbol_map U+0040-U+0040 use_ss01
symbol_map U+0026-U+0026 use_ss03
symbol_map U+0028-U+0029 use_ss01
symbol_map U+0072-U+0072 use_ss04
symbol_map U+007B-U+007D use_ss05
symbol_map U+0028-U+0029 use_ss06
symbol_map U+0028-U+0029 use_ss01

# Font size
font_size 12

# Include theme (loaded first so aesthetics can override)
include kanagawa.conf

# Aesthetic settings (these will override theme settings)
background_opacity 0.7
background #000000
enable_true_color yes
EOF
    
    log_success "Created kitty.conf at $config_file"
}

# Install Kanagawa theme
install_kanagawa_theme() {
    local config_dir="$1"
    local theme_file="$config_dir/kanagawa.conf"
    
    log_info "Creating Kanagawa theme configuration"
    
    cat > "$theme_file" << EOF
# vim:ft=kitty

## name: Kanagawa_dragon
## license: MIT
## author: Tommaso Laurenzi
## upstream: https://github.com/rebelot/kanagawa.nvim/

background #181616
foreground #c5c9c5
selection_background #2D4F67
selection_foreground #C8C093
url_color #72A7BC
cursor #C8C093

# Tabs
active_tab_background #12120f
active_tab_foreground #C8C093
inactive_tab_background  #12120f
inactive_tab_foreground #a6a69c
#tab_bar_background #15161E

# normal
color0 #0d0c0c
color1 #c4746e
color2 #8a9a7b
color3 #c4b28a
color4 #8ba4b0
color5 #a292a3
color6 #8ea4a2
color7 #C8C093

# bright
color8  #a6a69c
color9  #E46876
color10 #87a987
color11 #E6C384
color12 #7FB4CA
color13 #938AA9
color14 #7AA89F
color15 #c5c9c5

# extended colors
color16 #b6927b
color17 #b98d7b
EOF
    
    log_success "Created Kanagawa theme at $theme_file"
}

# Install development tools (ripgrep, fd, lazygit, etc.)
install_dev_tools() {
    local pkg_manager="$1"
    
    log_info "Installing additional development tools"
    
    # Essential tools for telescope and file operations
    declare -A dev_tools
    case "$PLATFORM" in
        linux|wsl)
            dev_tools=(
                ["rg"]="ripgrep:Ripgrep (fast search)"
                ["fd"]="fd-find:fd (fast find)"
                ["lazygit"]="lazygit:Lazygit (git TUI)"
                ["git"]="git:Git"
                ["curl"]="curl:cURL"
                ["tree"]="tree:Tree (directory listing)"
                ["jq"]="jq:jq (JSON processor)"
            )
            ;;
        macos)
            dev_tools=(
                ["rg"]="ripgrep:Ripgrep (fast search)"
                ["fd"]="fd:fd (fast find)"
                ["lazygit"]="lazygit:Lazygit (git TUI)"
                ["git"]="git:Git"
                ["curl"]="curl:cURL"
                ["tree"]="tree:Tree (directory listing)"
                ["jq"]="jq:jq (JSON processor)"
            )
            ;;
        windows)
            dev_tools=(
                ["rg"]="ripgrep:Ripgrep (fast search)"
                ["fd"]="fd:fd (fast find)"
                ["lazygit"]="lazygit:Lazygit (git TUI)"
                ["git"]="git:Git"
                ["curl"]="curl:cURL"
                ["jq"]="jq:jq (JSON processor)"
            )
            ;;
    esac
    
    for binary in "${!dev_tools[@]}"; do
        IFS=':' read -r package display_name <<<"${dev_tools[$binary]}"
        install_system_package "$binary" "$package" "$display_name" "$pkg_manager" || true
    done
}

# Install formatters and linters
install_formatters_linters() {
    local pkg_manager="$1"
    
    log_info "Installing formatters and linters"
    
    # System-level formatters and linters
    declare -A system_tools
    case "$PLATFORM" in
        linux|wsl)
            system_tools=(
                ["black"]="python3-black:Black (Python formatter)"
                ["clang-format"]="clang-format:Clang-format (C/C++ formatter)"
                ["prettier"]="prettier:Prettier (JS/TS/HTML/CSS formatter)"
                ["eslint"]="eslint:ESLint (JS/TS linter)"
                ["flake8"]="flake8:Flake8 (Python linter)"
                ["luacheck"]="luacheck:Luacheck (Lua linter)"
                ["stylelint"]="stylelint:Stylelint (CSS linter)"
                ["tidy"]="tidy:HTML Tidy (HTML linter)"
            )
            ;;
        macos)
            system_tools=(
                ["black"]="black:Black (Python formatter)"
                ["clang-format"]="clang-format:Clang-format (C/C++ formatter)"
                ["prettier"]="prettier:Prettier (JS/TS/HTML/CSS formatter)"
                ["eslint"]="eslint:ESLint (JS/TS linter)"
                ["flake8"]="flake8:Flake8 (Python linter)"
                ["luacheck"]="luacheck:Luacheck (Lua linter)"
                ["stylelint"]="stylelint:Stylelint (CSS linter)"
                ["tidy-html5"]="tidy-html5:HTML Tidy (HTML linter)"
            )
            ;;
        windows)
            system_tools=(
                ["black"]="black:Black (Python formatter)"
                ["prettier"]="prettier:Prettier (JS/TS/HTML/CSS formatter)"
                ["eslint"]="eslint:ESLint (JS/TS linter)"
                ["flake8"]="flake8:Flake8 (Python linter)"
            )
            ;;
    esac
    
    # Install system packages first
    for binary in "${!system_tools[@]}"; do
        IFS=':' read -r package display_name <<<"${system_tools[$binary]}"
        install_system_package "$binary" "$package" "$display_name" "$pkg_manager" || true
    done
    
    # Install npm-based tools
    local npm_formatters=("prettier" "eslint" "stylelint")
    for tool in "${npm_formatters[@]}"; do
        if ! command -v "$tool" &>/dev/null; then
            install_npm_package "$tool" || true
        fi
    done
    
    # Install Python-based tools via pip
    if command -v pip3 &>/dev/null; then
        local python_tools=("black" "flake8")
        for tool in "${python_tools[@]}"; do
            if ! command -v "$tool" &>/dev/null; then
                log_info "Installing $tool via pip3"
                pip3 install --user "$tool" || true
            fi
        done
    fi
    
    # Install asmfmt for assembly formatting
    if command -v go &>/dev/null && ! command -v asmfmt &>/dev/null; then
        log_info "Installing asmfmt via go"
        go install github.com/klauspost/asmfmt/cmd/asmfmt@latest || true
    fi
    
    # Install clangtidy (separate from clang-format)
    case "$pkg_manager" in
        apt)    install_system_package "clang-tidy" "clang-tidy" "Clang-tidy (C/C++ linter)" "$pkg_manager" || true ;;
        pacman) install_system_package "clang-tidy" "clang" "Clang-tidy (C/C++ linter)" "$pkg_manager" || true ;;
        dnf)    install_system_package "clang-tidy" "clang-tools-extra" "Clang-tidy (C/C++ linter)" "$pkg_manager" || true ;;
        zypper) install_system_package "clang-tidy" "clang-tools" "Clang-tidy (C/C++ linter)" "$pkg_manager" || true ;;
        emerge) install_system_package "clang-tidy" "clang" "Clang-tidy (C/C++ linter)" "$pkg_manager" || true ;;
        brew)   install_system_package "clang-tidy" "llvm" "Clang-tidy (C/C++ linter)" "$pkg_manager" || true ;;
        port)   install_system_package "clang-tidy" "clang-tools-extra" "Clang-tidy (C/C++ linter)" "$pkg_manager" || true ;;
        *) log_warning "Clang-tidy installation not supported for $pkg_manager" ;;
    esac
}

# Install debugging tools
install_debug_tools() {
    local pkg_manager="$1"
    
    log_info "Installing debugging tools"
    
    # Debugging tools needed for nvim-dap
    declare -A debug_tools
    case "$PLATFORM" in
        linux|wsl)
            debug_tools=(
                ["gdb"]="gdb:GDB (GNU Debugger)"
                ["lldb"]="lldb:LLDB (LLVM Debugger)"
            )
            ;;
        macos)
            debug_tools=(
                ["gdb"]="gdb:GDB (GNU Debugger)"
                ["lldb"]="lldb:LLDB (LLVM Debugger)"
            )
            ;;
        windows)
            debug_tools=(
                ["gdb"]="gdb:GDB (GNU Debugger)"
            )
            ;;
    esac
    
    for binary in "${debug_tools[@]}"; do
        IFS=':' read -r package display_name <<<"${debug_tools[$binary]}"
        install_system_package "$binary" "$package" "$display_name" "$pkg_manager" || true
    done
    
    # Install Go if not present (needed for some language servers)
    if ! command -v go &>/dev/null; then
        log_info "Installing Go programming language"
        case "$pkg_manager" in
            apt)    install_system_package "go" "golang-go" "Go programming language" "$pkg_manager" || true ;;
            pacman) install_system_package "go" "go" "Go programming language" "$pkg_manager" || true ;;
            dnf)    install_system_package "go" "golang" "Go programming language" "$pkg_manager" || true ;;
            zypper) install_system_package "go" "go" "Go programming language" "$pkg_manager" || true ;;
            emerge) install_system_package "go" "dev-lang/go" "Go programming language" "$pkg_manager" || true ;;
            brew)   install_system_package "go" "go" "Go programming language" "$pkg_manager" || true ;;
            port)   install_system_package "go" "go" "Go programming language" "$pkg_manager" || true ;;
            choco)  install_system_package "go" "golang" "Go programming language" "$pkg_manager" || true ;;
            winget) install_system_package "go" "GoLang.Go" "Go programming language" "$pkg_manager" || true ;;
            *) log_warning "Go installation not supported for $pkg_manager" ;;
        esac
    fi
}

# Check Neovim version
check_neovim_version() {
    if ! command -v nvim &>/dev/null; then
        return 1  # Not installed
    fi
    
    local version
    version=$(nvim --version | head -n1 | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | sed 's/v//')
    
    if [[ -z "$version" ]]; then
        log_warning "Could not detect Neovim version"
        return 1
    fi
    
    log_info "Detected Neovim version: $version"
    
    # Check if version is 0.10.0 or higher
    if version_compare "$version" "0.10.0"; then
        log_success "Neovim version $version is compatible (>=0.10.0)"
        return 0
    else
        log_warning "Neovim version $version is too old (requires >=0.10.0)"
        return 1
    fi
}

# Compare version strings (returns 0 if first >= second)
version_compare() {
    local version1="$1"
    local version2="$2"
    
    # Convert versions to comparable integers
    local v1=$(echo "$version1" | awk -F. '{printf "%d%03d%03d", $1, $2, $3}')
    local v2=$(echo "$version2" | awk -F. '{printf "%d%03d%03d", $1, $2, $3}')
    
    [[ $v1 -ge $v2 ]]
}

# Install Neovim 0.10+ with proper repositories
install_neovim() {
    local pkg_manager="$1"
    
    # Check if we already have a compatible version
    if check_neovim_version; then
        return 0
    fi
    
    local has_neovim=false
    if command -v nvim &>/dev/null; then
        has_neovim=true
        log_info "Neovim is installed but version is too old, updating..."
    else
        log_info "Installing Neovim 0.10+"
    fi
    
    case "$pkg_manager" in
        apt)
            install_neovim_apt "$has_neovim"
            ;;
        pacman)
            # Arch usually has latest versions
            install_system_package "nvim" "neovim" "Neovim" "$pkg_manager"
            ;;
        dnf)
            # Fedora usually has recent versions, but check if we need COPR
            install_neovim_dnf "$has_neovim"
            ;;
        zypper)
            # openSUSE might need additional repos
            install_neovim_zypper "$has_neovim"
            ;;
        emerge)
            # Gentoo usually has latest
            install_system_package "nvim" "app-editors/neovim" "Neovim" "$pkg_manager"
            ;;
        brew)
            # Homebrew usually has latest
            install_system_package "nvim" "neovim" "Neovim" "$pkg_manager"
            ;;
        port)
            install_system_package "nvim" "neovim" "Neovim" "$pkg_manager"
            ;;
        choco)
            install_system_package "nvim" "neovim" "Neovim" "$pkg_manager"
            ;;
        winget)
            install_system_package "nvim" "Neovim.Neovim" "Neovim" "$pkg_manager"
            ;;
        *)
            log_error "Neovim installation not supported for $pkg_manager"
            return 1
            ;;
    esac
    
    # Verify installation
    if check_neovim_version; then
        log_success "Neovim 0.10+ installed successfully"
    else
        log_error "Failed to install compatible Neovim version"
        return 1
    fi
}

# Install Neovim for apt-based systems
install_neovim_apt() {
    local has_neovim="$1"
    
    log_info "Setting up Neovim PPA for latest version"
    
    # Add the unstable PPA for latest Neovim
    if ! grep -q "neovim-ppa/unstable" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; then
        sudo add-apt-repository ppa:neovim-ppa/unstable -y
        sudo apt-get update
    fi
    
    if [[ "$has_neovim" == "true" ]]; then
        log_info "Updating Neovim to latest version"
        sudo apt-get install --only-upgrade neovim -y
    else
        log_info "Installing Neovim from PPA"
        sudo apt-get install neovim -y
    fi
}

# Install Neovim for dnf-based systems (Fedora/RHEL)
install_neovim_dnf() {
    local has_neovim="$1"
    
    # Try standard repo first
    if [[ "$has_neovim" == "true" ]]; then
        sudo dnf upgrade neovim -y
    else
        sudo dnf install neovim -y
    fi
    
    # Check if version is still too old
    if ! check_neovim_version &>/dev/null; then
        log_info "Standard repo has old version, trying COPR"
        sudo dnf copr enable agriffis/neovim-nightly -y
        if [[ "$has_neovim" == "true" ]]; then
            sudo dnf upgrade neovim -y
        else
            sudo dnf install neovim -y
        fi
    fi
}

# Install Neovim for zypper-based systems (openSUSE)
install_neovim_zypper() {
    local has_neovim="$1"
    
    # Try standard repo first
    if [[ "$has_neovim" == "true" ]]; then
        sudo zypper update neovim -y
    else
        sudo zypper install neovim -y
    fi
    
    # Check if version is still too old
    if ! check_neovim_version &>/dev/null; then
        log_warning "Standard repo has old Neovim version"
        log_info "You may need to add a newer repository or build from source"
        log_info "Consider using the AppImage or building from source"
    fi
}

# Main installation function
main() {
    local pkg_manager
    local failed_packages=()
    
    # Initial checks
    check_root
    
    log_info "Detected platform: $PLATFORM"
    
    # Detect package manager
    pkg_manager="$(detect_package_manager)"
    if [[ "$pkg_manager" == "unknown" ]]; then
        case "$PLATFORM" in
            linux|wsl)
                log_error "Unsupported package manager. This script supports: apt, pacman, dnf, zypper, emerge"
                ;;
            macos)
                log_error "No package manager found. Please install Homebrew or MacPorts"
                ;;
            windows)
                log_error "No package manager found. Please install Chocolatey or use Windows Package Manager"
                ;;
            *)
                log_error "Unsupported platform: $PLATFORM"
                ;;
        esac
        exit 1
    fi
    
    log_info "Detected package manager: $pkg_manager"
    
    # Install figlet for better output
    install_figlet "$pkg_manager" || log_warning "Could not install figlet"
    
    # Install Neovim 0.10+ first
    install_neovim "$pkg_manager" || failed_packages+=("Neovim 0.10+")
    
    # Show banner
    show_banner
    
    # Install core dependencies
    log_info "Installing core system packages"
    
    declare -A core_packages
    case "$PLATFORM" in
        linux|wsl)
            core_packages=(
                ["wget"]="wget:Wget"
                ["unzip"]="unzip:Unzip"
                ["node"]="nodejs:Node.js"
                ["npm"]="npm:npm"
                ["python3"]="python3:Python 3"
                ["pip3"]="python3-pip:pip"
                ["dotnet"]="dotnet-sdk:.NET SDK"
                ["clangd"]="clangd:Clangd (C/C++)"
            )
            ;;
        macos)
            core_packages=(
                ["wget"]="wget:Wget"
                ["unzip"]="unzip:Unzip"
                ["node"]="node:Node.js"
                ["npm"]="npm:npm"
                ["python3"]="python3:Python 3"
                ["pip3"]="python3:pip"
                ["dotnet"]="dotnet-sdk:.NET SDK"
                ["clangd"]="llvm:Clangd (C/C++)"
            )
            ;;
        windows)
            core_packages=(
                ["wget"]="wget:Wget"
                ["unzip"]="unzip:Unzip"
                ["node"]="nodejs:Node.js"
                ["npm"]="npm:npm"
                ["python3"]="python3:Python 3"
                ["pip3"]="python3:pip"
                ["dotnet"]="dotnet-sdk:.NET SDK"
                ["clangd"]="llvm:Clangd (C/C++)"
            )
            ;;
    esac
    
    for binary in "${!core_packages[@]}"; do
        IFS=':' read -r package display_name <<< "${core_packages[$binary]}"
        if ! install_system_package "$binary" "$package" "$display_name" "$pkg_manager"; then
            failed_packages+=("$display_name")
        fi
    done
    
    # Install Nerd Font
    install_nerd_font
    
    # Install npm packages
    log_info "Installing npm language servers"
    local npm_packages=("pyright" "vscode-langservers-extracted" "bash-language-server" "typescript-language-server")
    
    for package in "${npm_packages[@]}"; do
        if ! install_npm_package "$package"; then
            failed_packages+=("$package (npm)")
        fi
    done
    
    # Setup pipx and Python LSP (Linux/macOS only)
    if [[ "$PLATFORM" != "windows" ]]; then
        if setup_pipx "$pkg_manager"; then
            install_python_lsp || failed_packages+=("python-lsp-server")
        else
            failed_packages+=("pipx")
        fi
    fi
    
    # Install Rust
    install_rust || failed_packages+=("Rust toolchain")
    
    # Install additional development tools
    install_dev_tools "$pkg_manager" || failed_packages+=("Development tools")
    
    # Install formatters and linters
    install_formatters_linters "$pkg_manager" || failed_packages+=("Formatters/Linters")
    
    # Install debugging tools
    install_debug_tools "$pkg_manager" || failed_packages+=("Debug tools")
    
    # Ask about kitty terminal installation
    ask_kitty_installation
    
    # Summary
    echo
    if command -v figlet &>/dev/null; then
        figlet -f big -w 200 "COMPLETE"
    else
        echo "================================================"
        echo "              SETUP COMPLETE"
        echo "================================================"
    fi
    
    echo
    log_success "Neovim development environment setup completed!"
    
    echo
    log_info "Next steps:"
    echo "  1. Verify Neovim version: nvim --version"
    echo "  2. Start Neovim: nvim"
    echo "  3. Run ':Lazy sync' to install plugins"
    echo "  4. Run ':Mason' to verify language servers"
    echo "  5. Restart Neovim to apply all configurations"
    
    if [[ ${#failed_packages[@]} -gt 0 ]]; then
        log_warning "Some packages failed to install:"
        printf '  - %s\n' "${failed_packages[@]}"
        echo
        log_info "Check the log file for details: $LOG_FILE"
    fi
    
    echo
    log_info "Restarting shell to apply PATH changes..."
    exec "$SHELL" -l
}

# Run main function
main "$@"
