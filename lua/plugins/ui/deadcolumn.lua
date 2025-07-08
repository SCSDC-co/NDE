return {
  "Bekaboo/deadcolumn.nvim",
  event = { "BufRead", "BufNewFile" },
  config = function()
    local opts = {
      scope = 'line', ---@type string|fun(): integer
      ---@type string[]|boolean|fun(mode: string): boolean
      modes = function(mode)
        return mode:find('^[iRss\x13]') ~= nil
      end,
      blending = {
        threshold = 0.5,
        colorcode = '#000000',
        hlgroup = { 'Normal', 'bg' },
      },
      warning = {
        alpha = 0.4,
        offset = 0,
        colorcode = '#FF0000',
        hlgroup = { 'Error', 'bg' },
      },
      extra = {
        ---@type string?
        follow_tw = nil,
      },
    }
    
    require('deadcolumn').setup(opts)
  end,
}
