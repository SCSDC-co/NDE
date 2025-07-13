return {
	{
		"hrsh7th/nvim-cmp",
		lazy = true, -- ⚡ PERFORMANCE: Only load when typing
		event = "InsertEnter", -- ⚡ PERFORMANCE: Only load when typing
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-emoji",
			"f3fora/cmp-spell",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim",
			"Exafunction/codeium.nvim",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"brenoprata10/nvim-highlight-colors",
		},
		config = function()
			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
			require("lspconfig").util.default_config =
				vim.tbl_extend("force", require("lspconfig").util.default_config, { capabilities = capabilities })
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			require("luasnip.loaders.from_vscode").lazy_load()

			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				performance = {
					trigger_debounce_time = 500,
					throttle = 550,
					fetching_timeout = 80,
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = {
						border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
						scrollbar = true,
						side_padding = 0,
						col_offset = -3,
						winhighlight = "Normal:CmpPmenu,FloatBorder:CmpBorder,CursorLine:CmpSel,Search:None,PmenuSbar:CmpScrollbar,PmenuThumb:CmpScrollbarThumb",
					},
					documentation = {
						border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
						winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
						max_width = 80,
						max_height = 12,
					},
				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, vim_item)
						-- 🎨 First, get color information from nvim-highlight-colors
						local color_item = require("nvim-highlight-colors").format(entry, { kind = vim_item.kind })
						local lspkind_icons = {
							Text = "󰉿",
							Method = "󰆧",
							Function = "󰊕",
							Constructor = "󰒓",
							Field = "󰜢",
							Variable = "󰀫",
							Class = "󰠱",
							Interface = "󰜰",
							Module = "󰆧",
							Property = "󰜢",
							Unit = "󰑭",
							Value = "󰎠",
							Enum = "󰕘",
							Keyword = "󰌋",
							Snippet = "󰩫",
							Color = "󰏘",
							File = "󰈙",
							Reference = "󰈇",
							Folder = "󰉋",
							EnumMember = "󰖽",
							Constant = "󰏿",
							Struct = "󰙅",
							Event = "󱐋",
							Operator = "󰆕",
							TypeParameter = "󰅲",
							Codeium = "󰚩",
							Supermaven = "󰦉",
							Avante = "󰧑",
						}

						local kind = vim_item.kind
						local icon = lspkind_icons[kind] or ""

						-- Cool source menu icons
						local menu_icon = {
							supermaven = "󰚩",
							nvim_lsp = "λ",
							luasnip = "⋗",
							buffer = "Ω",
							path = "󰉋",
							nvim_lua = "Π",
							calc = "󰃬",
							emoji = "󰞅",
							spell = "✓",
							codeium = "󰚩",
							avante = "󰚩",
						}

						-- Enhanced kind formatting with background colors
						local kind_colors = {
							Text = "CmpItemKindText",
							Method = "CmpItemKindMethod",
							Function = "CmpItemKindFunction",
							Constructor = "CmpItemKindConstructor",
							Field = "CmpItemKindField",
							Variable = "CmpItemKindVariable",
							Class = "CmpItemKindClass",
							Interface = "CmpItemKindInterface",
							Module = "CmpItemKindModule",
							Property = "CmpItemKindProperty",
							Unit = "CmpItemKindUnit",
							Value = "CmpItemKindValue",
							Enum = "CmpItemKindEnum",
							Keyword = "CmpItemKindKeyword",
							Snippet = "CmpItemKindSnippet",
							Color = "CmpItemKindColor",
							File = "CmpItemKindFile",
							Reference = "CmpItemKindReference",
							Folder = "CmpItemKindFolder",
							EnumMember = "CmpItemKindEnumMember",
							Constant = "CmpItemKindConstant",
							Struct = "CmpItemKindStruct",
							Event = "CmpItemKindEvent",
							Operator = "CmpItemKindOperator",
							TypeParameter = "CmpItemKindTypeParameter",
							Codeium = "CmpItemKindCodeium",
						}

						-- Format with cool styling
						vim_item.kind = string.format("%s %s", icon, kind)
						vim_item.menu = menu_icon[entry.source.name] or ""
						vim_item.kind_hl_group = kind_colors[kind] or "CmpItemKind"
						vim_item.menu_hl_group = "CmpItemMenu"

						-- 🎨 Apply color highlighting if available
						if color_item.abbr_hl_group then
							vim_item.kind_hl_group = color_item.abbr_hl_group
							vim_item.kind = color_item.abbr
						end

						-- Smart truncation with ellipsis
						local max_width = 40
						if #vim_item.abbr > max_width then
							vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. "…"
						end

						return vim_item
					end,
				},
				mapping = {
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-y>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
					["<C-j>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-k>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				},
				sources = cmp.config.sources({
					{ name = "supermaven", priority = 1200 },
					{ name = "codeium", priority = 1100 },
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "luasnip", priority = 750 },
					{ name = "nvim_lua", priority = 500 },
					{ name = "path", priority = 300 },
				}, {
					{ name = "buffer", priority = 250, keyword_length = 3 },
					{ name = "calc", priority = 150 },
					{ name = "emoji", priority = 100 },
					{ name = "spell", priority = 100 },
				}),
				experimental = {
					ghost_text = {
						hl_group = "Comment",
					},
				},
			})

			-- Cmdline completions
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})

			-- Note: Avante automatically registers its cmp sources:
			-- - avante_commands (for /commands in Avante input)
			-- - avante_mentions (for @mentions in Avante input)
			-- - avante_files (for file references in Avante input)
			-- These work in AvanteInput and AvantePromptInput filetypes

			-- 🚀 DYNAMIC SELECTION MAGIC! 🚀
			local function setup_dynamic_selection()
				local cmp = require("cmp")
				local orig_select_next = cmp.select_next_item
				local orig_select_prev = cmp.select_prev_item

				local function update_selection_highlight()
					local entry = cmp.get_selected_entry()
					if entry and entry.completion_item and entry.completion_item.kind then
						local kind = vim.lsp.protocol.CompletionItemKind[entry.completion_item.kind] or "Text"
						local sel_group = "CmpItemKind" .. kind .. "Sel"
						local sel_hl = vim.api.nvim_get_hl(0, { name = sel_group })
						if sel_hl and next(sel_hl) then
							-- Update selection highlight
							vim.api.nvim_set_hl(0, "CmpSel", sel_hl)

							-- 🌈 DYNAMIC SCROLLBAR MAGIC! Make scrollbar match selected item color! 🌈
							if sel_hl.bg then
								vim.api.nvim_set_hl(0, "PmenuThumb", { bg = sel_hl.bg })
								vim.api.nvim_set_hl(0, "CmpScrollbarThumb", { bg = sel_hl.bg })
							end
						end
					end
				end

				cmp.select_next_item = function(...)
					orig_select_next(...)
					vim.defer_fn(update_selection_highlight, 1)
				end

				cmp.select_prev_item = function(...)
					orig_select_prev(...)
					vim.defer_fn(update_selection_highlight, 1)
				end
			end

			-- Initialize dynamic selection after a short delay
			vim.defer_fn(setup_dynamic_selection, 100)

		end,
	},
}
