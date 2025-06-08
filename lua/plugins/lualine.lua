local function clock()
  return os.date("%H:%M:%S")
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, 
  config = function()
    -- Get Kanagawa theme and customize it
    local kanagawa_theme = require("lualine.themes.kanagawa")
    
    -- Set lualine_c and lualine_x background to match editor background
    local bg_color = "#181616"
    
    -- Customize the theme - only change background, keep original foreground
    for mode, colors in pairs(kanagawa_theme) do
      if colors.c then
        colors.c.bg = bg_color
      end
    end
    
    require("lualine").setup({
      options = {
        theme = kanagawa_theme,
        icons_enabled = true,
        section_separators = { left = "◗", right = "◖" },
        component_separators = "|",
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics", clock },
        lualine_c = { 
          { 
            "filename", 
            path = 1,
            color = { bg = bg_color }
          } 
        },
        lualine_x = { 
          { 
            "encoding", 
            color = { bg = bg_color }
          },
          { 
            "fileformat", 
            color = { bg = bg_color }
          },
          { 
            "filetype", 
            color = { bg = bg_color }
          }
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
}
