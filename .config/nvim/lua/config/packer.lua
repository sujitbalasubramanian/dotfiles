-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use "ellisonleao/gruvbox.nvim"

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('nvim-treesitter/playground')
    use('theprimeagen/harpoon')

    use('mbbill/undotree')
    use('tpope/vim-fugitive')

    use("neovim/nvim-lspconfig")
    use("williamboman/mason.nvim")
    use("williamboman/mason-lspconfig.nvim")

    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-cmdline")
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-nvim-lsp-signature-help")
    use("saadparwaiz1/cmp_luasnip")

    use {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        tag = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!:).
        run = "make install_jsregexp"
    }
    use "rafamadriz/friendly-snippets"



    use {
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup()
        end
    }

    use("nvim-tree/nvim-web-devicons")
    use("nvim-tree/nvim-tree.lua")

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    use {
        'akinsho/bufferline.nvim',
        tag = "*",
        requires = 'nvim-tree/nvim-web-devicons'
    }

     use('airblade/vim-gitgutter')
     use('tpope/vim-commentary')
     use('tpope/vim-surround')

    use("windwp/nvim-autopairs")

    use('norcalli/nvim-colorizer.lua')

    use('vimwiki/vimwiki')
    use('preservim/vim-markdown')

    use {
        'akinsho/flutter-tools.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim', -- optional for vim.ui.select
        },
    }

    use('windwp/nvim-ts-autotag')

    use("lukas-reineke/indent-blankline.nvim")
end)
