-- Code Runner Plugin - Universal code execution for NDE
-- Automatically detects file type and runs with appropriate compiler/interpreter

return {
	"CRAG666/code_runner.nvim",
	event = "VeryLazy",
	keys = {
		{ "<F8>", ":RunCode<CR>", desc = "🚀 Universal Code Runner" },
	},
	config = function()
		require("code_runner").setup({
			-- Use toggleterm for consistency with NDE
			mode = "toggleterm", -- Use toggleterm instead of built-in term
			focus = true, -- Focus on terminal when running
			startinsert = false, -- Don't auto-enter insert mode
			term = {
				position = "vertical", -- Vertical split like old F5-F8 shortcuts
				size = 70, -- Terminal width
			},
			float = {
				border = "rounded", -- Rounded borders for consistency
				height = 0.8,
				width = 0.8,
				x = 0.5,
				y = 0.5,
				border_hl = "FloatBorder",
				float_hl = "Normal",
			},
			-- Language-specific runners with NDE enhancements
			filetype = {
				-- Python: Enhanced with proper path handling
				python = "cd $dir && python3 $fileName",
				-- JavaScript/Node.js
				javascript = "cd $dir && node $fileName",
				typescript = "cd $dir && ts-node $fileName",
				-- C/C++: Optimized compilation with better flags
				c = "cd $dir && clang $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
				cpp = "cd $dir && g++ -std=c++17 $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
				-- Rust: Use cargo or rustc
				rust = {
					"cd $dir &&",
					"if [ -f Cargo.toml ]; then",
					"cargo run;",
					"else",
					"rustc $fileName && ./$fileNameWithoutExt;",
					"fi",
				},
				-- Go: Smart project detection
				go = {
					"cd $dir &&",
					"if [ -f go.mod ]; then",
					"go run .;",
					"else",
					"go run $fileName;",
					"fi",
				},
				-- Java: Automatic compilation and execution
				java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
				-- Assembly: NASM for x86_64
				asm = "cd $dir && nasm -f elf64 $fileName -o $fileNameWithoutExt.o && ld $fileNameWithoutExt.o -o $fileNameWithoutExt && ./$fileNameWithoutExt",
				nasm = "cd $dir && nasm -f elf64 $fileName -o $fileNameWithoutExt.o && ld $fileNameWithoutExt.o -o $fileNameWithoutExt && ./$fileNameWithoutExt",
				-- Shell scripting
				sh = "cd $dir && bash $fileName",
				bash = "cd $dir && bash $fileName",
				zsh = "cd $dir && zsh $fileName",
				-- Lua
				lua = "cd $dir && lua $fileName",
				-- Ruby
				ruby = "cd $dir && ruby $fileName",
				-- PHP
				php = "cd $dir && php $fileName",
				-- Perl
				perl = "cd $dir && perl $fileName",
				-- R
				r = "cd $dir && Rscript $fileName",
				-- Julia
				julia = "cd $dir && julia $fileName",
				-- Dart
				dart = "cd $dir && dart $fileName",
				-- Kotlin (requires kotlinc)
				kotlin = "cd $dir && kotlinc $fileName -include-runtime -d $fileNameWithoutExt.jar && java -jar $fileNameWithoutExt.jar",
				-- Scala
				scala = "cd $dir && scala $fileName",
				-- Swift
				swift = "cd $dir && swift $fileName",
				-- Haskell
				haskell = "cd $dir && ghc $fileName && ./$fileNameWithoutExt",
				-- Nim
				nim = "cd $dir && nim compile --run $fileName",
				-- Zig
				zig = "cd $dir && zig run $fileName",
				-- Markdown: Preview with glow (if available)
				markdown = "cd $dir && glow $fileName || cat $fileName",
				-- HTML: Open in browser
				html = "cd $dir && xdg-open $fileName || open $fileName",
			},
			-- Project-level runners
			project = {
				-- Node.js projects
				["package.json"] = "npm start",
				-- Rust projects
				["Cargo.toml"] = "cargo run",
				-- Go projects
				["go.mod"] = "go run .",
				-- Python projects with requirements
				["requirements.txt"] = "python3 main.py",
				-- Makefile projects
				["Makefile"] = "make run",
				["makefile"] = "make run",
				-- CMake projects
				["CMakeLists.txt"] = "mkdir -p build && cd build && cmake .. && make && ./main",
				-- Gradle projects
				["build.gradle"] = "gradle run",
				["build.gradle.kts"] = "gradle run",
				-- Maven projects
				["pom.xml"] = "mvn exec:java",
			},
		})

		-- Enhanced notifications for NDE
		local original_run = require("code_runner.commands").run_code
		require("code_runner.commands").run_code = function()
			local filetype = vim.bo.filetype
			local filename = vim.fn.expand("%:t")
			
			-- Show start notification
			vim.notify(
				"🚀 Running " .. filename .. " (" .. filetype .. ")",
				vim.log.levels.INFO,
				{ title = "Universal Code Runner", timeout = 2000 }
			)
			
			-- Run the original function
			original_run()
		end
	end,
}

