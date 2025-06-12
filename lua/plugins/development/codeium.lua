return {
	"Exafunction/codeium.vim",
	lazy = false, -- Force immediate loading
	priority = 1000,
	config = function()
		-- DISABLE VIM.SNIPPET DEFAULT MAPPINGS
		-- This is what was breaking Codeium Tab functionality!
		vim.keymap.del("i", "<Tab>", { silent = true })
		vim.keymap.del("i", "<S-Tab>", { silent = true })

		-- Enable Codeium with default Tab mapping
		vim.g.codeium_enabled = true
		vim.g.codeium_disable_bindings = 0 -- Let Codeium create its own mappings
		vim.g.codeium_no_map_tab = 0 -- Allow Codeium to map Tab

		-- Verify after a delay
		vim.defer_fn(function()
			local maps = vim.api.nvim_get_keymap("i")
			local found_codeium_tab = false

			for _, map in ipairs(maps) do
				if map.lhs == "<Tab>" and map.desc and map.desc:match("[Cc]odeium") then
					found_codeium_tab = true
					break
				end
			end

			if not found_codeium_tab then
				vim.keymap.set("i", "<Tab>", "codeium#Accept()", {
					expr = true,
					silent = true,
					desc = "Accept Codeium suggestion",
				})
			end

			-- Check Codeium status
			local status = vim.fn["codeium#GetStatusString"]()
		end, 1000)

		-- Alternative mappings for cycling suggestions
		vim.keymap.set("i", "<C-g>", function()
			return vim.fn["codeium#CycleCompletions"](1)
		end, { expr = true, silent = true, desc = "Next Codeium suggestion" })

		vim.keymap.set("i", "<C-;>", function()
			return vim.fn["codeium#CycleCompletions"](-1)
		end, { expr = true, silent = true, desc = "Previous Codeium suggestion" })

		vim.keymap.set("i", "<C-x>", function()
			return vim.fn["codeium#Clear"]()
		end, { expr = true, silent = true, desc = "Clear Codeium suggestion" })
	end,
}
