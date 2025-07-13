-- autocommands.lua
-- Global autocommands for Neovim configuration

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.schedule(function()
			if vim.g.colors_name == "kanagawa" then
				-- Check which kanagawa theme variant is active
				local kanagawa_config = require("kanagawa").config
				if kanagawa_config and kanagawa_config.theme == "lotus" then
					-- Lotus theme colors
					for i = 1, 5 do
						vim.api.nvim_set_hl(0, "HLIndent" .. i, { fg = "#8A8A8A" })
						vim.api.nvim_set_hl(0, "HLChunk" .. i, { fg = "#2A2A37" })
					end
				else
					-- Dragon theme colors (default)
					for i = 1, 5 do
						vim.api.nvim_set_hl(0, "HLIndent" .. i, { fg = "#2a2a2a" })
						vim.api.nvim_set_hl(0, "HLChunk" .. i, { fg = "#FF9E3B" })
					end
				end
			end
		end)
	end,
})

-- this fixes the hlchunk colors when switching between themes
vim.defer_fn(function()
	if vim.g.colors_name == "kanagawa" then
		-- Check which kanagawa theme variant is active
		local kanagawa_config = require("kanagawa").config
		if kanagawa_config and kanagawa_config.theme == "lotus" then
			-- Lotus theme colors
			for i = 1, 5 do
				vim.api.nvim_set_hl(0, "HLIndent" .. i, { fg = "#8A8A8A" })
				vim.api.nvim_set_hl(0, "HLChunk" .. i, { fg = "#2A2A37" })
			end
		else
			-- Dragon theme colors (default)
			for i = 1, 5 do
				vim.api.nvim_set_hl(0, "HLIndent" .. i, { fg = "#2a2a2a" })
				vim.api.nvim_set_hl(0, "HLChunk" .. i, { fg = "#FF9E3B" })
			end
		end
	end
end, 200)
