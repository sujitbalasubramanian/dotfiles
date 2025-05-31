local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  add {
    source = "neovim/nvim-lspconfig",
    depends = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "rafamadriz/friendly-snippets",
    },
  }

  require("mason").setup()

  local masonconfig = require "mason-lspconfig"

  masonconfig.setup {
    ensure_installed = {
      "lua_ls",
      "ts_ls",
      "clangd",
    },
  }

  require("mini.completion").setup()

  require("mini.snippets").setup()
end)

later(function()
  add {
    source = "stevearc/conform.nvim",
  }
  -- later_on = { "BufReadPre", "BufNewFile" },
  local conform = require "conform"

  conform.setup {
    formatters_by_ft = {
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      graphql = { "prettier" },
      lua = { "stylua" },
    },
    format_on_save = {
      lsp_fallback = true,
      async = false,
      timeout_ms = 1000,
    },
  }

  vim.keymap.set({ "n", "v" }, "<leader>p", function()
    conform.format {
      lsp_fallback = true,
      async = false,
      timeout_ms = 1000,
    }
  end, { desc = "Format file or range (in visual mode)" })
end)

later(function()
  add {
    source = "mfussenegger/nvim-lint",
  }
  -- later_on = { "BufReadPre", "BufNewFile" },
  local lint = require "lint"

  lint.linters_by_ft = {
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescriptreact = { "eslint_d" },
  }

  local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function()
      lint.try_lint()
    end,
  })

  vim.keymap.set("n", "<leader>l", function()
    lint.try_lint()
  end, { desc = "Trigger linting for current file" })
end)
