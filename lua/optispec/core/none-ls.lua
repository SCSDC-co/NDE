local M = {}

-- Get linter source (with language config priority)
local function get_linter_source(linter_name, language_config)
    -- First priority: Language-defined none-ls sources
    if language_config.none_ls_sources and language_config.none_ls_sources[linter_name] then
        local source_fn = language_config.none_ls_sources[linter_name]
        local ok, source = pcall(source_fn)
        if ok and source then
            return source
        end
    end
    
    -- Second priority: none-ls-extras
    local ok_extras, extras = pcall(require, "none-ls-extras")
    if ok_extras and extras.diagnostics and extras.diagnostics[linter_name] then
        return extras.diagnostics[linter_name]
    end
    
    -- Third priority: null-ls builtins (if they exist)
    local null_ls = require("null-ls")
    if null_ls.builtins.diagnostics[linter_name] then
        return null_ls.builtins.diagnostics[linter_name]
    end
    
    return nil
end

-- Setup none-ls with extras support
function M.setup(config)
    -- Add Mason bin to PATH so none-ls can find tools automatically
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
    vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

    local null_ls = require("null-ls")

    -- Initialize with empty sources (to be populated dynamically)
    null_ls.setup({
        sources = {},

        diagnostics_format = "#{m} [#{c}]",

        debounce = 250,

        update_in_insert = true,

        on_attach = function(client, bufnr)
            if config and config.on_attach then
                config.on_attach(client, bufnr)
            end
        end,

        capabilities = config and config.capabilities or vim.lsp.protocol.make_client_capabilities(),

        root_dir = require("null-ls.utils").root_pattern(
            ".null-ls-root",
            ".neoconf.json",
            "Makefile",
            ".git",
            "package.json",
            "Cargo.toml",
            "pyproject.toml",
            "setup.py",
            "requirements.txt",
            "go.mod",
            "composer.json"
        ),
    })

    M.null_ls = null_ls
end

-- Load linters for a language when it's activated
function M.load_language_linters(language_name)
    -- Check if linters are globally enabled
    local json_tracker = require("optispec.core.json_tracker")
    if not json_tracker.get_linters_status() then
        return false -- Linters are disabled
    end
    
    local languages_module = require("optispec.core.languages")
    local config = languages_module.get_language_config(language_name)

    if not config or not config.mason_tools or not config.mason_tools.linter then
        return false
    end

    local null_ls = M.null_ls
    if not null_ls then
        return false
    end

    local sources_to_add = {}

    for _, linter_name in ipairs(config.mason_tools.linter) do
        local source = get_linter_source(linter_name, config)
        if source then
            table.insert(sources_to_add, source)
            vim.notify(string.format("[OptiSpec] Added %s linter for %s", linter_name, language_name), vim.log.levels.INFO)
        else
            vim.notify(string.format("[OptiSpec] Linter %s not supported or not available for %s", linter_name, language_name), vim.log.levels.WARN)
        end
    end

    if #sources_to_add > 0 then
        null_ls.register(sources_to_add)
        return true
    end

    return false
end

M.plugins = {
    {
        "nvimtools/none-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            M.setup({})
        end,
    },
    {
        "nvimtools/none-ls-extras.nvim",
        dependencies = { "nvimtools/none-ls.nvim" },
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        "jay-babu/mason-null-ls.nvim",
        dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("mason-null-ls").setup({
                ensure_installed = nil,
                automatic_installation = false,
                handlers = {},
            })
        end,
    },
}

return M
