#!/bin/bash

install_packages() {
    local os="$1"; shift
    local pkgs=( "$@" )

    # Debian-family needs the unstable neovim PPA for >=0.10
    if [[ "$os" =~ ^(ubuntu|debian|mint|popos|kali|xubuntu|kubuntu|lubuntu)$ ]]; then
        echo "🔧 Ensuring Neovim ≥0.10 via PPA…"
        sudo add-apt-repository -y ppa:neovim-ppa/unstable
        sudo apt-get update
    fi

    echo "📦 Installing on $os: ${pkgs[*]}"

    case "$os" in
        arch|manjaro|antergos|parabola|endeavouros|chakra)
            sudo pacman -Sy --noconfirm "${pkgs[@]}";;
        ubuntu|debian|mint|popos|kali|xubuntu|kubuntu|lubuntu)
            sudo apt update && sudo apt install -y "${pkgs[@]}";;
        fedora|centos|rhel|oracle)
            sudo dnf install -y "${pkgs[@]}";;
        opensuse|suse|sles)
            sudo zypper install -y "${pkgs[@]}";;
        solus)
            sudo eopkg install -y "${pkgs[@]}";;
        gentoo)
            sudo emerge -av "${pkgs[@]}";;
        void)
            sudo xbps-install -Sy "${pkgs[@]}";;
        alpine)
            sudo apk add "${pkgs[@]}";;
        *)
            echo "OS '$os' not supported for auto-install";;
    esac
}
