require("mason").setup({
        registries = {
        "github:mason-org/mason-registry",
    }
})

require("mason-lspconfig").setup {
    ensure_installed = {
        "lua_ls","vimls", "bashls", "clangd",
        "gopls", "rust_analyzer","tsserver", 
        "jsonls","tailwindcss" ,
    },
    handlers = {
        function (server_name)
            require("lspconfig")[server_name].setup {}
        end
    }
}
