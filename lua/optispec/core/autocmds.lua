local M = {}

-- Track buffers that have already been prompted
local prompted_buffers = {}
-- Track buffers that have been declined (no re-prompting)
local declined_buffers = {}

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
				-- Create unique key for this buffer + language combination
				local buffer_key = ev.buf .. "_" .. language
				
				-- Skip if already prompted for this buffer or if declined
				if prompted_buffers[buffer_key] or declined_buffers[buffer_key] then
					return
				end
				
				-- Mark as prompted to prevent duplicates
				prompted_buffers[buffer_key] = true

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
					-- Show prompt with callback to handle decline
					require("optispec.ui.prompt").show_install_prompt(language, filetype, function(declined)
						if declined then
							-- Mark buffer as declined to prevent future prompts
							declined_buffers[buffer_key] = true
						end
					end)
				end
			end
		end,
	})
	
	-- Clean up tracking when buffers are deleted
	vim.api.nvim_create_autocmd("BufDelete", {
		group = augroup,
		callback = function(ev)
			-- Clean up all entries for this buffer
			for key, _ in pairs(prompted_buffers) do
				if key:match("^" .. ev.buf .. "_") then
					prompted_buffers[key] = nil
				end
			end
			for key, _ in pairs(declined_buffers) do
				if key:match("^" .. ev.buf .. "_") then
					declined_buffers[key] = nil
				end
			end
		end,
	})
end

-- Public API to clear declined buffers (useful for testing)
function M.clear_declined_buffers()
	declined_buffers = {}
end

-- Public API to clear prompted buffers (useful for testing)
function M.clear_prompted_buffers()
	prompted_buffers = {}
end

return M
