local path_package = vim.fn.stdpath "data" .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd 'echo "Installing `mini.nvim`" | redraw'
  local clone_cmd = { "git", "clone", "--filter=blob:none", "https://github.com/echasnovski/mini.nvim", mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd "packadd mini.nvim | helptags ALL"
  vim.cmd 'echo "Installed `mini.nvim`" | redraw'
end

require("mini.deps").setup { path = { package = path_package } }
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

local o = vim.opt
local g = vim.g
local km = vim.keymap.set

-- remaps
g.mapleader = " "
g.localleader = "\\"

km({ "n", "v" }, "<leader>y", [["+y]])
km("n", "<leader>Y", [["+Y]])
km("n", "<leader>P", [["+p]])

km("v", "J", ":m '>+1<CR>gv=gv")
km("v", "K", ":m '<-2<CR>gv=gv")

km("n", "H", [[:bnext<CR>]])
km("n", "L", [[:bprev<CR>]])
km("n", "<leader>bd", [[:bdelete<cr>]])

km("n", "<leader><leader>", [[:so %<cr>]])
km("v", "<leader><leader>", [[:so<cr>]])

-- settings
o.syntax = "on"
o.nu = true
o.rnu = true

o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true

o.swapfile = false
o.backup = true
o.backupcopy = "yes"
o.backupdir = os.getenv "XDG_CACHE_HOME" .. "/nvim/backup"
o.undodir = os.getenv "XDG_CACHE_HOME" .. "/nvim/undodir"
o.undofile = true

o.scrolloff = 10
o.wrap = false
o.updatetime = 50
o.colorcolumn = "80"
o.cursorline = true
-- o.signcolumn = "yes"
o.guicursor = "n-v-c:block-Cursor,i-ci:ver25"

o.background = "dark"

g.netrw_banner = 0
g.netrw_liststyle = 0

vim.cmd [[
let g:vimwiki_list = [{'path': '~/Dropbox/Notes', 'syntax': 'markdown', 'ext': 'md'}]
]]

-- ui config
add { source = "ellisonleao/gruvbox.nvim" }
vim.cmd [[colo gruvbox]]

require("mini.notify").setup()
vim.notify = require("mini.notify").make_notify()

require("mini.icons").setup()

require("mini.statusline").setup()

-- tools
add { source = "stevearc/oil.nvim" }
require("oil").setup {
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime",
  },
  delete_to_trash = true,
  constrain_cursor = "editable",
  watch_for_changes = false,
}

km("n", "-", [[:Oil<cr>]])
km("n", "<leader>-", [[:Oil<cr>]])

add { source = "mbbill/undotree" }
km("n", "<leader>u", vim.cmd.UndotreeToggle)

add { source = "vimwiki/vimwiki" }

add { source = "MagicDuck/grug-far.nvim" }

add { source = "eero-lehtinen/oklch-color-picker.nvim" }
require("oklch-color-picker").setup {}

add { source = "tpope/vim-dadbod" }
add { source = "kristijanhusak/vim-dadbod-ui" }
vim.g.db_ui_use_nerd_fonts = 1

require("mini.pairs").setup()

require("mini.ai").setup()

require("mini.surround").setup()

require("mini.pick").setup()

require("mini.extra").setup()

km("n", "<leader>pf", [[:Pick files<cr>]])
km("n", "<leader>pb", [[:Pick buffers<cr>]])
km("n", "<leader>pg", [[:Pick grep_live<cr>]])

km("n", "<leader>pe", [[:Pick diagnostic<cr>]])
km("n", "<leader>ps", [[:Pick lsp scope="document_symbol"<cr>]])

-- TODO: impl hi patterns picker

require("mini.git").setup()
require("mini.diff").setup()

km("n", "<leader>gd", [[:lua MiniDiff.toggle_overlay()<cr>]])

-- completion & snippets
local function build_blink(params)
  vim.notify("Building blink.cmp", vim.log.levels.INFO)
  local obj = vim.system({ "cargo", "build", "--release" }, { cwd = params.path }):wait()
  if obj.code == 0 then
    vim.notify("Building blink.cmp done", vim.log.levels.INFO)
  else
    vim.notify("Building blink.cmp failed", vim.log.levels.ERROR)
  end
end

add {
  source = "Saghen/blink.cmp",
  depends = {
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "kristijanhusak/vim-dadbod-completion",
  },
  hooks = {
    post_install = build_blink,
    post_checkout = build_blink,
  },
}

require("luasnip.loaders.from_vscode").lazy_load()

require("blink.cmp").setup {
  keymap = { preset = "default" },
  snippets = { preset = "luasnip" },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
    providers = {
      dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
    },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
}

-- syntax highlighter
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

-- stylua: ignore
local langs = {
  "vimdoc", "bash", "lua", "c", "cpp", "make", "cmake", "rust", "zig", "go",
  "html", "css", "javascript", "typescript", "astro", "dart", "python", "sql",
  "toml", "xml","json", "yaml", "markdown", "markdown_inline", "latex",
}

require("nvim-treesitter.configs").setup {
  ensure_installed = langs,
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

add {
  source = "nvim-treesitter/nvim-treesitter-context",
  depends = {
    "nvim-treesitter/nvim-treesitter",
  },
}

require("treesitter-context").setup()

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

-- lsp config
add {
  source = "mason-org/mason-lspconfig.nvim",
  depends = {
    "mason-org/mason.nvim",
    "neovim/nvim-lspconfig",
  },
}

require("mason").setup()

local masonconfig = require "mason-lspconfig"

-- stylua: ignore
local lservers = {
  "ts_ls", "emmet_language_server", "tailwindcss", "astro", "pyright",
  "lua_ls", "clangd", "zls", "gopls", "rust_analyzer",
}

masonconfig.setup {
  ensure_installed = lservers,
  automatic_enable = false,
}

local capabilities = require("blink.cmp").get_lsp_capabilities()
local lspconfig = require "lspconfig"

local km = vim.keymap.set

km("n", "<leader>rn", vim.lsp.buf.rename)
km("n", "<leader>ca", vim.lsp.buf.code_action)
km("n", "[d", vim.diagnostic.goto_prev)
km("n", "]d", vim.diagnostic.goto_next)
km("n", "gd", vim.lsp.buf.definition)
km("n", "gD", vim.lsp.buf.declaration)

for _, server in ipairs(lservers) do
  lspconfig[server].setup {
    capabilities = capabilities,
  }
end

-- lang specfic plugins
add {
  source = "nvim-flutter/flutter-tools.nvim",
  depends = {
    "nvim-lua/plenary.nvim",
  },
}
require("flutter-tools").setup {}

-- formatter
later(function()
  add {
    source = "stevearc/conform.nvim",
  }
  local conform = require "conform"

  conform.setup {
    formatters_by_ft = {
      javascript = { "biome-check" },
      typescript = { "biome-check" },
      javascriptreact = { "biome-check" },
      typescriptreact = { "biome-check" },
      css = { "biome-check" },
      html = { "biome-check" },
      json = { "jq" },
      yaml = { "yq" },
      lua = { "stylua" },
      python = { "black" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      go = { "goimports", "gofmt" },
      tex = { "tex-fmt" },
      rust = { "rustfmt", lsp_format = "fallback" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = {
      lsp_fallback = true,
      async = false,
      timeout_ms = 500,
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

-- linter
later(function()
  add {
    source = "mfussenegger/nvim-lint",
  }
  local lint = require "lint"

  lint.linters_by_ft = {
    javascript = { "biomejs" },
    typescript = { "biomejs" },
    javascriptreact = { "biomejs" },
    typescriptreact = { "biomejs" },
    -- c = { "clang-tidy" },
    -- cpp = { "clang-tidy" },
    rust = { "clippy" },
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

-- misc
later(function()
  add { source = "vuciv/golf" }
end)
