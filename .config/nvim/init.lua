-- FIXME: add hidden files support in telescope
local o = vim.opt
local g = vim.g
local km = vim.keymap.set

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
o.signcolumn = "yes"
o.guicursor = "n-v-c:block-Cursor,i-ci:ver25"

o.background = "dark"

g.netrw_banner = 0
g.netrw_liststyle = 0

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

-- autocmd
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "highlight when yanking text",
  group = vim.api.nvim_create_augroup("nvim-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
  spec = {
    -- also you can add custom dir
    -- "plugins",
    -- ui
    {
      "ellisonleao/gruvbox.nvim",
      priority = 1000,
      config = function()
        vim.cmd "colorscheme gruvbox"
      end,
    },
    { "nvim-mini/mini.statusline", opts = {}, dependencies = { { "nvim-mini/mini.icons", opts = {} } } },
    { "nvim-mini/mini.notify", opts = {} },
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
    -- tools
    { "nvim-mini/mini.pairs", opts = {} },
    { "nvim-mini/mini.surround", opts = {} },
    {
      "nvim-telescope/telescope.nvim",
      tag = "v0.1.9",
      lazy = false,
      dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      },
      config = function()
        require("telescope").setup {
          defaults = require("telescope.themes").get_ivy {},
        }

        local builtin = require "telescope.builtin"

        km("n", "<leader>ff", builtin.find_files)
        km("n", "<leader>fg", builtin.git_files)
        km("n", "<leader>fh", builtin.help_tags)
        km("n", "<leader>fw", builtin.grep_string)
        km("n", "<leader>fl", builtin.live_grep)
        km("n", "<leader>fb", builtin.buffers)
        km("n", "<leader>fd", builtin.diagnostics)
      end,
    },
    {
      "mbbill/undotree",
      keys = {
        { "<leader>u", "<CMD>UndotreeToggle<CR>", mode = "n", desc = "Undotree" },
      },
    },
    {
      "folke/todo-comments.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
      opts = {},
      lazy = false,
      keys = {
        { "<leader>tt", "<CMD>TodoTelescope<CR>", mode = "n", desc = "Todo finder" },
      },
    },
    { "MagicDuck/grug-far.nvim", opts = {} },
    -- vim wiki
    {
      "vimwiki/vimwiki",
      config = function()
        vim.cmd [[
        let g:vimwiki_list = [{'path': '~/Dropbox/Notes', 'syntax': 'markdown', 'ext': 'md'}]
        ]]
      end,
    },
    -- file management
    {
      "stevearc/oil.nvim",
      dependencies = { { "nvim-mini/mini.icons", opts = {} } },
      opts = {
        columns = { "icon", "permissions", "size", "mtime" },
        delete_to_trash = true,
        constrain_cursor = "editable",
        watch_for_changes = false,
        default_file_explorer = false,
      },
      keys = {
        { "-", "<CMD>Oil<CR>", mode = "n", desc = "Open parent directory" },
        { "<leader>-", "<CMD>Oil<CR>", mode = "n", desc = "Open parent directory" },
      },
      lazy = false,
    },
    -- color hilighter and picker
    {
      "eero-lehtinen/oklch-color-picker.nvim",
      event = "VeryLazy",
      version = "*",
      keys = {
        {
          "<leader>v",
          function()
            require("oklch-color-picker").pick_under_cursor()
          end,
          desc = "Color pick under cursor",
        },
      },
      opts = {
        highlight = {
          style = "foreground+virtual_left",
        },
      },
    },
    -- dadbod for dbs
    {
      "kristijanhusak/vim-dadbod-ui",
      dependencies = {
        { "tpope/vim-dadbod", lazy = true },
        { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
      },
      cmd = {
        "DBUI",
        "DBUIToggle",
        "DBUIAddConnection",
        "DBUIFindBuffer",
      },
      init = function()
        vim.g.db_ui_use_nerd_fonts = 1
      end,
    },
    -- diff viewer with git support
    {
      "nvim-mini/mini.diff",
      lazy = false,
      opts = {},
      keys = {
        {
          "<leader>dv",
          function()
            MiniDiff.toggle_overlay()
          end,
          desc = "Toggle Diff Overlay",
        },
      },
    },
    -- treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      dependencies = {
        { "nvim-treesitter/nvim-treesitter-context", opts = {} },
        {
          "JoosepAlviste/nvim-ts-context-commentstring",
          config = function()
            require("ts_context_commentstring").setup {
              enable_autocmd = false,
            }
            local get_option = vim.filetype.get_option
            vim.filetype.get_option = function(filetype, option)
              return option == "commentstring"
                  and require("ts_context_commentstring.internal").calculate_commentstring()
                or get_option(filetype, option)
            end
          end,
        },
        { "windwp/nvim-ts-autotag", opts = {} },
      },
      branch = "main",
      lazy = false,
      build = ":TSUpdate",
      opts = {
        ensure_installed = {},
        ignore_install = {},
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
      },
    },
    -- completion & snips
    {
      "L3MON4D3/LuaSnip",
      version = "2.*",
      run = "make install_jsregexp",
      dependencies = {
        {
          "rafamadriz/friendly-snippets",
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
          end,
        },
      },
      opts = {},
    },
    {
      "saghen/blink.cmp",
      version = "1.*",
      dependencies = {
        "rafamadriz/friendly-snippets",
        "kristijanhusak/vim-dadbod-completion",
      },
      opts = {
        appearance = { nerd_font_variant = "mono" },
        keymap = { preset = "default" },
        snippets = { preset = "luasnip" },
        completion = {
          documentation = { auto_show = false },
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
          per_filetype = {
            sql = { "snippets", "dadbod", "buffer" },
          },
          providers = {
            dadbod = {
              name = "Dadbod",
              module = "vim_dadbod_completion.blink",
            },
          },
        },
        fuzzy = {
          implementation = "prefer_rust_with_warning",
        },
      },
      opts_extend = { "sources.default" },
    },
    -- lsp config
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "mason-org/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "saghen/blink.cmp",
      },
      config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("nvim-lsp-attach", { clear = true }),
          callback = function(event)
            local map = function(keys, func, desc, mode)
              mode = mode or "n"
              vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
            end

            local builtin = require "telescope.builtin"

            map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
            map("gr", builtin.lsp_references, "[G]oto [R]eferences")
            map("gt", builtin.lsp_type_definitions, "[G]oto [T]ype Definition")
            map("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
            map("<leader>ds", builtin.lsp_document_symbols, "Open Document Symbols")
            map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "Open Workspace Symbols")

            map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
            map("K", vim.lsp.buf.hover, "Hover Documentation")
            map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
            map("<leader>ca", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

            local client = vim.lsp.get_client_by_id(event.data.client_id)
            local bufnr = event.buf

            if client and client.server_capabilities.documentHighlightProvider then
              local highlight_augroup = vim.api.nvim_create_augroup("nvim-lsp-highlight", { clear = false })

              vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                buffer = bufnr,
                group = highlight_augroup,
                callback = function()
                  vim.lsp.buf.document_highlight()
                end,
              })

              vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                buffer = bufnr,
                group = highlight_augroup,
                callback = function()
                  vim.lsp.buf.clear_references()
                end,
              })

              vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup("nvim-lsp-detach", { clear = true }),
                callback = function(event2)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds {
                    group = "nvim-lsp-highlight",
                    buffer = event2.buf,
                  }
                end,
              })
            end

            if client then
              map("<leader>th", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
              end, "[T]oggle Inlay [H]ints")
            end
          end,
        })

        vim.diagnostic.config {
          severity_sort = true,
          float = { border = "rounded", source = "if_many" },
          underline = { severity = vim.diagnostic.severity.ERROR },
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = "󰅚 ",
              [vim.diagnostic.severity.WARN] = "󰀪 ",
              [vim.diagnostic.severity.INFO] = "󰋽 ",
              [vim.diagnostic.severity.HINT] = "󰌶 ",
            },
          },
          virtual_text = {
            source = "if_many",
            spacing = 2,
            format = function(diagnostic)
              local diagnostic_message = {
                [vim.diagnostic.severity.ERROR] = diagnostic.message,
                [vim.diagnostic.severity.WARN] = diagnostic.message,
                [vim.diagnostic.severity.INFO] = diagnostic.message,
                [vim.diagnostic.severity.HINT] = diagnostic.message,
              }
              return diagnostic_message[diagnostic.severity]
            end,
          },
        }

        local capabilities = require("blink.cmp").get_lsp_capabilities()

        local servers = {
          clangd = {},
          gopls = {},
          pyright = {},
          rust_analyzer = {},
          ts_ls = {},
          lua_ls = {},
          astro = {},
          tailwindcss = {},
          emmet_ls = {},
          cssls = {},
        }

        local ensure_installed = vim.tbl_keys(servers or {})

        vim.list_extend(ensure_installed, {
          "stylua",
          "prettier",
          "goimports",
          "tex-fmt",
          "sqlfmt",
          "black",
          "sqlfluff",
          "golangci-lint",
          "pylint",
          "eslint_d",
        })

        require("mason-tool-installer").setup {
          ensure_installed = ensure_installed,
        }

        require("mason-lspconfig").setup {
          ensure_installed = {},
          automatic_installation = false,
          handlers = {
            function(server_name)
              local server = servers[server_name] or {}
              server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
              require("lspconfig")[server_name].setup(server)
            end,
          },
        }
      end,
    },
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    {
      "nvim-flutter/flutter-tools.nvim",
      lazy = false,
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      config = true,
    },
    -- formatter
    {
      "stevearc/conform.nvim",
      event = "BufWritePre",
      opts = {
        formatters_by_ft = {
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          astro = { "prettier" },
          json = { "jq" },
          yaml = { "prettier" },
          lua = { "stylua" },
          c = { "clang_format" },
          cpp = { "clang_format" },
          tex = { "tex-fmt" },
          go = { "gofmt", "goimports" },
          rust = { "rustfmt", lsp_format = "fallback" },
          python = { "black" },
          dockerfile = { "dockerfmt" },
          sql = { "sqlfmt" },
        },
        default_format_opts = {
          lsp_format = "fallback",
        },
        format_on_save = {
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        },
      },
      keys = {
        {
          "<leader>F",
          function()
            require("conform").format { lsp_fallback = true, timeout_ms = 1000, async = false }
          end,
          desc = "Format file or range (in visual mode)",
        },
      },
    },
    -- linting
    {
      "mfussenegger/nvim-lint",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        local lint = require "lint"

        lint.linters_by_ft = {
          javascript = { "eslint_d" },
          typescript = { "eslint_d" },
          javascriptreact = { "eslint_d" },
          typescriptreact = { "eslint_d" },
          css = { "prettier" },
          c = { "clangtidy" },
          cpp = { "clangtidy" },
          go = { "golangcilint" },
          rust = { "clippy" },
          python = { "pylint" },
          sql = { "sqlfluff" },
        }

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
          group = vim.api.nvim_create_augroup("lint", { clear = true }),
          callback = function()
            local ft = vim.bo.filetype
            if lint.linters_by_ft[ft] then
              lint.try_lint()
            end
          end,
        })

        vim.keymap.set("n", "<leader>l", function()
          lint.try_lint()
        end, { desc = "Trigger linting for current file" })
      end,
    },
    -- misc
    "vuciv/golf",
  },
}
