local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<Leader>j", [[:call append(line("."), '')<CR>]], { desc = "Nuova riga sotto", noremap = true })

vim.keymap.set("n", "<Leader>k", [[:call append(line(".") - 1, '')<CR>]], { desc = "Nuova riga sopra", noremap = true })

vim.keymap.set("n", "<leader>e", function()
  local neotree_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
    if bufname:match("neo%-tree filesystem") then
      neotree_win = win
      break
    end
  end

  if neotree_win then
    vim.cmd("Neotree close")
  else
    require("neo-tree.command").execute({ source = "filesystem", dir = "/" })
  end
end, { desc = "Toggle Neo-tree su /" })

vim.keymap.set("n", "<C-n>", function()
  local neotree_win = nil
  local current_win = vim.api.nvim_get_current_win()
  local last_win = vim.g.neotree_last_win

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
    if bufname:match("neo%-tree filesystem") then
      neotree_win = win
      break
    end
  end

  if neotree_win then
    if current_win == neotree_win then
      if last_win and vim.api.nvim_win_is_valid(last_win) then
        vim.api.nvim_set_current_win(last_win)
      else
        vim.cmd("wincmd p") 
      end
    else
      vim.g.neotree_last_win = current_win
      vim.api.nvim_set_current_win(neotree_win)
    end
  else
    vim.g.neotree_last_win = current_win
    vim.cmd("Neotree toggle")
  end
end, { desc = "Toggle Neo-tree", noremap = true, silent = true })

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
