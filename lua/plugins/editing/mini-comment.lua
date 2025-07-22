return {
  "echasnovski/mini.comment",
  lazy = true, -- ⚡ PERFORMANCE: Load on keys only
  keys = {
    { "gc", mode = { "n", "x" }, desc = "Comment toggle" },
    { "gcc", mode = "n", desc = "Comment toggle current line" },
  },
  config = function()
    require('mini.comment').setup()
  end,
}

