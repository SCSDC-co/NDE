local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

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

vim.keymap.set("n", "<F5>", ":w<CR>:!python3 %<CR>", { desc = "Run Python File" })
vim.keymap.set("n", "<F6>", ":w<CR>:!g++ % -o %< && ./%<<CR>", { desc = "Compile & Run C++" })
vim.keymap.set("n", "<F7>", function()
  local file = vim.fn.expand("%")
  local filename_no_ext = file:match("(.+)%.c")
  if not filename_no_ext then
    print("Non è un file .c!")
    return
  end

  local cmd = string.format("clang %s -o %s && ./%s", file, filename_no_ext, filename_no_ext)
  vim.cmd("w")  -- salva il file prima di compilare
  vim.fn.system(cmd)
  vim.cmd("!./" .. filename_no_ext)
end, { desc = "Compile & Run C (Clang)", noremap = true, silent = true })
vim.keymap.set("n", "<F8>", function()
  local file = vim.fn.expand("%")
  local filename_no_ext = file:match("(.+)%.asm")
  if not filename_no_ext then
    print("Non è un file .asm!")
    return
  end

  local cmd = string.format("nasm -f elf64 %s -o %s.o && ld %s.o -o %s && ./%s", file, filename_no_ext, filename_no_ext, filename_no_ext, filename_no_ext)
  vim.cmd("w")  
  vim.fn.system(cmd)  
  vim.cmd("!./" .. filename_no_ext) 
end, { desc = "Compile & Run ASM (nasm + ld)" })
