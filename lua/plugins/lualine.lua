local colors = {
   black = "#202126",
   green = "#008b2b",
   white = "#f3f3f3",
   transparent = "#000000"
}

local theme = {
   normal = {
      a = { bg = colors.green, fg = colors.black },
      b = { bg = colors.black, fg = colors.green },
      c = { bg = colors.transparent, fg = colors.white },
      x = { bg = colors.transparent, fg = colors.white },
      y = { bg = colors.black, fg = colors.green },
      z = { bg = colors.green, fg = colors.black },
   }
}

local function clock()
  return os.date("%H:%M:%S")
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, 
  config = function()
    require("lualine").setup({
      options = {
        theme = theme,
        icons_enabled = true,
        section_separators = { left = "◤", right = "◥" },
        component_separators = "|",
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics", clock },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
}
