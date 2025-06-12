return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("dap")
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dapui").setup()
    end,
  },
}
