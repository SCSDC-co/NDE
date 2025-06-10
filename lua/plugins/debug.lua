return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("mason-nvim-dap").setup({
        ensure_installed = {
          "python",
          "cppdbg",
          "codelldb",     -- C/C++/Rust
          "js-debug-adapter",
          "node-debug2-adapter",
          "chrome-debug-adapter",
          "go-debug-adapter", -- Go
          "java-debug-adapter", -- Java
          "bash-debug-adapter", -- Bash
        },
        automatic_installation = true,
      })

      dapui.setup()

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })

      -- Python
      require("dap-python").setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")

      -- C / C++
      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/packages/cppdbg/extension/debugAdapters/bin/OpenDebugAD7",
      }

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "cppdbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = true,
        },
      }

      dap.configurations.c = dap.configurations.cpp

      -- JavaScript
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = 8123,
        executable = {
          command = "js-debug-adapter",
          args = { "--port", "8123" },
        },
      }

      dap.configurations.javascript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch JS file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
      }

      dap.configurations.typescript = dap.configurations.javascript

      -- Rust (using codelldb)
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.rust = {
        {
          name = "Launch Rust",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      -- Go
      dap.adapters.go = {
        type = "executable",
        command = "go-debug-adapter",
      }

      dap.configurations.go = {
        {
          type = "go",
          name = "Debug",
          request = "launch",
          program = "${file}",
          dlvToolPath = vim.fn.exepath("dlv"),
        },
        {
          type = "go",
          name = "Debug Package",
          request = "launch",
          program = "${fileDirname}",
          dlvToolPath = vim.fn.exepath("dlv"),
        },
        {
          type = "go",
          name = "Debug test",
          request = "launch",
          mode = "test",
          program = "${file}",
          dlvToolPath = vim.fn.exepath("dlv"),
        },
      }

      -- Java
      dap.configurations.java = {
        {
          type = "java",
          request = "attach",
          name = "Debug (Attach) - Remote",
          hostName = "127.0.0.1",
          port = 5005,
        },
        {
          type = "java",
          request = "launch",
          name = "Debug (Launch) - Current File",
          mainClass = "${file}",
        },
      }

      -- Bash
      dap.adapters.bashdb = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
        name = "bashdb",
      }

      dap.configurations.sh = {
        {
          type = "bashdb",
          request = "launch",
          name = "Launch file",
          showDebugOutput = true,
          pathBashdb = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
          pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
          trace = true,
          file = "${file}",
          program = "${file}",
          cwd = "${workspaceFolder}",
          pathCat = "cat",
          pathBash = "/bin/bash",
          pathMkfifo = "mkfifo",
          pathPkill = "pkill",
          args = {},
          env = {},
          terminalKind = "integrated",
        },
      }
    end,
  },
  -- Additional debugging plugins
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension("dap")
    end,
  },
}
