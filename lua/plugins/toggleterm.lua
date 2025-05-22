return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    local toggleterm = require("toggleterm")

    toggleterm.setup({
      size = 70,
      open_mapping = false, 
      direction = "vertical",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
      },
    })

    local Terminal = require("toggleterm.terminal").Terminal

    local right_term = Terminal:new({
      direction = "vertical",
      close_on_exit = true,
      count = 99, 
    })

    function _right_term_toggle()
      right_term:toggle()
      vim.cmd("wincmd l")
      vim.cmd("startinsert")
    end

    local lazygit = Terminal:new({
      cmd = "lazygit",
      direction = "vertical",
      close_on_exit = true,
      count = 100,
    })

    function _lazygit_toggle()
      lazygit:toggle()
      vim.cmd("wincmd l")
      vim.cmd("startinsert")
    end

    vim.api.nvim_set_keymap("n", "<F12>", "<cmd>lua _right_term_toggle()<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<F11>", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
  end,
}
