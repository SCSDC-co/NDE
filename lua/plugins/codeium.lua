return {
  "Exafunction/codeium.vim",
  config = function()
    vim.cmd([[
      let g:codeium_enabled = 1
      imap <silent><script><expr> <C-e> codeium#Accept()
      let g:codeium_no_map_tab = 1
    ]])
  end,
}
