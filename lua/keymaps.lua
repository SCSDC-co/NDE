local dap = require("dap")
local dapui = require("dapui")

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<Leader>j", [[:call append(line("."), '')<CR>]], { desc = "Nuova riga sotto", noremap = true })

vim.keymap.set("n", "<Leader>k", [[:call append(line(".") - 1, '')<CR>]], { desc = "Nuova riga sopra", noremap = true })

-- Neotree keymaps are now handled by which-key.lua to avoid conflicts

-- PYTHON
vim.keymap.set("n", "<F5>", function()
  local file = vim.fn.expand("%:p")

  vim.cmd("w")

  require("toggleterm.terminal").Terminal
    :new({
      cmd = "clear && python3 \"" .. file .. "\"",
      direction = "vertical",
      size = 70,
      close_on_exit = false,
      hidden = true,
    })
    :toggle()
end, { desc = "Esegui file Python nel terminale a destra", noremap = true, silent = true })

-- C++
vim.keymap.set("n", "<F6>", function()
  local file = vim.fn.expand("%:p")
  local filename = vim.fn.expand("%:t")
  local filename_no_ext = vim.fn.expand("%:t:r")
  local output_path = vim.fn.expand("%:p:h") .. "/" .. filename_no_ext

  if not filename:match("%.cpp$") and not filename:match("%.cc$") then
    print("Questo non è un file C++ (.cpp o .cc)!")
    return
  end

  vim.cmd("w")

  local compile_cmd = string.format("g++ \"%s\" -o \"%s\"", file, output_path)
  local full_cmd = compile_cmd .. string.format(" && clear && \"%s\"", output_path)

  require("toggleterm.terminal").Terminal
    :new({
      cmd = full_cmd,
      direction = "vertical",
      size = 70,
      close_on_exit = false,
      hidden = true,
    })
    :toggle()
end, { desc = "⚙️ Compila ed esegui C++ (in terminale a destra)", noremap = true, silent = true })

-- C
vim.keymap.set("n", "<F7>", function()
  local file = vim.fn.expand("%:p")
  local filename = vim.fn.expand("%:t")
  local filename_no_ext = vim.fn.expand("%:t:r")
  local output_path = vim.fn.expand("%:p:h") .. "/" .. filename_no_ext

  if not filename:match("%.c$") then
    print("Questo non è un file .c!")
    return
  end

  vim.cmd("w") 

  local compile_cmd = string.format("clang \"%s\" -o \"%s\"", file, output_path)

  local full_cmd = compile_cmd .. string.format(" && clear && \"%s\"", output_path)

  require("toggleterm.terminal").Terminal
    :new({
      cmd = full_cmd,
      direction = "vertical",
      size = 70,
      close_on_exit = false,
      hidden = true,
    })
    :toggle()
end, { desc = "Compila ed esegui file C con Clang (in terminale a destra)", noremap = true, silent = true })

-- ASM
vim.keymap.set("n", "<F8>", function()
  local file = vim.fn.expand("%:p")
  local filename = vim.fn.expand("%:t")
  local filename_no_ext = vim.fn.expand("%:t:r")
  local output_path = vim.fn.expand("%:p:h") .. "/" .. filename_no_ext

  if not filename:match("%.asm$") then
    print("Questo non è un file ASM!")
    return
  end

  vim.cmd("w")

  local cmd = string.format(
    "nasm -f elf64 \"%s\" -o \"%s.o\" && ld \"%s.o\" -o \"%s\" && clear && \"%s\"",
    file, output_path, output_path, output_path, output_path
  )

  require("toggleterm.terminal").Terminal
    :new({
      cmd = cmd,
      direction = "vertical",
      size = 70,
      close_on_exit = false,
      hidden = true,
    })
    :toggle()
end, { desc = "Compila ed esegui ASM (nasm + ld, terminale a destra)", noremap = true, silent = true })

-- debug
vim.keymap.set("n", "<F1>", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<F2>", dap.continue, { desc = "Continue" })
vim.keymap.set("n", "<F3>", dap.step_into, { desc = "Step Into" })
vim.keymap.set("n", "<F4>", dap.step_over, { desc = "Step Over" })

vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })

vim.keymap.set("v", "<leader>ge", ":GpExplain<CR>", { desc = "Spiega il codice selezionato" })
vim.keymap.set("v", "<leader>gr", ":GpRewrite<CR>", { desc = "Riscrivi il codice selezionato" })
vim.keymap.set("n", "<leader>gc", ":GpChatNew<CR>", { desc = "Nuova chat AI" })

-- toggleterm
vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], { desc = "Move to left window" })
vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], { desc = "Move to right window" })
vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], { desc = "Move to down window" })
vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], { desc = "Move to up window" })

vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = "Go to left window" })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = "Go to below window" })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = "Go to above window" })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = "Go to right window" })

-- bufferline
vim.keymap.set('n', '<leader>bc', ':bdelete<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bo', ':BufferLineCloseOthers<CR>', { noremap = true, silent = true })

-- Surround shortcuts
vim.keymap.set('n', '<F9>', 'ysiw)', { desc = "Add parentheses around word", remap = true })
vim.keymap.set('n', '<F10>', 'ysiw"', { desc = "Add quotes around word", remap = true })

