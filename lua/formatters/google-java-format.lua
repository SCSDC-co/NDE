local M = {}

M.name = "google-java-format"
M.languages = { "java" }
M.mason_package = "google-java-format"
M.description = "Google's Java code formatter"

M.config = {
  prepend_args = {
    "--aosp", -- Android Open Source Project style (4 spaces)
    "--skip-sorting-imports", -- Don't sort imports (let LSP handle it)
    "--skip-removing-unused-imports", -- Don't remove unused imports
  },
}

M.setup = function()
  return M.config
end

return M

