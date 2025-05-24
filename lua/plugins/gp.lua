return {
  "Robitx/gp.nvim",
  event = "VeryLazy",
  config = function()
    require("gp").setup({
      providers = {
        ollama = {
          endpoint = "http://localhost:11434/v1/chat/completions",
        },
      },
      agents = {
        {
          name = "default",
          provider = "ollama",
          chat = true,
          command = false,
          model = { model = "deepseek-coder" },
          system_prompt = "You are an expert programmer. Respond concisely and clearly.",
        },
      },
    })

  end,
}
