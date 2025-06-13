local M = {}

M.name = "gofmt"
M.languages = { "go" }
M.mason_package = nil -- gofmt comes with Go installation, not available in mason
M.description = "The official Go code formatter"

M.config = {
  prepend_args = {
    "-s", -- Simplify code
    "-w", -- Write to file
  },
}

-- Alternative: goimports (includes gofmt + import management)
M.alternative = {
  name = "goimports",
  mason_package = "goimports",
  description = "Go formatter with import management",
  config = {
    prepend_args = {
      "-local", "github.com", -- Organize local imports
    },
  },
}

M.setup = function()
  -- Go uses tabs by default, no additional config needed
  return M.config
end

return M

