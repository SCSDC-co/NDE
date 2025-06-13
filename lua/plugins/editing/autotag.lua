return {
  "windwp/nvim-ts-autotag",
  lazy = true, -- ⚡ PERFORMANCE: Only load for web dev files
  ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte", "vue", "tsx", "jsx", "xml", "php", "markdown", "astro" },
  dependencies = "nvim-treesitter/nvim-treesitter",
  config = function()
    require('nvim-ts-autotag').setup({
      filetypes = {
        'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 
        'svelte', 'vue', 'tsx', 'jsx', 'rescript',
        'xml', 'php', 'markdown', 'astro', 'glimmer', 'handlebars', 'hbs'
      },
      skip_tags = {
        'area', 'base', 'br', 'col', 'embed', 'hr', 'img', 'input',
        'keygen', 'link', 'meta', 'param', 'source', 'track', 'wbr','menuitem'
      },
    })
  end,
}

