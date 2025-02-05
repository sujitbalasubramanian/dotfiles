return {
    { 'tpope/vim-commentary' },
    { 'tpope/vim-surround' },
    {
        "mbbill/undotree",

        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end
    },
    {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require("colorizer").setup {
                "*",
                "!txt"
            }
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require('ibl').setup()
        end
    }
}
