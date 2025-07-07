return {
  "supermaven-inc/supermaven-nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("supermaven-nvim").setup({
      disable_inline_completion = true, -- No ghost text
      disable_keymaps = true, -- No inline keybindings
    })
  end,
}
