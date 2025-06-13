local M = {}

M.name = "rustfmt"
M.languages = { "rust" }
M.mason_package = "rustfmt" -- Usually comes with rust-analyzer
M.description = "The official Rust code formatter"

M.config = {
  prepend_args = {
    "--edition", "2021", -- Use Rust 2021 edition
    "--config", "hard_tabs=true", -- Use tabs
    "--config", "tab_spaces=4", -- 4 spaces per tab
    "--config", "max_width=100", -- Line width
  },
}

M.setup = function()
  -- rustfmt will automatically look for rustfmt.toml or .rustfmt.toml in project
  return M.config
end

return M

