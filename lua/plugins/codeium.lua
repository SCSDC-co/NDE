return {
  "Exafunction/codeium.vim",
  config = function()
    vim.cmd([[
      let g:codeium_enabled = 1
      let g:codeium_no_map_tab = 1
      imap <silent><script><expr> <Tab> codeium#Accept()
    ]])
  end,
}
