return {
  "b0o/incline.nvim",
  event = "BufReadPre",
  priority = 1200,
  config = function()
    require("incline").setup({
      debounce_threshold = {
        falling = 50,
        rising = 10
      },
      hide = {
        cursorline = false,
        focused_win = false,
        only_win = false
      },
      highlight = {
        groups = {
          InclineNormal = {
            default = true,
            group = "NormalFloat"
          },
          InclineNormalNC = {
            default = true,
            group = "NormalFloat"
          }
        }
      },
      ignore = {
        buftypes = "special",
        filetypes = {},
        floating_wins = true,
        unlisted_buffers = true,
        wintypes = "special"
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if filename == "" then
          filename = "[No Name]"
        end
        
        local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
        local modified = vim.api.nvim_buf_get_option(props.buf, "modified")
        
        -- Get diagnostics for this buffer
        local diagnostics = vim.diagnostic.get(props.buf)
        local errors = #vim.tbl_filter(function(d) return d.severity == vim.diagnostic.severity.ERROR end, diagnostics)
        local warnings = #vim.tbl_filter(function(d) return d.severity == vim.diagnostic.severity.WARN end, diagnostics)
        local info = #vim.tbl_filter(function(d) return d.severity == vim.diagnostic.severity.INFO end, diagnostics)
        local hints = #vim.tbl_filter(function(d) return d.severity == vim.diagnostic.severity.HINT end, diagnostics)
        
        local result = {
          ft_icon and { " ", ft_icon, " ", guifg = ft_color } or "",
          " ",
          { filename, gui = modified and "bold,italic" or "bold" },
        }
        
        -- Add diagnostics
        if errors > 0 then
          table.insert(result, { " ", "󰅚 " .. errors, guifg = "#F7768E" })
        end
        if warnings > 0 then
          table.insert(result, { " ", "󰀪 " .. warnings, guifg = "#E0AF68" })
        end
        if info > 0 then
          table.insert(result, { " ", "󰋽 " .. info, guifg = "#0DB9D7" })
        end
        if hints > 0 then
          table.insert(result, { " ", "󰌶 " .. hints, guifg = "#1ABC9C" })
        end
        
        table.insert(result, " ")
        result.guibg = "#0D0C0C"
        
        return result
      end,
      window = {
        margin = {
          horizontal = 1,
          vertical = 1
        },
        options = {
          signcolumn = "no",
          wrap = false
        },
        padding = 1,
        padding_char = " ",
        placement = {
          horizontal = "right",
          vertical = "top"
        },
        width = "fit",
        winhighlight = {
          active = {
            EndOfBuffer = "None",
            Normal = "InclineNormal",
            Search = "None"
          },
          inactive = {
            EndOfBuffer = "None",
            Normal = "InclineNormalNC",
            Search = "None"
          }
        },
        zindex = 50
      }
    })
  end,
}
