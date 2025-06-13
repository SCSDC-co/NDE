local M = {}

M.name = "prettierd"
M.languages = { 
  "javascript", "typescript", "javascriptreact", "typescriptreact",
  "html", "css", "scss", "json", "yaml", "markdown"
}
M.mason_package = "prettierd"
M.description = "Faster prettier daemon for web technologies"

M.config = {
  prepend_args = {
    "--single-quote", -- Use single quotes
    "--jsx-single-quote", -- Single quotes in JSX
    "--tab-width", "2", -- 2 spaces for web tech
    "--print-width", "100", -- Line width
    "--trailing-comma", "es5", -- Trailing commas
    "--semi", -- Always use semicolons
  },
}

M.setup = function()
  -- prettierd will look for .prettierrc or prettier config in package.json
  return M.config
end

return M

