return {
    {
        "OXY2DEV/markview.nvim",
        lazy = false,    -- Recommended
        ft = "markdown", -- If you decide to lazy-load anyway

        dependencies = {
            -- You will not need this if you installed the
            -- parsers manually
            -- Or if the parsers are in your $RUNTIMEPATH
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },

        init = function()
            require("markview").setup({
                highlight_groups = {
                },
                callbacks = {
                    on_enable = function(_, win)
                        vim.wo[win].conceallevel = 2;
                        vim.wo[win].concealcursor = "c";
                    end
                }
            })
        end
    },
    {
        "vimwiki/vimwiki",
        init = function()
            vim.g.vimwiki_list = {
                {
                    path = "~/Documents/wiki/",
                    syntax = "markdown",
                    ext = ".wiki"
                },
            }
            vim.g.vimwiki_ext2syntax = {
                [".md"] = "markdown",
                [".markdown"] = "markdown",
                [".mdown"] = "markdown",
            }
            vim.g.vimwiki_global_ext = 0
        end
    },
}
