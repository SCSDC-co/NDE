return {
    "Chiel92/vim-autoformat",

    config = function()
        vim.g.autoformat_verbosemode = 1

        vim.g.formatdef_black = '"black --quiet -"'               
        vim.g.formatdef_prettier = '"prettier --stdin-filepath %"'
        vim.g.formatdef_clangformat = '"clang-format"'            
        vim.g.formatdef_dotnet = '"dotnet format"'                
        vim.g.formatdef_asmfmt = '"asmfmt"'                

        vim.g.formatters_python = { "black" }
        vim.g.formatters_javascript = { "prettier" }
        vim.g.formatters_typescript = { "prettier" }
        vim.g.formatters_html = { "prettier" }
        vim.g.formatters_css = { "prettier" }
        vim.g.formatters_cpp = { "clangformat" }
        vim.g.formatters_c = { "clangformat" }
        vim.g.formatters_cs = { "dotnet" }
        vim.g.formatters_asm = { "asmfmt", "clangformat" }  

        vim.keymap.set("n", "<leader>f", ":Autoformat<CR>", { noremap = true, silent = true })

        vim.cmd([[
            autocmd BufRead,BufNewFile *.asm set filetype=asm
        ]])
    end
}
