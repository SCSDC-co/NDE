# ⌨️ NDE Keybinding Reference v4.1.0

> Complete keybinding guide for the Neovim Development Environment - AI Revolution Update

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
- ⚡  **C++**: `g++ -std=c++17 file.cpp -o executable && ./executable`
- 🔧 **C**: `clang file.c -o executable && ./executable`
- 🔩 **Assembly**: `nasm -f elf64 + ld + execute`
- 🦀 **Rust**: `cargo run` or `rustc` (smart project detection)
- 🐹 **Go**: `go run .` or `go run file.go` (smart project detection)
- ☕ **Java**: `javac + java`
- 🌐  **JavaScript**: `node file.js`
- 📘 **TypeScript**: `ts-node file.ts`
- 🌙 **Lua**: `lua file.lua`
- 💎 **Ruby**: `ruby file.rb`
- 🐘 **PHP**: `php file.php`
- 🔥 **Haskell**: `ghc + execute`
- ⚡ **Zig**: `zig run file.zig`
- 🦎 **Scala**: `scala file.scala`
- 🔷 **Kotlin**: `kotlinc + java`
- 🍃 **Swift**: `swift file.swift`
- 🎯 **Dart**: `dart file.dart`
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

## 🗂️ Code Structure Navigation (Aerial)

| Keybinding   | Function             | Behavior                        | Context      |
| ------------ | -------------------- | ------------------------------- | ------------ |
| `<Leader>a`  | **Toggle Aerial**    | Show/hide code structure panel | Any file     |
| `<CR>`       | **Jump to Symbol**   | Navigate to symbol definition   | Aerial panel |
| `<C-v>`      | **Vertical Split**   | Open symbol in vertical split   | Aerial panel |
| `<C-s>`      | **Horizontal Split** | Open symbol in horizontal split | Aerial panel |
| `p`          | **Preview**          | Preview symbol without jumping  | Aerial panel |
| `<C-j/k>`    | **Navigate & Scroll**| Move through symbols with scroll | Aerial panel |

## 📝 Text Editing Helpers

| Keybinding   | Action                 | Behavior                        | Context      |
| ------------ | ---------------------- | ------------------------------- | ------------ |
| `<Leader>j`  | **Insert Line Below**  | Add empty line after cursor     | Any mode     |
| `<Leader>k`  | **Insert Line Above**  | Add empty line before cursor    | Any mode     |
| `<C-Space>`  | **Trigger Completion** | Force completion menu           | Insert mode  |
| `/` → `<CR>` | **Search**             | Enhanced search with Telescope  | Search mode  |
| `:`          | **Command Mode**       | Command palette with completion | Command mode |

## 🔤 Code Completion (nvim-cmp)

### Completion Navigation

| Keybinding   | Action                   | Description                          | Mode         |
| ------------ | ------------------------ | ------------------------------------ | ------------ |
| `<C-Space>`  | **Trigger Completion**   | Manually trigger completion menu     | Insert       |
| `<C-e>`      | **Abort Completion**     | Close completion menu               | Insert       |
| `<C-CR>`     | **Confirm Selection**    | Accept selected completion item      | Insert       |
| `<C-j>`      | **Next Item/Snippet**    | Select next item or jump to next snippet placeholder | Insert/Select |
| `<C-k>`      | **Previous Item/Snippet**| Select previous item or jump to previous snippet placeholder | Insert/Select |

### Documentation Scrolling

| Keybinding   | Action                   | Description                          | Mode         |
| ------------ | ------------------------ | ------------------------------------ | ------------ |
| `<C-b>`      | **Scroll Docs Up**       | Scroll documentation window up       | Insert       |
| `<C-f>`      | **Scroll Docs Down**     | Scroll documentation window down     | Insert       |

### Command Line Completion

| Context      | Keybinding   | Action                   | Description                          |
| ------------ | ------------ | ------------------------ | ------------------------------------ |
| Search (`/`, `?`) | `<Tab>`      | **Next Match**           | Navigate through search completions  |
| Command (`:`)     | `<Tab>`      | **Next Command**         | Navigate through command completions |
| Command (`:`)     | `<S-Tab>`    | **Previous Command**     | Navigate backward through commands   |

## 🎯 Smart Snippets (LuaSnip)

| Keybinding   | Action                   | Description                          | Mode         |
| ------------ | ------------------------ | ------------------------------------ | ------------ |
| `<C-j>`      | **Expand/Jump Next**     | Expand snippet or jump to next placeholder (in cmp) | Insert/Select |
| `<C-k>`      | **Jump Previous**        | Jump to previous snippet placeholder (in cmp) | Insert/Select |
| `<C-e>`      | **Cycle Choices**        | Cycle through snippet choice nodes   | Insert mode  |

## 🤖 AI Revolution (Triple AI System)

### AI Assistant Commands

| Keybinding   | AI System    | Action                    | Description                                 | Mode   |
| ------------ | ------------ | ------------------------- | ------------------------------------------- | ------ |
| `<leader>a`  | **All**      | **AI Assistant Menu**     | Access all AI assistant commands           | Normal |
| `<C-Space>`  | **All**      | **Trigger Completion**    | Force AI completion menu (Supermaven/Codeium) | Insert |
| `<C-e>`      | **All**      | **Abort Completion**      | Cancel AI completion                        | Insert |

### Avante AI Chat (Google Gemini)

| Keybinding     | Action                 | Description                                    | Mode   |
| -------------- | ---------------------- | ---------------------------------------------- | ------ |
| `<leader>aa`   | **Start Chat**         | Open Avante AI chat sidebar (1M token context) | Normal |
| `<leader>ae`   | **Explain Code**       | Get AI explanation of current code             | Normal/Visual |
| `<leader>ar`   | **Refactor Code**      | AI-assisted code refactoring suggestions       | Normal/Visual |
| `<leader>ad`   | **Debug Assist**       | AI debugging help and error analysis          | Normal |
| `<CR>`         | **Submit Chat**        | Submit message in chat (normal mode)          | Normal |
| `<C-s>`        | **Submit Chat**        | Submit message in chat (insert mode)          | Insert |
| `<Tab>`        | **Switch Windows**     | Switch between chat and code windows          | Normal |
| `<S-Tab>`      | **Reverse Switch**     | Reverse window switching                       | Normal |
| `]]`           | **Next Block**         | Jump to next AI suggestion block              | Normal |
| `[[`           | **Previous Block**     | Jump to previous AI suggestion block          | Normal |

### AI Conflict Resolution (Avante)

| Keybinding | Action              | Description                    | Mode   |
| ---------- | ------------------- | ------------------------------ | ------ |
| `co`       | **Choose Ours**     | Accept your version of code    | Normal |
| `ct`       | **Choose Theirs**   | Accept AI suggested version    | Normal |
| `ca`       | **Choose All Theirs** | Accept all AI suggestions    | Normal |
| `cb`       | **Choose Both**     | Merge both versions            | Normal |
| `cc`       | **Choose Cursor**   | Resolve at cursor position     | Normal |
| `]x`       | **Next Conflict**   | Navigate to next conflict      | Normal |
| `[x`       | **Previous Conflict** | Navigate to previous conflict | Normal |

### AI Completion Integration

| AI System      | Priority | Description                                | Integration |
| -------------- | -------- | ------------------------------------------ | ----------- |
| **Supermaven** | 1200     | Ultra-fast AI completions, minimal latency | CMP popup   |
| **Codeium**    | 1100     | Comprehensive AI backup with fallback     | CMP popup   |
| **LSP**        | 1000     | Language server completions               | CMP popup   |
| **Snippets**   | 750      | Code snippets and templates               | CMP popup   |

## 👀 Multiple Cursors (Visual-Multi)

| Keybinding     | Action                 | Description                     | Mode   |
| -------------- | ---------------------- | ------------------------------- | ------ |
| `<C-n>`        | **Find Under**         | Add cursor to next occurrence   | Normal/Visual |
| `<C-A-n>`      | **Select All**         | Select all occurrences          | Normal |
| `<leader>vm`   | **Regex Search**       | Start regex-based selection     | Normal |
| `<C-jj>`       | **Add Cursor Down**    | Add cursor on line below        | Normal |
| `<C-kk>`       | **Add Cursor Up**      | Add cursor on line above        | Normal |
| `<C-ii>`       | **Add Cursor At Pos**  | Add cursor at current position  | Normal |
| `q`            | **Remove Region**      | Remove current cursor/selection | Visual-Multi |
| `<C-x>`        | **Skip Region**        | Skip current selection          | Visual-Multi |

## 🔢 Smart Increment/Decrement (Dial.nvim)

| Keybinding     | Action                 | Description                     | Mode   |
| -------------- | ---------------------- | ------------------------------- | ------ |
| `<C-a>`        | **Increment**          | Smart increment numbers/booleans| Normal/Visual |
| `<C-x>`        | **Decrement**          | Smart decrement numbers/booleans| Normal/Visual |
| `g<C-a>`       | **Global Increment**   | Increment all in selection      | Normal/Visual |
| `g<C-x>`       | **Global Decrement**   | Decrement all in selection      | Normal/Visual |

**Smart Values Supported:**
- Numbers: `0, 1, 2, 3...` and `0x01, 0x1a1f...`
- Dates: `2022/02/19`, `2022-02-19`, `02/19/2022`
- Time: `14:30, 15:30...`
- Booleans: `true ↔ false`, `yes ↔ no`, `on ↔ off`
- Logic: `and ↔ or`, `&& ↔ ||`, `enable ↔ disable`
- Directions: `left ↔ right`, `up ↔ down`, `horizontal ↔ vertical`

## 📐 Text Alignment (Easy-Align)

| Keybinding     | Action                 | Description                     | Mode   |
| -------------- | ---------------------- | ------------------------------- | ------ |
| `<leader>Ea`   | **Easy Align**         | Align text around delimiters    | Normal/Visual |
| `<leader>EA`   | **Live Easy Align**    | Interactive real-time alignment | Normal/Visual |

**Common Alignment Patterns:**
- `=` - Align around equals signs
- `:` - Align around colons
- `|` - Align around pipes (tables)
- `,` - Align around commas
- `//` - Align around comments

## 📊 Advanced Git Workflow

### Git Fugitive

| Keybinding     | Action                 | Description                     | Mode   |
| -------------- | ---------------------- | ------------------------------- | ------ |
| `<leader>gg`   | **Git Status**         | Open Git status window          | Normal |
| `<leader>gd`   | **Git Diff Split**     | Show diff in split window       | Normal |
| `<leader>gb`   | **Git Blame**          | Show git blame for current file | Normal |
| `<leader>gw`   | **Git Write (Stage)**  | Stage current file              | Normal |
| `<leader>gr`   | **Git Read (Checkout)**| Checkout file from HEAD         | Normal |
| `<leader>gc`   | **Git Commit**         | Open commit window              | Normal |
| `<leader>gp`   | **Git Push**           | Push to remote                  | Normal |
| `<leader>gP`   | **Git Pull**           | Pull from remote                | Normal |

**Within Fugitive Buffer:**
- `=` or `<Space>` - Stage/unstage file
- `s` - Stage file
- `u` - Unstage file
- `U` - Unstage all
- `dd` - Vertical diff
- `dh` - Horizontal diff
- `cc` - Commit
- `q` - Quit

### Git Diffview

| Keybinding     | Action                 | Description                     | Mode   |
| -------------- | ---------------------- | ------------------------------- | ------ |
| `<leader>gd`   | **Open Diffview**      | Open advanced diff interface    | Normal |
| `<leader>gc`   | **Close Diffview**     | Close diff interface            | Normal |
| `<leader>gh`   | **File History**       | Show file history               | Normal |
| `<leader>gH`   | **Current File History**| Show current file history      | Normal |

**Within Diffview:**
- `<Tab>` - Next file
- `<S-Tab>` - Previous file
- `gf` - Go to file
- `<leader>e` - Focus file panel
- `<leader>b` - Toggle file panel
- `[x` / `]x` - Navigate conflicts
- `<leader>co` - Choose ours
- `<leader>ct` - Choose theirs

## 📚 Documentation & Help

| Keybinding   | Function           | Description                        | Context      |
| ------------ | ------------------ | ---------------------------------- | ------------ |
| `K`          | **Hover Info**     | Show symbol documentation          | LSP enabled  |
| `<C-k>`      | **Signature Help** | Show function signature            | Insert mode  |
| `:help`      | **Vim Help**       | Access Neovim documentation       | Command mode |
| `<Leader>fh` | **Help Search**    | Search help with Telescope        | Any mode     |
| `:NDE snippetslist` | **List Snippets**     | Show available snippets for current filetype | Command |
| `:NDE help`         | **NDE Help**          | Show complete NDE command reference          | Command |
| `:NDE status`       | **NDE Status**        | Show comprehensive NDE system status         | Command |
| `:NDE welcome`      | **NDE Welcome**       | Display NDE welcome message                  | Command |
| `:NDE tips on/off`  | **Tips Control**      | Enable/disable automatic tips system         | Command |
| `:NDE tip random`   | **Random Tip**        | Show a random helpful tip                    | Command |
| `:NDE dynamicloader stats` | **Performance Stats** | Show dynamic loader performance statistics | Command |

### 🚀 Available Snippets by Language

**Python:** `class`, `def`, `dataclass`, `async`, `main`, `try`  
**JavaScript/TypeScript:** `rfc` (React component), `hook`, `interface`, `arrow`  
**Rust:** `struct`, `error`, `async`, `main`  
**Go:** `struct`, `handler`, `iferr`  
**C/C++:** `class`, `guard`  
**Lua:** `module`, `plugin`, `autocmd`  
**HTML:** `html5`, `component`  
**SQL:** `select`, `table`

## 🎭 Advanced Navigation

| Keybinding  | Function                 | Description                                    |
| ----------- | ------------------------ | ---------------------------------------------- |
| `s`         | Leap Forward             | Jump to location with 2 characters (leap.nvim) |
| `S`         | Leap Backward            | Jump backwards with 2 characters (leap.nvim)   |
| `gs`        | Leap Windows             | Jump across windows (leap.nvim)                |
| `<leader>;` | Symbol Picker            | Interactive symbol picker in winbar (dropbar)  |
| `[[`        | Previous Reference       | Jump to previous symbol reference (illuminate) |
| `]]`        | Next Reference           | Jump to next symbol reference (illuminate)     |
| `<leader>[` | Previous Reference (Alt) | Alternative binding for previous reference     |
| `<leader>]` | Next Reference (Alt)     | Alternative binding for next reference         |

## 🏆 Command Discovery (Legendary)

| Keybinding   | Function            | Description                           |
| ------------ | ------------------- | ------------------------------------- |
| `<leader>L`  | **Command Palette** | Open Legendary command palette (main) |
| `<C-p>`      | **Quick Palette**   | Quick access to command palette       |
| `<leader>Lk` | **Find Keymaps**    | Search and execute keybindings        |
| `<leader>Lc` | **Find Commands**   | Search and execute commands           |
| `<leader>Lf` | **Find Functions**  | Search and execute functions          |
| `<leader>La` | **Find Autocmds**   | Search and view autocmds              |

## 💾 Session Management (Persistence)

| Keybinding    | Function              | Description                                     |
| ------------- | --------------------- | ----------------------------------------------- |
| `<leader>gs`   | **Save Session**      | Save current session state                     |
| `<leader>gl`   | **Load Session**      | Load session for current directory             |
| `<leader>gL`   | **Load Last Session** | Load the most recent session                   |
| `<leader>gd`   | **Stop Session**      | Stop session saving on exit                    |

## 🎣 Harpoon File Navigation

| Keybinding    | Function              | Description                                     |
| ------------- | --------------------- | ----------------------------------------------- |
| `<leader>ma`   | **Add to Harpoon**    | Add current file to harpoon marks              |
| `<leader>mt`   | **Toggle Quick Menu** | Open harpoon quick menu                        |
| `<M-1>`        | **Harpoon File 1**    | Quick access to harpooned file 1               |
| `<M-2>`        | **Harpoon File 2**    | Quick access to harpooned file 2               |
| `<M-3>`        | **Harpoon File 3**    | Quick access to harpooned file 3               |
| `<M-4>`        | **Harpoon File 4**    | Quick access to harpooned file 4               |
| `<leader>mp`   | **Previous File**     | Navigate to previous harpoon file              |
| `<leader>mn`   | **Next File**         | Navigate to next harpoon file                  |
| `<leader>mc`   | **Clear All**         | Clear all harpoon marks                        |
| `<leader>m1-4` | **Replace Mark**      | Replace specific harpoon mark (1-4)            |
| `[;`           | Context Start         | Go to start of current context (dropbar)       |
| `];`           | Next Context          | Select next context (dropbar)                  |

## 🎮 Special Modes

| Keybinding   | Function        | Description                  |
| ------------ | --------------- | ---------------------------- |
| `<leader>vt` | Toggle VimBeGood| Toggle Vim Training mode     |
| `:ZenMode`   | Focus Mode      | Distraction-free coding      |

## 🎯 NDE Command Suite

| Command Category | Description | Example Commands |
| ---------------- | ----------- | ---------------- |
| **Tips System** | Smart learning assistance | `:NDE tips on`, `:NDE tip random` |
| **Performance** | System monitoring | `:NDE dynamicloader stats` |
| **Snippets** | Code template discovery | `:NDE snippetslist` |
| **Navigation** | Quick help access | `:NDE help`, `:NDE status` |

*💡 All NDE commands support tab completion! Type `:NDE <Tab>` to explore.*

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
- **Leader patterns**: `f` prefix for finding, `b` prefix for buffers, `B` prefix for text utilities, `a` for aerial
- **Logical groupings**: Window management with Ctrl/Alt, file operations with leader+f, AI commands with leader+g
- **NDE Commands**: Use `:NDE` prefix for all NDE suite functionality with tab completion

---

*💡 Tip: Use `<Space>` (leader key) to open Which-key and discover available commands in any context!*