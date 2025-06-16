# ⌨️ NDE Keybinding Reference

> Complete keybinding guide for the Neovim Development Environment

## 🎯 Leader Key

The leader key is set to **`<Space>`** (spacebar). All leader-based commands start with pressing the spacebar.

## 🔍 File Navigation & Management

| Keybinding   | Function                 | Description                                       |
| ------------ | ------------------------ | ------------------------------------------------- |
| `<leader>ff` | File Search              | Search files using Telescope                      |
| `<leader>fg` | Content Search           | Live grep in files                                |
| `<leader>fb` | Buffer List              | Display open buffers                              |
| `<leader>fh` | Help Search              | Search help documentation                         |
| `<leader>fp` | Clipboard History        | Access yanky clipboard history via Telescope      |
| `<leader>fR` | Find & Replace (Spectre) | Project-wide search and replace with live preview |
| `<leader>fw` | Find & Replace Word      | Search and replace current word/selection         |
| `<leader>fc` | Find & Replace in File   | Search and replace within current file only       |
| `<leader>e`  | File Explorer (Root)     | Toggle Neo-tree from filesystem root              |
| `<leader>n`  | File Explorer (Local)    | Toggle Neo-tree (smart focus switching)           |
| `<leader>bc` | Close Buffer             | Close current buffer                              |
| `<leader>bo` | Close Others             | Close all other buffers                           |

## 🚀 Universal Code Runner

| Keybinding | Function          |   Description                                                                     |
| ---------- | ----------------- | --------------------------------------------------------------------------------- |
| `<F8>`     | **Universal Run** | 🚀 Automatically detects file type and runs with appropriate compiler/interpreter |

**Supported Languages:**
- 🐍 **Python**: `python3 file.py`
- ⚡  **C++**: `g++ file.cpp -o executable && ./executable`
- 🔧 **C**: `clang file.c -o executable && ./executable`
- 🔩 **Assembly**: `nasm + ld + execute`
- 🦀 **Rust**: `cargo run` or `rustc`
- 🐹 **Go**: `go run` (smart project detection)
- ☕ **Java**: `javac + java`
- 🌐  **JavaScript**: `node file.js`
- 📘 **TypeScript**: `ts-node file.ts`
- 🌙 **Lua**: `lua file.lua`
- And many more!

## 🐛 Debugging Controls

| Keybinding   | Action                | Function                        | DAP Integration     |
| ------------ | --------------------- | ------------------------------- | ------------------- |
| `<F1>`       | **Toggle Breakpoint** | Set/remove breakpoint at cursor | Visual indicator    |
| `<F2>`       | **Continue**          | Resume program execution        | Full DAP support    |
| `<F3>`       | **Step Into**         | Step into function calls        | Variable inspection |
| `<F4>`       | **Step Over**         | Execute current line            | Scope awareness     |
| `<Leader>du` | **Toggle DAP UI**     | Show/hide debug interface       | Visual debugging    |

## 📋 Advanced Clipboard Management (Yanky)

| Keybinding   | Action                 | Behavior                         | Integration        |
| ------------ | ---------------------- | -------------------------------- | ------------------ |
| `<Leader>fp` | **History Picker**     | Open Telescope clipboard browser | Visual selection   |
| `p`          | **Smart Paste After**  | Enhanced paste with history      | Context-aware      |
| `P`          | **Smart Paste Before** | Enhanced paste before cursor     | Position-aware     |
| `<C-p>`      | **Previous Entry**     | Cycle to previous clipboard item | Post-paste cycling |
| `<C-n>`      | **Next Entry**         | Cycle to next clipboard item     | Post-paste cycling |

## 🔄 Text Manipulation (Surround)

| Operation           | Keybinding                        | Example            | Result            |
| ------------------- | --------------------------------- | ------------------ | ----------------- |
| **Add Surround**    | `<Leader>sa` → `ys{motion}{char}` | `ysiw"` on `word`  | `"word"`          |
| **Change Surround** | `<Leader>sc` → `cs{old}{new}`     | `cs'"` on `'text'` | `"text"`          |
| **Delete Surround** | `<Leader>sd` → `ds{char}`         | `ds"` on `"text"`  | `text`            |
| **Visual Mode**     | Select → `S{char}`                | Select text → `S)` | `(selected text)` |

### Direct Surround Operations

| Keybinding           | Function          | Description                                      |
| -------------------- | ----------------- | ------------------------------------------------ |
| `ys` + motion + char | Add Surround      | Direct surround add (e.g., ysiw" for quotes)     |
| `cs` + old + new     | Change Surround   | Direct surround change (e.g., cs'" quotes)       |
| `ds` + char          | Delete Surround   | Direct surround delete (e.g., ds" remove quotes) |
| `<F9>`               | Quick Parentheses | Add parentheses around current word (`ysiw()`)   |
| `<F10>`              | Quick Quotes      | Add quotes around current word (`ysiw"`)         |

## 🎯 Code Intelligence

| Keybinding   | LSP Action              | Function                      | Availability      |
| ------------ | ----------------------- | ----------------------------- | ----------------- |
| `gd`         | **Go to Definition**    | Navigate to symbol definition | All LSP languages |
| `K`          | **Hover Documentation** | Show symbol information       | Context-sensitive |
| `<C-k>`      | **Signature Help**      | Show function signature       | Function calls    |
| `<Leader>f`  | **Format Document**     | Auto-format current file      | Language-specific |
| `<Leader>rn` | **Rename Symbol**       | Intelligent symbol renaming   | Project-wide      |
| `<Leader>ca` | **Code Actions**        | Show available code actions   | Context-aware     |
| `gr`         | **Go to References**    | Find all symbol references    | Cross-file search |

## 🪟 Smart Window Management

| Keybinding         | Action                   | Function                           | Smart Features        |
| ------------------ | ------------------------ | ---------------------------------- | --------------------- |
| `Ctrl+h/j/k/l`     | **Smart Navigation**     | Move between windows intelligently | Tmux integration      |
| `Alt+h/j/k/l`      | **Resize Windows**       | Intuitive window resizing          | Real-time feedback    |
| `Ctrl+Arrows`      | **Resize (Alternative)** | Arrow key window resizing          | Ergonomic option      |
| `<leader>Wh/j/k/l` | **Swap Windows**         | Move windows around splits         | Buffer preservation   |

## 🔧 Terminal & Git Integration

| Keybinding    | Tool           | Action                         | Interface         |
| ------------- | -------------- | ------------------------------ | ----------------- |
| `<F11>`       | **Lazygit**    | Open Git interface in terminal | Full-screen TUI   |
| `<F12>`       | **ToggleTerm** | Open terminal on right side    | Vertical split    |
| `<C-h/j/k/l>` | **Window Nav** | Navigate between panes         | Works in terminal |
| Git signs     | **Automatic**  | Show changes in sign column    | Real-time updates |

## 🎨 Character Utilities (Blink)

| Keybinding   | Function             | Behavior                   | Use Case        |
| ------------ | -------------------- | -------------------------- | --------------- |
| `<Leader>B;` | **Toggle Semicolon** | Add/remove `;` at line end | Code formatting |
| `<Leader>B,` | **Toggle Comma**     | Add/remove `,` at line end | List formatting |

## 📝 Text Editing Helpers

| Keybinding   | Action                 | Behavior                        | Context      |
| ------------ | ---------------------- | ------------------------------- | ------------ |
| `<Leader>j`  | **Insert Line Below**  | Add empty line after cursor     | Any mode     |
| `<Leader>k`  | **Insert Line Above**  | Add empty line before cursor    | Any mode     |
| `<C-Space>`  | **Trigger Completion** | Force completion menu           | Insert mode  |
| `/` → `<CR>` | **Search**             | Enhanced search with Telescope  | Search mode  |
| `:`          | **Command Mode**       | Command palette with completion | Command mode |

## 🎭 Advanced Navigation

| Keybinding  | Function        | Description                                     |
| ----------- | --------------- | ----------------------------------------------- |
| `s`         | Leap Forward    | Jump to location with 2 characters (leap.nvim)  |
| `S`         | Leap Backward   | Jump backwards with 2 characters (leap.nvim)    |
| `gs`        | Leap Windows    | Jump across windows (leap.nvim)                 |
| `<leader>;` | Symbol Picker   | Interactive symbol picker in winbar (dropbar)   |
| `[;`        | Context Start   | Go to start of current context (dropbar)        |
| `];`        | Next Context    | Select next context (dropbar)                   |

## 🎮 Special Modes

| Keybinding   | Function        | Description                  |
| ------------ | --------------- | ---------------------------- |
| `<leader>vt` | Toggle VimBeGood| Toggle Vim Training mode     |
| `:ZenMode`   | Focus Mode      | Distraction-free coding      |

## 🎯 Pro Tips for Efficiency

### 🔥 Workflow Combinations

1. **Universal Code Running**: `<F8>` → automatically detects and runs any language
2. **Quick File Search**: `<leader>ff` → type filename → Enter
3. **Project-wide Search**: `<leader>fg` → search term → navigate results
4. **Buffer Management**: `<leader>fb` → select buffer or `<leader>bo` to close others
5. **Code Navigation**: `gd` to definition → `gr` for references → `K` for docs
6. **Terminal Workflow**: `<F12>` for commands → `<F11>` for git operations

### ⚡ Power User Shortcuts

- **Multi-cursor editing**: Visual select → surround operations
- **Quick formatting**: `<leader>f` for instant code formatting
- **Clipboard cycling**: Paste with `p` → cycle with `<C-p>/<C-n>`
- **Window management**: `Ctrl+hjkl` for navigation → `Alt+hjkl` for resizing
- **Search and replace**: `<leader>fR` for project-wide → `<leader>fw` for current word

### 🧠 Memory Aids

- **F-keys for actions**: F1-F4 for debugging, **F8 for universal code running**, F9-F10 for text manipulation, F11-F12 for terminals
- **Leader patterns**: `f` prefix for finding, `b` prefix for buffers, `B` prefix for text utilities
- **Logical groupings**: Window management with Ctrl/Alt, file operations with leader+f

---

*💡 Tip: Use `<Space>` (leader key) to open Which-key and discover available commands in any context!*