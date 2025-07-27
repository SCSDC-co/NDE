local M = {}

-- Setup autocmds for file detection and prompting
function M.setup(config)
	-- Create autogroup for OptiSpec
	local augroup = vim.api.nvim_create_augroup("OptiSpec", { clear = true })

	-- File detection autocmd
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = augroup,
		callback = function(ev)
			-- Skip if prompts are disabled
			if not config.prompt.enabled then
				return
			end

			-- Get filetype
			local filetype = vim.bo[ev.buf].filetype
			if not filetype or filetype == "" then
				return
			end

			-- Check if language tools are already installed
			local languages_module = require("optispec.core.languages")
			local language = languages_module.get_language_for_filetype(filetype)

			if language and not languages_module.is_language_installed(language) then
				-- Ensure OptiSpec is fully initialized before showing prompts
				if _G.OptiSpec and _G.OptiSpec.config then
					local optispec = require("optispec")
					optispec.ensure_initialized()
				end

				-- Show prompt for installing language tools
				if config.prompt.auto_install then
					-- Auto install if enabled
					require("optispec.core.installer").install_language(language)
				else
					-- Show prompt
					require("optispec.ui.prompt").show_install_prompt(language, filetype)
				end
			end
		end,
	})
end

return M
