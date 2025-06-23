local M = {}

M.name = "ocamlformat"
M.languages = { "ocaml" }
M.mason_package = "ocamlformat"
M.description = "A tool to format OCaml code"

M.config = {
  command = "ocamlformat",
  args = {
    "--name",
    "$FILENAME",
    "--enable-outside-detected-project",
    "-"
  },
  stdin = true,
}

M.setup = function()
  -- ocamlformat will automatically look for .ocamlformat in project
  return M.config
end

return M
