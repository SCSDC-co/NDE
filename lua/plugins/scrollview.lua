return {
  "dstein64/nvim-scrollview",
  event = "BufReadPost",
  opts = {
    current_only = true,
    winblend = 75,
    base = "right",
    column = 1,
    signs_on_startup = { "all" },
  },
}
