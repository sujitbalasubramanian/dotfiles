local add, later = MiniDeps.add, MiniDeps.later

later(function()
  add {
    source = "nvim-treesitter/nvim-treesitter",
    -- Use 'master' while monitoring updates in 'main'
    checkout = "master",
    monitor = "main",
    -- Perform action after every checkout
    hooks = {
      post_checkout = function()
        vim.cmd "TSUpdate"
      end,
    },
  }

  require("nvim-treesitter.configs").setup {
    ensure_installed = {
      "vimdoc",
      "bash",
      "lua",
      "c",
      "cpp",
      "make",
      "cmake",
      "rust",
      "zig",
      "go",
      "dart",
      "html",
      "css",
      "jsdoc",
      "json",
      "html",
      "javascript",
      "typescript",
      "markdown",
      "markdown_inline",
      "latex",
    },
    sync_install = false,
    auto_install = true,
    indent = {
      enable = true,
    },
    highlight = {
      -- `false` will disable the whole extension
      enable = true,
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          vim.notify(
            "File larger than 100KB treesitter disabled for performance",
            vim.log.levels.WARN,
            { title = "Treesitter" }
          )
          return true
        end
      end,
      additional_vim_regex_highlighting = { "markdown" },
    },
  }
end)

later(function()
  add {
    source = "windwp/nvim-ts-autotag",
    depends = {
      "nvim-treesitter/nvim-treesitter",
    },
  }

  require("nvim-ts-autotag").setup()
end)

later(function()
  add {
    source = "nvim-treesitter/nvim-treesitter-context",
    depends = {
      "nvim-treesitter/nvim-treesitter",
    },
  }

  require("treesitter-context").setup()
end)

later(function()
  add {
    source = "JoosepAlviste/nvim-ts-context-commentstring",
    depends = {
      "nvim-treesitter/nvim-treesitter",
    },
  }

  require("ts_context_commentstring").setup {
    enable_autocmd = false,
  }

  local get_option = vim.filetype.get_option
  vim.filetype.get_option = function(filetype, option)
    return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
      or get_option(filetype, option)
  end
end)
