local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

local function build_blink(params)
  vim.notify('Building blink.cmp', vim.log.levels.INFO)
  local obj = vim.system({ 'cargo', 'build', '--release' }, { cwd = params.path }):wait()
  if obj.code == 0 then
    vim.notify('Building blink.cmp done', vim.log.levels.INFO)
  else
    vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
  end
end

now(function()
  add({
    source = 'Saghen/blink.cmp',
    depends = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    hooks = {
      post_install = build_blink,
      post_checkout = build_blink,
    },
  })

  require("luasnip.loaders.from_vscode").lazy_load()

  require('blink.cmp').setup {
    keymap = { preset = 'default' },
    snippets = { preset = "luasnip" },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" }
  }

  add {
    source = "neovim/nvim-lspconfig",
    build = "cargo build --release",
    depends = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "Saghen/blink.cmp",
    },
  }

  require("mason").setup()

  local masonconfig = require "mason-lspconfig"

  masonconfig.setup {
    ensure_installed = {
      "lua_ls",
      "ts_ls",
      "clangd",
      "astro",
    },
    automatic_enable = false,
  }

  local capabilities = require('blink.cmp').get_lsp_capabilities()
  local lspconfig = require('lspconfig')

  lspconfig['lua_ls'].setup({
    capabilities = capabilities
  })

  lspconfig['ts_ls'].setup({
    capabilities = capabilities
  })

  -- lspconfig['astro'].setup({
  --   capabilities = capabilities
  -- })

  lspconfig['clangd'].setup({
    capabilities = capabilities
  })
end)

later(function()
  add {
    source = "stevearc/conform.nvim",
  }
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
      astro = { "prettier" },
      lua = { "stylua" },
      c = { "clang-format" },
      cpp = { "clang-format" },
    },
    format_on_save = {
      lsp_fallback = true,
      async = false,
      timeout_ms = 1000,
    },
  }

  vim.keymap.set({ "n", "v" }, "<leader>f", function()
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
  local lint = require "lint"

  lint.linters_by_ft = {
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    cpp = { "cpplint" },
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
