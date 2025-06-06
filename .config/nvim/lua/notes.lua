local now, add = MiniDeps.now, MiniDeps.add

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
