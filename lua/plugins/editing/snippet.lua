return {
  "L3MON4D3/LuaSnip",
  event = "InsertEnter",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node
    local c = ls.choice_node
    local fmt = require("luasnip.extras.fmt").fmt
    local rep = require("luasnip.extras").rep

    -- Load friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Helper functions
    local function filename()
      return vim.fn.expand("%:t:r")
    end

    local function current_date()
      return os.date("%Y-%m-%d")
    end

    local function current_user()
      return os.getenv("USER") or "Developer"
    end

    -- Python Snippets
    ls.add_snippets("python", {
      -- Python class with docstring
      s("class", fmt([[
        class {}:
            """
            {}
            
            Attributes:
                {}: {}
            """
            
            def __init__(self{}):
                {}
                
            def __str__(self):
                return "{}"
                
            def __repr__(self):
                return "{}({})"
      ]], {
        i(1, "ClassName"),
        i(2, "Class description"),
        i(3, "attribute_name"),
        i(4, "Description of the attribute"),
        i(5),
        i(6, "pass"),
        i(7, "String representation"),
        rep(1),
        i(8, "attribute_values"),
      })),

      -- Python function with docstring and type hints
      s("def", fmt([[
        def {}({}){} -> {}:
            """
            {}
            
            Args:
                {}: {}
                
            Returns:
                {}: {}
            """
            {}
            return {}
      ]], {
        i(1, "function_name"),
        i(2, "param: type"),
        i(3),
        i(4, "return_type"),
        i(5, "Function description"),
        i(6, "param"),
        i(7, "Parameter description"),
        i(8, "return_type"),
        i(9, "Return description"),
        i(10, "# Implementation"),
        i(11, "result"),
      })),

      -- Python dataclass
      s("dataclass", fmt([[
        from dataclasses import dataclass
        from typing import {}
        
        @dataclass
        class {}:
            """{}"""
            {}: {}
            {}: {} = {}
            
            def __post_init__(self):
                {}
      ]], {
        i(1, "Optional, List, Dict"),
        i(2, "ClassName"),
        i(3, "Class description"),
        i(4, "required_field"),
        i(5, "str"),
        i(6, "optional_field"),
        i(7, "int"),
        i(8, "0"),
        i(9, "# Validation or initialization logic"),
      })),

      -- Python async function
      s("async", fmt([[
        async def {}({}){} -> {}:
            """
            {}
            """
            {}
            return {}
      ]], {
        i(1, "async_function"),
        i(2, "param: type"),
        i(3),
        i(4, "return_type"),
        i(5, "Async function description"),
        i(6, "# Async implementation"),
        i(7, "result"),
      })),
    })

    -- JavaScript/TypeScript Snippets
    local js_ts_snippets = {
      -- React functional component
      s("rfc", fmt([[
        import React{} from 'react';
        {}
        
        interface {}Props {{
          {}
        }}
        
        const {}: React.FC<{}Props> = ({{ {} }}) => {{
          {}
          
          return (
            <div className="{}">
              {}
            </div>
          );
        }};
        
        export default {};
      ]], {
        i(1, ", { useState, useEffect }"),
        i(2, "// import styles or other dependencies"),
        i(3, filename()),
        i(4, "// Define props here"),
        i(5, filename()),
        rep(3),
        i(6, "// Destructure props"),
        i(7, "// Component logic"),
        i(8, "container"),
        i(9, "Hello World"),
        rep(5),
      })),

      -- React hook
      s("hook", fmt([[
        import {{ useState, useEffect{} }} from 'react';
        
        export const use{} = ({}){} => {{
          const [state, setState] = useState({});
          {}
          
          useEffect(() => {{
            {}
          }}, [{}]);
          
          return {{
            {},
            {}
          }};
        }};
      ]], {
        i(1, ", useCallback"),
        i(2, "CustomHook"),
        i(3, "initialValue"),
        i(4, ": HookReturnType"),
        i(5, "initialValue"),
        i(6, "// Additional state and logic"),
        i(7, "// Effect logic"),
        i(8, "dependencies"),
        i(9, "state"),
        i(10, "setState"),
      })),

      -- TypeScript interface
      s("interface", fmt([[
        interface {} {{
          {}: {};
          {}?: {};
          {}({}): {};
        }}
      ]], {
        i(1, "InterfaceName"),
        i(2, "requiredProp"),
        i(3, "string"),
        i(4, "optionalProp"),
        i(5, "number"),
        i(6, "methodName"),
        i(7, "param: type"),
        i(8, "returnType"),
      })),

      -- Arrow function
      s("arrow", fmt([[
        const {} = ({}) => {{
          {}
          return {};
        }};
      ]], {
        i(1, "functionName"),
        i(2, "params"),
        i(3, "// Implementation"),
        i(4, "result"),
      })),
    }
    
    -- Add JavaScript/TypeScript snippets to each filetype
    for _, ft in ipairs({"javascript", "typescript", "javascriptreact", "typescriptreact"}) do
      ls.add_snippets(ft, js_ts_snippets)
    end

    -- Rust Snippets
    ls.add_snippets("rust", {
      -- Rust struct with implementation
      s("struct", fmt([[
        #[derive(Debug, Clone{})]
        pub struct {} {{
            pub {}: {},
            {}: {},
        }}
        
        impl {} {{
            pub fn new({}) -> Self {{
                Self {{
                    {}: {},
                    {}: {},
                }}
            }}
            
            pub fn {}(&self) -> {} {{
                {}
            }}
        }}
      ]], {
        i(1, ", PartialEq, Eq"),
        i(2, "StructName"),
        i(3, "public_field"),
        i(4, "String"),
        i(5, "private_field"),
        i(6, "i32"),
        rep(2),
        i(7, "public_field: String, private_field: i32"),
        i(8, "public_field"),
        i(9, "public_field"),
        i(10, "private_field"),
        i(11, "private_field"),
        i(12, "get_field"),
        i(13, "&str"),
        i(14, "&self.public_field"),
      })),

      -- Rust error enum
      s("error", fmt([[
        use std::fmt;
        
        #[derive(Debug, Clone)]
        pub enum {}Error {{
            {}(String),
            {}({}),
            Custom(String),
        }}
        
        impl fmt::Display for {}Error {{
            fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {{
                match self {{
                    {}Error::{}(msg) => write!(f, "{}: {{}}", msg),
                    {}Error::{}(err) => write!(f, "{}: {{}}", err),
                    {}Error::Custom(msg) => write!(f, "Custom error: {{}}", msg),
                }}
            }}
        }}
        
        impl std::error::Error for {}Error {{}}
        
        pub type {}Result<T> = Result<T, {}Error>;
      ]], {
        i(1, "My"),
        i(2, "InvalidInput"),
        i(3, "Parse"),
        i(4, "ParseIntError"),
        rep(1),
        rep(1),
        rep(2),
        i(5, "Invalid input error"),
        rep(1),
        rep(3),
        i(6, "Parse error"),
        rep(1),
        rep(1),
        rep(1),
        rep(1),
      })),

      -- Rust async function
      s("async", fmt([[
        pub async fn {}({}) -> Result<{}, {}> {{
            {}
            Ok({})
        }}
      ]], {
        i(1, "async_function"),
        i(2, "param: Type"),
        i(3, "ReturnType"),
        i(4, "Error"),
        i(5, "// Async implementation"),
        i(6, "result"),
      })),
    })

    -- Go Snippets
    ls.add_snippets("go", {
      -- Go struct with methods
      s("struct", fmt([[
        // {} represents {}
        type {} struct {{
            {} {}
            {} {}
        }}
        
        // New{} creates a new {} instance
        func New{}({} {}) *{} {{
            return &{} {{
                {}: {},
                {}: {},
            }}
        }}
        
        // {} returns string representation
        func (s *{}) String() string {{
            return fmt.Sprintf("{}{{{}:%v, {}:%v}}", s.{}, s.{})
        }}
      ]], {
        i(1, "Person"),             -- {1} struct comment name
        i(2, "a person entity"),     -- {2} struct description
        rep(1),                     -- {3} struct name
        i(3, "Name"),               -- {4} first field name
        i(4, "string"),             -- {5} first field type
        i(5, "Age"),                -- {6} second field name
        i(6, "int"),                -- {7} second field type
        rep(1),                     -- {8} constructor comment name
        rep(1),                     -- {9} constructor return type
        rep(1),                     -- {10} constructor name
        i(7, "name string, age int"), -- {11} constructor params
        rep(1),                     -- {12} constructor return type
        rep(1),                     -- {13} struct literal type
        rep(3),                     -- {14} first field assignment name
        i(8, "name"),               -- {15} first field param name
        rep(5),                     -- {16} second field assignment name
        i(9, "age"),                -- {17} second field param name
        i(10, "String"),            -- {18} method comment
        rep(1),                     -- {19} method receiver type
        rep(1),                     -- {20} format string struct name
        rep(3),                     -- {21} format first field name
        rep(5),                     -- {22} format second field name
        rep(3),                     -- {23} access first field
        rep(5),                     -- {24} access second field
        rep(1),                     -- {25} final struct name in format
      })),

      -- Go HTTP handler
      s("handler", fmt([[
        func {}Handler(w http.ResponseWriter, r *http.Request) {{
            if r.Method != http.Method{} {{
                http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
                return
            }}
            
            {}
            
            w.Header().Set("Content-Type", "application/json")
            w.WriteHeader(http.StatusOK)
            json.NewEncoder(w).Encode(map[string]interface{}{{
                "status":  "success",
                "message": "{}",
                "data":    {},
            }})
        }}
      ]], {
        i(1, "Example"),
        i(2, "GET"),
        i(3, "// Handler logic"),
        i(4, "Operation completed successfully"),
        i(5, "result"),
        i(6, "nil"), -- Added missing 6th placeholder for the final closing brace
      })),

      -- Go error handling
      s("iferr", fmt([[
        if err != nil {{
            {}
        }}
      ]], {
        c(1, {
          t("return err"),
          t("return nil, err"),
          t("log.Fatal(err)"),
          fmt("return {}, fmt.Errorf(\"{}: %w\", err)", {i(1, "nil"), i(2, "operation failed")}),
        }),
      })),
    })

    -- C/C++ Snippets
    local c_cpp_snippets = {
      -- C++ class
      s("class", fmt([[
        #pragma once
        
        class {} {{
        private:
            {} {};
            {} {};
            
        public:
            // Constructor
            {}({});
            
            // Destructor
            virtual ~{}();
            
            // Getters
            {} get{}() const {{ return {}; }}
            {} get{}() const {{ return {}; }}
            
            // Setters
            void set{}(const {}& value) {{ {} = value; }}
            void set{}(const {}& value) {{ {} = value; }}
            
            // Other methods
            void {};
        }};
      ]], {
        i(1, "ClassName"),
        i(2, "int"),
        i(3, "member1_"),
        i(4, "std::string"),
        i(5, "member2_"),
        rep(1),
        i(6, "int member1, const std::string& member2"),
        rep(1),
        rep(2),
        i(7, "Member1"),
        rep(3),
        rep(4),
        i(8, "Member2"),
        rep(5),
        i(9, "Member1"),
        rep(2),
        rep(3),
        i(10, "Member2"),
        rep(4),
        rep(5),
        i(11, "doSomething()"),
      })),

      -- C header guard
      s("guard", fmt([[
        #ifndef {}_H
        #define {}_H
        
        #ifdef __cplusplus
        extern "C" {{
        #endif
        
        {}
        
        #ifdef __cplusplus
        }}
        #endif
        
        #endif // {}_H
      ]], {
        f(function() return string.upper(filename()) end),
        f(function() return string.upper(filename()) end),
        i(1, "// Your code here"),
        f(function() return string.upper(filename()) end),
      })),
    }
    
    -- Add C/C++ snippets to each filetype
    for _, ft in ipairs({"c", "cpp"}) do
      ls.add_snippets(ft, c_cpp_snippets)
    end

    -- Lua Snippets
    ls.add_snippets("lua", {
      -- Lua module
      s("module", fmt([[
        ---@class {}
        local M = {{}}
        
        ---Creates a new {} instance
        ---@param {} {} {}
        ---@return {} {}
        function M.new({})
            local self = {{
                {} = {},
            }}
            setmetatable(self, {{ __index = M }})
            return self
        end
        
        ---{}
        ---@param {} {} {}
        ---@return {} {}
        function M:{}({})
            {}
        end
        
        return M
      ]], {
        i(1, "ModuleName"),
        rep(1),
        i(2, "param"),
        i(3, "string"),
        i(4, "Description"),
        rep(1),
        i(5, "Description"),
        rep(2),
        i(6, "field"),
        i(7, "value"),
        i(8, "Method description"),
        i(9, "self"),
        i(10, "table"),
        i(11, "Description"),
        i(12, "any"),
        i(13, "Return description"),
        i(14, "method_name"),
        i(15, "param"),
        i(16, "-- Method implementation"),
      })),

      -- Neovim plugin setup
      s("plugin", fmt([[
        return {{
          "{}",
          {}
          event = "{}",
          dependencies = {{
            "{}",
          }},
          config = function()
            require("{}").setup({{
              {}
            }})
          end,
        }}
      ]], {
        i(1, "author/plugin-name"),
        i(2, "lazy = true,"),
        i(3, "VeryLazy"),
        i(4, "dependency-plugin"),
        i(5, "plugin-name"),
        i(6, "-- Configuration options"),
      })),

      -- Neovim autocmd
      s("autocmd", fmt([[
        vim.api.nvim_create_autocmd("{}", {{
          pattern = {{ "{}" }},
          callback = function({})
            {}
          end,
          desc = "{}"
        }})
      ]], {
        i(1, "BufWritePre"),
        i(2, "*"),
        i(3, "args"),
        i(4, "-- Your code here"),
        i(5, "Description"),
      })),
    })

    -- HTML Snippets
    ls.add_snippets("html", {
      -- HTML5 boilerplate
      s("html5", fmt([[
        <!DOCTYPE html>
        <html lang="{}">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta name="description" content="{}">
            <title>{}</title>
            <link rel="stylesheet" href="{}">
        </head>
        <body>
            <header>
                <nav>
                    {}
                </nav>
            </header>
            
            <main>
                {}
            </main>
            
            <footer>
                {}
            </footer>
            
            <script src="{}"></script>
        </body>
        </html>
      ]], {
        i(1, "en"),
        i(2, "Page description"),
        i(3, "Page Title"),
        i(4, "styles.css"),
        i(5, "<!-- Navigation content -->"),
        i(6, "<!-- Main content -->"),
        i(7, "<!-- Footer content -->"),
        i(8, "script.js"),
      })),

      -- React component template
      s("component", fmt([[
        <div className="{}">
          <h{} className="{}">{}</h{}>
          <p className="{}">
            {}
          </p>
          <button 
            className="{}"
            onClick={{{}}}
          >
            {}
          </button>
        </div>
      ]], {
        i(1, "component-container"),
        i(2, "1"),
        i(3, "component-title"),
        i(4, "Component Title"),
        rep(2),
        i(5, "component-description"),
        i(6, "Component description"),
        i(7, "component-button"),
        i(8, "handleClick"),
        i(9, "Click Me"),
      })),
    })

    -- SQL Snippets
    ls.add_snippets("sql", {
      -- SELECT query
      s("select", fmt([[
        SELECT {}
        FROM {}
        WHERE {}
        ORDER BY {}
        LIMIT {};
      ]], {
        i(1, "*"),
        i(2, "table_name"),
        i(3, "condition"),
        i(4, "column ASC"),
        i(5, "10"),
      })),

      -- CREATE TABLE
      s("table", fmt([[
        CREATE TABLE {} (
            {} {} PRIMARY KEY,
            {} {} NOT NULL,
            {} {} DEFAULT {},
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        );
      ]], {
        i(1, "table_name"),
        i(2, "id"),
        i(3, "BIGINT AUTO_INCREMENT"),
        i(4, "name"),
        i(5, "VARCHAR(255)"),
        i(6, "status"),
        i(7, "ENUM('active', 'inactive')"),
        i(8, "'active'"),
      })),
    })

    -- Set LuaSnip configuration
    ls.config.setup({
      history = true,
      updateevents = "TextChanged,TextChangedI",
      enable_autosnippets = true,
      ext_opts = {
        [require("luasnip.util.types").choiceNode] = {
          active = {
            virt_text = { { "●", "DiagnosticHint" } }
          }
        }
      }
    })

    -- Key mappings for snippet navigation (using C-f/C-b to avoid all conflicts)
    vim.keymap.set({"i", "s"}, "<C-f>", function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      end
    end, { desc = "Expand or jump to next snippet placeholder" })

    vim.keymap.set({"i", "s"}, "<C-b>", function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, { desc = "Jump to previous snippet placeholder" })

    vim.keymap.set("i", "<C-e>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, { desc = "Cycle through snippet choices" })

    vim.notify("🎯 Awesome snippets loaded! Use <C-f>/<C-b> to navigate, <C-e> for choices", vim.log.levels.INFO)
  end,
}
