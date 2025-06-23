local M = {}

M.name = "terraform-fmt"
M.languages = { "terraform", "terraform-vars" }
M.mason_package = "terraform_fmt"
M.description = "Terraform formatter"

M.config = {
  prepend_args = {
    "fmt",
    "-",
  },
}

M.setup = function()
  return M.config
end

return M
