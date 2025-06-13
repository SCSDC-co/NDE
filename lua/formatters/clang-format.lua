local M = {}

M.name = "clang-format"
M.languages = { "c", "cpp", "h", "hpp" }
M.mason_package = "clang-format"
M.description = "LLVM's C/C++ code formatter"

M.config = {
  prepend_args = {
    "--style={"
    .. "IndentWidth: 4, "
    .. "UseTab: Always, "
    .. "TabWidth: 4, "
    .. "ColumnLimit: 120, "
    .. "BreakBeforeBraces: Allman, "
    .. "AllowShortIfStatementsOnASingleLine: false, "
    .. "AllowShortLoopsOnASingleLine: false, "
    .. "AllowShortFunctionsOnASingleLine: None"
    .. "}",
  },
}

M.setup = function()
  -- clang-format will look for .clang-format in project root
  return M.config
end

return M

