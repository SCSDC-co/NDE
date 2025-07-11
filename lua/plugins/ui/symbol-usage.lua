return {
  "Wansmer/symbol-usage.nvim",
  event = "LspAttach",
  config = function()
    require("symbol-usage").setup({
      ---@type 'above'|'end_of_line'|'textwidth'|'signcolumn'
      vt_position = "end_of_line",
      
      -- Request references and definitions on buffer change
      request_pending_text = "…",
      
      -- Show references count in bubble
      references = {
        enabled = true,
        include_declaration = false,
      },
      
      -- Show definition count in bubble
      definition = {
        enabled = true,
      },
      
      -- Show implementation count in bubble
      implementation = {
        enabled = true,
      },
      
      -- Disable for specific filetypes
      disable = {
        filetypes = { "TelescopePrompt", "neo-tree", "aerial", "dashboard", "alpha" },
        cond = {},
      },
      
      -- Text configuration for bubble display
      text_format = function(symbol)
        local res = {}
        
        -- Add references bubble
        if symbol.references then
          local usage = symbol.references <= 1 and "usage" or "usages"
          table.insert(res, ("󰌹 %s %s"):format(symbol.references, usage))
        end
        
        -- Add definition bubble
        if symbol.definition then
          if #res > 0 then
            table.insert(res, " ")
          end
          table.insert(res, ("󰳽 %s"):format(symbol.definition))
        end
        
        -- Add implementation bubble
        if symbol.implementation then
          if #res > 0 then
            table.insert(res, " ")
          end
          table.insert(res, ("󰡱 %s"):format(symbol.implementation))
        end
        
        return table.concat(res)
      end,
      
      -- Symbol types to track
      kinds = {
        vim.lsp.protocol.SymbolKind.Function,
        vim.lsp.protocol.SymbolKind.Method,
        vim.lsp.protocol.SymbolKind.Constructor,
        vim.lsp.protocol.SymbolKind.Class,
        vim.lsp.protocol.SymbolKind.Interface,
        vim.lsp.protocol.SymbolKind.Module,
        vim.lsp.protocol.SymbolKind.Struct,
        vim.lsp.protocol.SymbolKind.Enum,
        vim.lsp.protocol.SymbolKind.Variable,
        vim.lsp.protocol.SymbolKind.Constant,
      },
      
      -- Logging level
      log_level = vim.log.levels.ERROR,
    })
  end,
}
