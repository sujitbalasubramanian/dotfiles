local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function()
  add {
    source = "folke/zen-mode.nvim",
    depends = { "folke/twilight.nvim" },
  }

  require("zen-mode").setup {
    plugins = {
      twilight = { enabled = true },
    },
  }
end)

now(function()
  add { source = "vimwiki/vimwiki" }
  add { source = "iamcco/markdown-preview.nvim" }
  add {
    source = "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.nvim",
    },
  }

  require("render-markdown").setup {
    file_types = { "markdown", "vimwiki" },
  }

  vim.treesitter.language.register("markdown", "vimwiki")
end)
