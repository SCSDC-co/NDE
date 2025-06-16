-- DAP will be loaded lazily when F1-F4 keys are pressed
-- local dap = require("dap")
-- local dapui = require("dapui")

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Emergency fix for leader j/k mappings
vim.keymap.set("n", "<space>j", function()
	local current_line = vim.fn.line(".")
	vim.fn.append(current_line, "")
	vim.cmd("normal! j")
end, { desc = "Nuova riga sotto", noremap = true, silent = true })

vim.keymap.set("n", "<space>k", function()
	local current_line = vim.fn.line(".")
	vim.fn.append(current_line - 1, "")
	vim.cmd("normal! k")
end, { desc = "Nuova riga sopra", noremap = true, silent = true })

-- Also set with <Leader> for compatibility
vim.keymap.set("n", "<Leader>j", function()
	local current_line = vim.fn.line(".")
	vim.fn.append(current_line, "")
	vim.cmd("normal! j")
end, { desc = "Nuova riga sotto", noremap = true, silent = true })

vim.keymap.set("n", "<Leader>k", function()
	local current_line = vim.fn.line(".")
	vim.fn.append(current_line - 1, "")
	vim.cmd("normal! k")
end, { desc = "Nuova riga sopra", noremap = true, silent = true })

-- Neotree keymaps are now handled by which-key.lua to avoid conflicts

-- Universal Code Runner (F8) - Handled by code-runner plugin
-- The plugin automatically detects file types and runs appropriate commands
-- See lua/plugins/development/code-runner.lua for configuration

-- debug - LAZY LOADED for performance
vim.keymap.set("n", "<F1>", function() require('dap').toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<F2>", function() require('dap').continue() end, { desc = "Continue" })
vim.keymap.set("n", "<F3>", function() require('dap').step_into() end, { desc = "Step Into" })
vim.keymap.set("n", "<F4>", function() require('dap').step_over() end, { desc = "Step Over" })

vim.keymap.set("n", "<leader>du", function() require('dapui').toggle() end, { desc = "Toggle DAP UI" })

vim.keymap.set("v", "<leader>ge", ":GpExplain<CR>", { desc = "Spiega il codice selezionato" })
vim.keymap.set("v", "<leader>gr", ":GpRewrite<CR>", { desc = "Riscrivi il codice selezionato" })
vim.keymap.set("n", "<leader>gc", ":GpChatNew<CR>", { desc = "Nuova chat AI" })

-- toggleterm
vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], { desc = "Move to left window" })
vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], { desc = "Move to right window" })
vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], { desc = "Move to down window" })
vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], { desc = "Move to up window" })

vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = "Go to left window" })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = "Go to below window" })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = "Go to above window" })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = "Go to right window" })

-- bufferline
vim.keymap.set('n', '<leader>bc', ':bdelete<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bo', ':BufferLineCloseOthers<CR>', { noremap = true, silent = true })

-- Surround shortcuts
vim.keymap.set('n', '<F9>', 'ysiw)', { desc = "Add parentheses around word", remap = true })
vim.keymap.set('n', '<F10>', 'ysiw"', { desc = "Add quotes around word", remap = true })

