local M = {}

-- Store configuration
M.config = {}

-- Language mapping for syntax highlighting
local language_map = {
	lua = "lua",
	js = "javascript",
	ts = "typescript",
	py = "python",
	rs = "rust",
	go = "go",
	c = "c",
	cpp = "cpp",
	java = "java",
	cs = "csharp",
	php = "php",
	rb = "ruby",
	sh = "bash",
	zsh = "bash",
	fish = "fish",
	css = "css",
	html = "html",
	xml = "xml",
	json = "json",
	yaml = "yaml",
	yml = "yaml",
	toml = "toml",
	md = "markdown",
	cshtml = "html", -- Razor view files
	razor = "html",
}

-- Get output directory
local function get_output_dir()
	if M.config.output.dir then
		return M.config.output.dir
	end
	return os.getenv("XDG_PICTURES_DIR") or (os.getenv("HOME") .. "/Pictures")
end

-- Generate filename based on template
local function generate_filename(template, file_path, file_name, timestamp)
	local filename = template
	filename = filename:gsub("{timestamp}", timestamp)
	filename = filename:gsub("{filename}", file_name)
	filename = filename:gsub("{filepath}", file_path:gsub("/", "_"):gsub("^_", ""))
	return filename
end

-- Get window title
local function get_window_title(file_path, file_name)
	if M.config.output.use_full_path_title then
		return file_path
	else
		return file_name
	end
end

-- Build silicon command that also copies to the clipboard
local function build_silicon_cmd(file_path, file_name, language, output_file, temp_file)
	local silicon_cfg = M.config.silicon
	local window_title = get_window_title(file_path, file_name)
	
	local cmd_parts = {
		"silicon",
		"--background '" .. silicon_cfg.background .. "'",
		"--theme '" .. silicon_cfg.theme .. "'",
		"--font '" .. silicon_cfg.font .. "'",
		"--pad-vert " .. silicon_cfg.pad_vert,
		"--pad-horiz " .. silicon_cfg.pad_horiz,
		"--window-title '" .. window_title .. "'",
		"--language '" .. language .. "'",
		"--output '" .. output_file .. "'",
		"'" .. temp_file .. "'"
	}
	
	if not silicon_cfg.show_window_controls then
		table.insert(cmd_parts, #cmd_parts, "--no-window-controls")
	end
	
	return table.concat(cmd_parts, " ")
end

-- Main screenshot function
function M.take_screenshot(start_line, end_line)
	
	local file_path = vim.fn.expand("%:p")
	local file_name = vim.fn.expand("%:t")
	local timestamp = os.date("%Y-%m-%d-%H%M%S")
	local output_dir = get_output_dir()
	
	-- Ensure output directory exists
	vim.fn.mkdir(output_dir, "p")
	
	-- Generate output filename
	local output_filename = generate_filename(
		M.config.output.filename_template,
		file_path,
		file_name,
		timestamp
	)
	local output_file = output_dir .. "/" .. output_filename

	-- Get the lines to screenshot
	local selected_lines
	
	-- If line range is provided (from visual selection), use it
	if start_line and end_line and start_line > 0 and end_line > 0 then
		selected_lines = vim.fn.getline(start_line, end_line)
	else
		-- Fallback: try to get the last visual selection
		local vis_start = vim.fn.line("'<")
		local vis_end = vim.fn.line("'>")
		
		if vis_start > 0 and vis_end > 0 then
			selected_lines = vim.fn.getline(vis_start, vis_end)
		else
			-- No visual selection, use current line
			selected_lines = { vim.fn.getline(".") }
		end
	end
	
	-- Ensure we have at least one line
	if not selected_lines or #selected_lines == 0 then
		selected_lines = { vim.fn.getline(".") }
	end
	
	-- Create temporary file with selected content
	local temp_file = "/tmp/silicon_temp_" .. timestamp .. "." .. vim.fn.expand("%:e")

	-- Write selected content to temp file
	local file = io.open(temp_file, "w")
	if file then
		for _, line in ipairs(selected_lines) do
			file:write(line .. "\n")
		end
		file:close()
	else
		vim.notify("❌ Error: Could not create temporary file", vim.log.levels.ERROR)
		return
	end

	-- Detect language from file extension
	local file_ext = vim.fn.expand("%:e")
	local language = language_map[file_ext] or "text"

	-- Build and execute silicon command
	local silicon_cmd = build_silicon_cmd(file_path, file_name, language, output_file, temp_file)
	local result = vim.fn.system(silicon_cmd)

	-- Clean up temp file
	vim.fn.delete(temp_file)

	if vim.v.shell_error == 0 then
		local message = "📸 Screenshot saved to: " .. output_file
		
		-- Copy to clipboard using xclip (Linux) if enabled and screenshot was successful
		if M.config.output.copy_to_clipboard and vim.fn.has('unix') == 1 and vim.fn.executable('xclip') == 1 then
			-- Add a small delay to ensure file is fully written
			vim.defer_fn(function()
				local clipboard_result = vim.fn.system("xclip -selection clipboard -target image/png -in " .. vim.fn.shellescape(output_file))
				if vim.v.shell_error ~= 0 then
					vim.notify("⚠️  Failed to copy to clipboard: " .. clipboard_result, vim.log.levels.WARN)
				end
			end, 100) -- 100ms delay
			message = message .. "\n📋 Also copied to clipboard!"
		elseif M.config.output.copy_to_clipboard and vim.fn.has('unix') == 1 then
			message = message .. "\n⚠️  xclip not found - clipboard copy disabled"
		end
		
		vim.notify(message, vim.log.levels.INFO)
	else
		vim.notify("❌ Error taking screenshot: " .. result, vim.log.levels.ERROR)
	end
end

-- Setup function
function M.setup(config)
	M.config = config
end

return M
