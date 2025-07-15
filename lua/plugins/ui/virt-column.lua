return {
  "lukas-reineke/virt-column.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("virt-column").setup({
      virtcolumn = "80",
      char = "│",
      highlight = "VirtColumn",
      enabled = true, -- Always enabled
    })
  end,
}
