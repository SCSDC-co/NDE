local M = {}

-- Setup UI components
function M.setup(config)
  -- Store config globally for UI components
  _G.OptiSpec = _G.OptiSpec or {}
  _G.OptiSpec.ui_config = config
  
  -- Initialize NUI components
  require("optispec.ui.prompt").setup(config)
  require("optispec.ui.browser").setup(config)
  require("optispec.ui.status").setup(config)
  
  -- Store UI utilities globally
  _G.OptiSpec.ui = {
    show_prompt = require("optispec.ui.prompt").show_install_prompt,
    show_browser = require("optispec.ui.browser").show,
    show_status = require("optispec.ui.status").show,
  }
end

return M
