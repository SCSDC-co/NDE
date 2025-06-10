-- DISABLED: nvim-lint causes duplicate diagnostics with LSP servers
-- We're using only native LSP servers for diagnostics now
return {}

-- Original nvim-lint config commented out to prevent conflicts:
--[[
return {
	"mfussenegger/nvim-lint",
	enabled = false,  -- DISABLED to prevent diagnostic conflicts
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- Configuration disabled
	end,
}
--]]
