return {
  "monaqa/dial.nvim",
  keys = {
    { "<C-a>", function() require("dial.map").manipulate("increment", "normal") end, desc = "Increment" },
    { "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end, desc = "Decrement" },
    { "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, desc = "Increment (global)" },
    { "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, desc = "Decrement (global)" },
    { "<C-a>", function() require("dial.map").manipulate("increment", "visual") end, mode = "v", desc = "Increment" },
    { "<C-x>", function() require("dial.map").manipulate("decrement", "visual") end, mode = "v", desc = "Decrement" },
    { "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, mode = "v", desc = "Increment (global)" },
    { "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, mode = "v", desc = "Decrement (global)" },
  },
  config = function()
    local augend = require("dial.augend")
    
    require("dial.config").augends:register_group({
      default = {
        augend.integer.alias.decimal,   -- nonnegative decimal number (0, 1, 2, 3, ...)
        augend.integer.alias.hex,       -- nonnegative hex number  (0x01, 0x1a1f, etc.)
        augend.date.alias["%Y/%m/%d"],  -- date (2022/02/19, etc.)
        augend.date.alias["%Y-%m-%d"],  -- date (2022-02-19, etc.)
        augend.date.alias["%m/%d/%Y"],  -- date (02/19/2022, etc.)
        augend.date.alias["%H:%M"],     -- time (14:30, etc.)
        augend.constant.alias.bool,     -- boolean value (true <-> false)
        augend.constant.new{
          elements = {"and", "or"},
          word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
          cyclic = true,  -- "or" is incremented into "and".
        },
        augend.constant.new{
          elements = {"&&", "||"},
          word = false,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"yes", "no"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"on", "off"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"enable", "disable"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"enabled", "disabled"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"left", "right"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"up", "down"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"top", "bottom"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"width", "height"},
          word = true,
          cyclic = true,
        },
        augend.constant.new{
          elements = {"horizontal", "vertical"},
          word = true,
          cyclic = true,
        },
      },
      visual = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias["%Y/%m/%d"],
        augend.constant.alias.alpha,
        augend.constant.alias.Alpha,
      },
    })
  end,
}
