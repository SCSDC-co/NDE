#!/bin/bash

declare -A pkgs_arch=(
    [figlet]="figlet"
    [nvim]="neovim"
    [lazygit]="lazygit"
    [dotnet]="dotnet-sdk"
    [npm]="npm"
    [pipx]="pipx"
    [python-lsp]="python-language-server"
    [rustup]="rustup"
    [cargo]="cargo"
    [rg]="ripgrep"
    [fd]="fd"
    [git]="git"
    [curl]="curl"
    [tree]="tree"
    [jq]="jq"
    [gdb]="gdb"
    [lldb]="lldb"
    [go]="go"
    [luacheck]="luacheck"
    [black]="python-black"
    [clang-format]="clang-format"
    [prettier]="prettier"
    [eslint]="eslint"
    [flake8]="flake8"
    [stylelint]="stylelint"
    [tidy]="tidy"
    [clang-tidy]="clang-tools-extra"
)

declare -A pkgs_debian=(
    [figlet]="figlet"
    [nvim]="neovim"           
    [lazygit]="lazygit"
    [dotnet]="dotnet-sdk-6.0"
    [npm]="npm"
    [pipx]="pipx"
    [python-lsp]="python3-pylsp"
    [rustup]="rustup"
    [cargo]="cargo"
    [rg]="ripgrep"
    [fd]="fd-find"
    [git]="git"
    [curl]="curl"
    [tree]="tree"
    [jq]="jq"
    [gdb]="gdb"
    [lldb]="lldb"
    [go]="golang"
    [luacheck]="luacheck"
    [black]="python3-black"
    [clang-format]="clang-format"
    [prettier]="prettier"
    [eslint]="eslint"
    [flake8]="flake8"
    [stylelint]="stylelint"
    [tidy]="tidy"
    [clang-tidy]="clang-tidy"
)

declare -A pkgs_fedora=(
    [figlet]="figlet"
    [nvim]="neovim"
    [lazygit]="lazygit"
    [dotnet]="dotnet-sdk-6.0"
    [npm]="npm"
    [pipx]="python3-pipx"
    [python-lsp]="python3-pylsp"
    [rustup]="rustup"
    [cargo]="cargo"
    [rg]="ripgrep"
    [fd]="fd-find"
    [git]="git"
    [curl]="curl"
    [tree]="tree"
    [jq]="jq"
    [gdb]="gdb"
    [lldb]="lldb"
    [go]="golang"
    [luacheck]="luacheck"
    [black]="python3-black"
    [clang-format]="clang-tools-extra"
    [prettier]="prettier"
    [eslint]="eslint"
    [flake8]="python3-flake8"
    [stylelint]="stylelint"
    [tidy]="tidy"
    [clang-tidy]="clang-tools-extra"
)

declare -A pkgs_suse=(
    [figlet]="figlet"
    [nvim]="neovim"
    [lazygit]="lazygit"
    [dotnet]="dotnet-sdk-6.0"
    [npm]="npm"
    [pipx]="python3-pipx"
    [python-lsp]="python3-pylsp"
    [rustup]="rustup"
    [cargo]="cargo"
    # dev_tools
    [rg]="ripgrep"
    [fd]="fd-find"
    [git]="git"
    [curl]="curl"
    [tree]="tree"
    [jq]="jq"
    [gdb]="gdb"
    [lldb]="lldb"
    [go]="golang"
    [luacheck]="luacheck"
    [black]="python3-black"
    [clang-format]="clang-tools-extra"
    [prettier]="prettier"
    [eslint]="eslint"
    [flake8]="python3-flake8"
    [stylelint]="stylelint"
    [tidy]="tidy"
    [clang-tidy]="clang-tools-extra"
)

declare -A pkgs_solus=(
    [figlet]="figlet"
    [nvim]="neovim"
    [lazygit]="lazygit"
    [dotnet]="dotnet-sdk"
    [npm]="npm"
    [pipx]="pipx"
    [python-lsp]="python3-pylsp"
    [rustup]="rustup"
    [cargo]="cargo"
)

resolve_packages() {
    local os="$1"; shift
    local out=()

    for pkg in "$@"; do
        local real
        case "$os" in
            arch|manjaro|antergos|parabola|endeavouros|chakra)
                real="${pkgs_arch[$pkg]:-$pkg}";;
            ubuntu|debian|mint|popos|kali|xubuntu|kubuntu|lubuntu)
                real="${pkgs_debian[$pkg]:-$pkg}";;
            fedora|centos|rhel|oracle)
                real="${pkgs_fedora[$pkg]:-$pkg}";;
            opensuse|suse|sles)
                real="${pkgs_suse[$pkg]:-$pkg}";;
            solus)
                real="${pkgs_solus[$pkg]:-$pkg}";;
            gentoo)
                real="$pkg";;
            void)
                real="$pkg";;
            alpine)
                real="$pkg";;
            *)
                real="$pkg";;
        esac
        out+=("$real")
    done

    echo "${out[@]}"
}
