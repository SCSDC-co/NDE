return {
	-- codeium
	{
		"Exafunction/codeium.nvim",
		cmd = "Codeium",
		event = "InsertEnter",
		build = ":Codeium Auth", -- This fixes authentication issues
		opts = {
			enable_cmp_source = true, -- Enable cmp integration
			virtual_text = {
				enabled = false, -- Disable since we're using cmp
				key_bindings = {
					accept = false, -- handled by nvim-cmp
					next = "<M-]>",
					prev = "<M-[>",
				},
			},
		},
	},
}
