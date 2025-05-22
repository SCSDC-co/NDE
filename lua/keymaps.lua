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
vim.keymap.set("n", "<F7>", ":w<CR>:!dotnet run<CR>", { desc = "Run C# (dotnet run)" })
