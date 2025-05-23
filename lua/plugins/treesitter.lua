return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "python", "javascript", "typescript", "html", "css",
          "c", "cpp", "c_sharp"
        },
        highlight = { enable = true },
        indent = { enable = true },
        fold = {
          enable = true,
        },

        playground = {
          enable = true,
          updatetime = 25,
          persist_queries = false,
        },
      })
    end,
  },
  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
  },
}
