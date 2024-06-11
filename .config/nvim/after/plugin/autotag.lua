require('nvim-autopairs').setup()

require('nvim-ts-autotag').setup({
    enable = true,
    filetypes = { 'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'xml', 'markdown' },
})
