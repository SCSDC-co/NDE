# 🚀 NDE Installation Guide

> Complete installation and troubleshooting guide for the Neovim Development Environment

## ⚡ Quick Installation

### One-Command Setup

```bash
# Clone and install in one step
git clone https://github.com/Sckab/NDE.git ~/.config/nvim && nvim
```

## 📄 Requirements

### Essential Requirements

- **Neovim 0.10.0 or higher** (critical)
- **Git** (for plugin management)
- **Node.js and npm** (for language servers)
- **Python 3 and pip** (for language servers)
- **Internet connection** (for downloading plugins)

### Recommended Tools

- **Go** (for Go language server and development)
- **Rust toolchain via rustup** (for Rust development and tools)
- **Lazygit** (Git TUI integration)
- **A Nerd Font** (for proper icon display)
- **Ripgrep** (ultra-fast search)
- **fd-find** (modern file finder)

## 💻 Platform-Specific Installation

### 🐧 Arch Linux

```bash
# Install dependencies
sudo pacman -S neovim git nodejs npm python python-pip go rustup lazygit ripgrep fd

# Clone NDE
git clone https://github.com/Sckab/NDE.git ~/.config/nvim

# Launch Neovim (plugins will auto-install)
nvim
```

### 🌍 Ubuntu/Debian

```bash
# Update package list
sudo apt update

# Install dependencies
sudo apt install neovim git nodejs npm python3 python3-pip golang-go rustup ripgrep fd-find

# Install Lazygit (choose one method)
# Method 1: Snap
sudo snap install lazygit

# Method 2: Build from source (if snap not available)
go install github.com/jesseduffield/lazygit@latest

# Clone NDE
git clone https://github.com/Sckab/NDE.git ~/.config/nvim

# Launch Neovim
nvim
```

### 🍎 macOS (with Homebrew)

```bash
# Install dependencies
brew install neovim git node python go rustup-init lazygit ripgrep fd

# Clone NDE
git clone https://github.com/Sckab/NDE.git ~/.config/nvim

# Launch Neovim
nvim
```

### 🚐 Fedora

```bash
# Enable COPR for latest Neovim (if needed)
sudo dnf copr enable agriffis/neovim-nightly

# Install dependencies
sudo dnf install neovim git nodejs npm python3 python3-pip golang rust cargo lazygit ripgrep fd-find

# Clone NDE
git clone https://github.com/Sckab/NDE.git ~/.config/nvim

# Launch Neovim
nvim
```

## 🔧 Manual Neovim Installation

If your distribution doesn't have Neovim 0.10.0+:

### Ubuntu/Debian - Add PPA

```bash
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim
```

### Build from Source

```bash
# Install build dependencies
sudo apt install ninja-build gettext cmake unzip curl

# Clone and build
git clone https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
```

## 🎆 First Launch Experience

When you first launch NDE:

### Automatic Setup Process

1. **🔄 Plugin Installation**: Lazy.nvim downloads and installs all plugins
2. **🔨 LSP Server Setup**: Mason automatically installs language servers
3. **🎨 Theme Application**: Kanagawa Dragon theme is applied
4. **⚙️ Configuration Validation**: All settings are verified
5. **✅ Ready to Code**: Complete environment in under 2 minutes

### What You'll See

```
🎆 Welcome to NDE!
🔄 Installing plugins...
🔨 Setting up language servers...
🎨 Applying theme...
✅ NDE is ready to rock!
```

## 🚑 Troubleshooting

### Common Issues

#### ❌ Neovim Version Too Old

**Problem**: Configuration errors, plugins not loading

**Solution**:
```bash
# Check version
nvim --version

# If below 0.10.0, update:
# Arch Linux
sudo pacman -S neovim

# Ubuntu/Debian
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update && sudo apt install neovim
```

#### ❌ Plugin Installation Fails

**Problem**: Plugins not downloading, Lazy.nvim errors

**Solution**:
```vim
" In Neovim, reset plugins
:Lazy clean
:Lazy sync
```

#### ❌ LSP Servers Not Working

**Problem**: No code completion, diagnostics missing

**Solution**:
```vim
" Check LSP status
:LspInfo

" Reinstall language servers
:Mason
:MasonUninstallAll
:MasonInstall pyright typescript-language-server clangd
```

#### ❌ Missing Dependencies

**Problem**: Some features not working

**Solution**:
```bash
# Check what's installed
which nvim node python3 git rg fd

# Install missing tools
# Arch Linux
sudo pacman -S ripgrep fd

# Ubuntu/Debian
sudo apt install ripgrep fd-find
```

#### ❌ Permission Issues

**Problem**: Can't write to config directory

**Solution**:
```bash
# Fix ownership
sudo chown -R $USER:$USER ~/.config/nvim
sudo chown -R $USER:$USER ~/.local/share/nvim
```

#### ❌ Terminal Colors Wrong

**Problem**: Theme not displaying correctly

**Solution**:
```bash
# Check terminal capabilities
echo $TERM

# Set proper terminal
export TERM=xterm-256color
# Add to ~/.bashrc or ~/.zshrc
```

### Advanced Troubleshooting

#### Debug Plugin Loading

```vim
" Check plugin status
:Lazy

" Enable debug logging
:lua vim.lsp.set_log_level('debug')

" View logs
:lua vim.cmd('edit ' .. vim.lsp.get_log_path())
```

#### Reset Configuration

```bash
# Backup current config
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup

# Fresh install
git clone https://github.com/Sckab/NDE.git ~/.config/nvim
nvim
```

#### Performance Issues

```vim
" Profile startup time
:lua vim.cmd('profile start /tmp/nvim-startup.log')
:lua vim.cmd('profile func *')
:lua vim.cmd('profile file *')
" Restart Neovim and check /tmp/nvim-startup.log
```

## 🔌 Network Issues

### Behind Corporate Firewall

```bash
# Configure Git proxy
git config --global http.proxy http://proxy.company.com:8080
git config --global https.proxy https://proxy.company.com:8080

# Configure npm proxy
npm config set proxy http://proxy.company.com:8080
npm config set https-proxy https://proxy.company.com:8080
```

### Slow Plugin Downloads

```bash
# Use mirror (China users)
git config --global url."https://gitee.com/".insteadOf "https://github.com/"

# Or use proxy
git config --global http.proxy socks5://127.0.0.1:1080
```

## ⚙️ Optional Enhancements

### Install Additional Tools

```bash
# Enhanced search and file operations
cargo install ripgrep fd-find

# Git integration
cargo install git-delta

# JSON processing
sudo apt install jq  # or brew install jq

# Tree view for directories
sudo apt install tree  # or brew install tree
```

### Font Installation

```bash
# Download and install a Nerd Font
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip FiraCode.zip -d ~/.local/share/fonts/
fc-cache -fv
```

### Terminal Integration

```bash
# For enhanced terminal experience
# Add to ~/.bashrc or ~/.zshrc
export EDITOR=nvim
export VISUAL=nvim
alias vi=nvim
alias vim=nvim
```

## ✅ Verification

### Test Installation

```bash
# Create test file
echo 'print("Hello NDE!")' > test.py

# Open in NDE
nvim test.py

# Test features:
# 1. Press F8 to run Python code
# 2. Press <Space>ff to search files  
# 3. Press K on a function for documentation
# 4. Type :NDE help for command suite
```

### Success Indicators

- ✅ **NDE Welcome message** appears on startup
- ✅ **Kanagawa Dragon theme** is active
- ✅ **LSP diagnostics** show for code files
- ✅ **F8 universal runner** works for your language
- ✅ **Telescope search** (`<Space>ff`) functions
- ✅ **Tips system** shows helpful hints

## 📞 Support

If you encounter issues:

1. **Check Requirements**: Ensure Neovim 0.10.0+ is installed
2. **Review Logs**: Use `:messages` and `:LspInfo` in Neovim
3. **Search Issues**: Check the GitHub repository issues
4. **Clean Install**: Try resetting configuration if needed

### Getting Help

- **GitHub Issues**: [Report bugs and request features](https://github.com/Sckab/NDE/issues)
- **Discussions**: [Community support and questions](https://github.com/Sckab/NDE/discussions)
- **Documentation**: Review `README.md`, `KEYBINDINGS.md`, and plugin docs

---

**🎉 Once installation is complete, you'll have a powerful, feature-rich development environment ready for any programming language!**

*Happy coding with NDE! 🚀*

