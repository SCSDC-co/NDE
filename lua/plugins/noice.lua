return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        opts = {
          winblend = 0,
          winhighlight = {
            Normal      = "NoiceCmdlinePopup",
            FloatBorder = "NoiceCmdlinePopupBorder",
            NormalFloat = "NoiceCmdlinePopup",
          },
        },
      },
      notify = {
        enabled = true,
        opts = {
          winblend = 0,
          winhighlight = {
            Normal      = "NoiceNotify",
            FloatBorder = "NoiceNotifyBorder",
          },
        },
      },
      messages = {
        enabled = true,
        view = "notify",
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"]              = true,
          ["cmp.entry.get_documentation"]                 = true,
        },
      },
      presets = {
        bottom_search         = true,
        command_palette       = true,
        long_message_to_split = true,
      },
      highlights = {
        Cmdline                  = { fg = "#008B2B", bg = "#000000" },
        CmdlineBorder            = { fg = "#008B2B", bg = "#000000" },
        CmdlineIcon              = { fg = "#008B2B", bg = "#000000" },
        CmdlinePopup             = { fg = "#008B2B", bg = "#000000" },
        CmdlinePopupBorder       = { fg = "#008B2B", bg = "#000000" },
        CmdlinePopupTitle        = { fg = "#008B2B", bg = "#000000" },
        CmdlinePopupPrompt       = { fg = "#008B2B", bg = "#000000" },
        CmdlinePopupIcon         = { fg = "#008B2B", bg = "#000000" },
        Popup                    = { fg = "#008B2B", bg = "#000000" },
        PopupBorder              = { fg = "#008B2B", bg = "#000000" },
        Popupmenu                = { fg = "#008B2B", bg = "#000000" },
        PopupmenuBorder          = { fg = "#008B2B", bg = "#000000" },
        PopupmenuMatch           = { fg = "#008B2B", bg = "#000000" },
        Confirm                  = { fg = "#008B2B", bg = "#000000" },
        ConfirmBorder            = { fg = "#008B2B", bg = "#000000" },
        FormatConfirm            = { fg = "#008B2B", bg = "#000000" },
        Mini                     = { fg = "#008B2B", bg = "#000000" },
        Cursor                   = { fg = "#008B2B", bg = "#000000" },
        LspProgressClient        = { fg = "#008B2B", bg = "#000000" },
        LspProgressSpinner       = { fg = "#008B2B", bg = "#000000" },
        LspProgressTitle         = { fg = "#008B2B", bg = "#000000" },
        CompletionItemKindDefault = { fg = "#008B2B", bg = "#000000" },
        CompletionItemKindClass   = { fg = "#008B2B", bg = "#000000" },
        CompletionItemKindColor   = { fg = "#008B2B", bg = "#000000" },
        CompletionItemKindConstant = { fg = "#008B2B", bg = "#000000" },
        CompletionItemKindConstructor = { fg = "#008B2B", bg = "#000000" },
        CompletionItemKindEnum     = { fg = "#008B2B", bg = "#000000" },
        CompletionItemKindEnumMember = { fg = "#008B2B", bg = "#000000" },
        CompletionItemKindField    = { fg = "#008B2B", bg = "#000000" },
        CompletionItemKindFile     = { fg = "#008B2B", bg = "#000000" },
        CompletionItemKindFolder   = { fg = "#008B2B", bg = "#000000" },
        CompletionItemKindFunction = { fg = "#008B2B", bg = "#000000" },
        CompletionItemKindUnit     = { fg = "#008B2B", bg = "#000000" },
        CompletionItemKindValue    = { fg = "#008B2B", bg = "#000000" },
        CompletionItemKindVariable = { fg = "#008B2B", bg = "#000000" },
        CompletionItemMenu         = { fg = "#008B2B", bg = "#000000" },
        CompletionItemWord         = { fg = "#008B2B", bg = "#000000" },
        Notify                      = { fg = "#008B2B", bg = "#000000" },
        NotifyBorder                = { fg = "#008B2B", bg = "#000000" },
        NotifyERRORTitle            = { fg = "#FF0000", bg = "#000000" },
        NotifyERRORBody             = { fg = "#FF0000", bg = "#000000" },
        NotifyERRORBorder           = { fg = "#FF0000", bg = "#000000" },
        NotifyWARNTitle             = { fg = "#008B2B", bg = "#000000" },
        NotifyWARNBody              = { fg = "#008B2B", bg = "#000000" },
        NotifyWARNBorder            = { fg = "#008B2B", bg = "#000000" },
        NotifyINFOTitle             = { fg = "#008B2B", bg = "#000000" },
        NotifyINFOBody              = { fg = "#008B2B", bg = "#000000" },
        NotifyINFOBorder            = { fg = "#008B2B", bg = "#000000" },
        NotifyDEBUGTitle            = { fg = "#008B2B", bg = "#000000" },
        NotifyDEBUGBody             = { fg = "#008B2B", bg = "#000000" },
        NotifyDEBUGBorder           = { fg = "#008B2B", bg = "#000000" },
        NotifyTRACETitle            = { fg = "#008B2B", bg = "#000000" },
        NotifyTRACEBody             = { fg = "#008B2B", bg = "#000000" },
        NotifyTRACEBorder           = { fg = "#008B2B", bg = "#000000" },
        NotifyBackground            = { bg = "#000000" },
      },
    })

    local function force_colours()
      vim.api.nvim_set_hl(0, "NoiceCmdline",              { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCmdlineBorder",        { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCmdlineIcon",          { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopup",         { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder",   { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopupTitle",    { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopupPrompt",   { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopupIcon",     { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoicePopup",                { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoicePopupBorder",          { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoicePopupmenu",            { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoicePopupmenuBorder",      { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceConfirm",              { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceConfirmBorder",        { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceFormatConfirm",        { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceMini",                 { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCursor",               { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceLspProgressClient",    { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceLspProgressSpinner",   { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceLspProgressTitle",     { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCompletionItemKindDefault", { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCompletionItemKindClass",   { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCompletionItemKindColor",   { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCompletionItemKindConstant", { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCompletionItemKindConstructor", { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCompletionItemKindEnum",     { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCompletionItemKindEnumMember", { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCompletionItemKindField",    { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCompletionItemKindFile",     { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCompletionItemKindFolder",   { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCompletionItemKindFunction", { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCompletionItemKindUnit",     { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCompletionItemKindValue",    { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCompletionItemKindVariable", { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCompletionItemMenu",         { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceCompletionItemWord",         { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceNotify",                     { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceNotifyBorder",               { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NoiceNotifyError",                { fg = "#FF0000", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NotifyERRORTitle",                { fg = "#FF0000", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NotifyERRORBody",                 { fg = "#FF0000", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NotifyERRORBorder",               { fg = "#FF0000", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NotifyWARNTitle",                 { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NotifyWARNBody",                  { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NotifyWARNBorder",                { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NotifyINFOTitle",                 { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NotifyINFOBody",                  { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NotifyINFOBorder",                { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NotifyDEBUGTitle",                { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NotifyDEBUGBody",                 { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NotifyDEBUGBorder",               { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NotifyTRACETitle",                { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NotifyTRACEBody",                 { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NotifyTRACEBorder",               { fg = "#008B2B", bg = "#000000" })
      vim.api.nvim_set_hl(0, "NotifyBackground",                { bg = "#000000" })
    end

    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = force_colours,
    })

    force_colours()
  end,
}
