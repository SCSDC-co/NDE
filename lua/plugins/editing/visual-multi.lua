return {
  "mg979/vim-visual-multi",
  keys = { "<C-n>", "<C-A-n>", "<C-jj>", "<C-kk>", "<C-ii>" },
  init = function()
    -- Basic configuration
    vim.g.VM_leader = "\\"
    vim.g.VM_theme = "iceblue"
    vim.g.VM_highlight_matches = "underline"
    
    -- Key mappings (VSCode-style with safe double-key combos)
    vim.g.VM_maps = {
      ["Find Under"] = "<C-n>",
      ["Find Subword Under"] = "<C-n>",
      ["Select All"] = "<C-A-n>",
      ["Start Regex Search"] = "<leader>vm",
      ["Add Cursor Down"] = "<C-jj>",
      ["Add Cursor Up"] = "<C-kk>",
      ["Add Cursor At Pos"] = "<C-ii>",
      ["Remove Region"] = "q",
      ["Skip Region"] = "<C-x>",
    }
    
    -- Visual Multi settings for better UX
    vim.g.VM_quit_after_leaving_insert_mode = 0
    vim.g.VM_live_editing = 1
    vim.g.VM_set_statusline = 3
    vim.g.VM_silent = 0
  end,
}
