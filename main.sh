#!/bin/bash

source ./lib/detect_os.sh
source ./lib/package_maps.sh
source ./lib/install_packages.sh

OS=$(detect_os)
if [[ "$OS" == "unknown" ]]; then
    echo "Unsupported or undetectable OS – exiting."
    exit 1
fi

VENV_DIR="$HOME/.local/share/nvim_pytools_venv"
if [[ ! -d "$VENV_DIR" ]]; then
  echo "Creating Python venv at $VENV_DIR"
  python3 -m venv "$VENV_DIR"
fi
source "$VENV_DIR/bin/activate"
echo "Activated Python venv: $VENV_DIR"

generic_pkgs=(
    figlet nvim lazygit dotnet npm pipx python-lsp rustup cargo
    rg fd git curl tree jq
    black clang-format prettier eslint flake8 luacheck stylelint tidy clang-tidy
    gdb lldb go
)

real_pkgs=( $(resolve_packages "$OS" "${generic_pkgs[@]}") )

sys_pkgs=()
py_tools=()

for pkg in "${real_pkgs[@]}"; do
  case "$pkg" in
    python-language-server|pipx|python3-black|python3-pylsp|flake8|luacheck|python3-pipx)
      py_tools+=("$pkg") ;;
    *)
      sys_pkgs+=("$pkg") ;;
  esac
done

install_packages "$OS" "${sys_pkgs[@]}"

echo "Installing Python tools in venv: ${py_tools[*]}"
pip install --upgrade pip
pip install "${py_tools[@]}"

echo "All done! Python tools are sandboxed in $VENV_DIR."

clear

echo "
  _____   ____  _   _ ______ 
 |  __ \ / __ \| \ | |  ____|
 | |  | | |  | |  \| | |__   
 | |  | | |  | | . ` |  __|  
 | |__| | |__| | |\  | |____ 
 |_____/ \____/|_| \_|______|
"

echo "now run \`nvim\`"
echo "then run \`:Mason\`"
echo "then run \`:Lazy sync\`"

echo "and you\'re good to go!"
