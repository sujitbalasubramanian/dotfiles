local o = vim.opt
local g = vim.g
local km = vim.keymap.set
local packadd = vim.pack.add

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

vim.cmd [[ colo catppuccin ]]

-- =========
-- PACKAGES
-- =========

-- vimwiki for notes
packadd { "https://github.com/vimwiki/vimwiki" }
vim.cmd [[ let g:vimwiki_list = [{'path': '~/Dropbox/Notes', 'syntax': 'markdown', 'ext': 'md'}] ]]

-- mini.nvim
packadd {
  "https://github.com/nvim-mini/mini.statusline",
  "https://github.com/nvim-mini/mini.notify",
  "https://github.com/nvim-mini/mini.surround",
  "https://github.com/nvim-mini/mini.diff",
  "https://github.com/nvim-mini/mini.icons",
}

require("mini.statusline").setup()
require("mini.notify").setup()
require("mini.surround").setup()
require("mini.diff").setup()

km("n", "<leader>dv", MiniDiff.toggle_overlay, { desc = "Diffview toggle" })

-- git integration
packadd {
  "https://github.com/NeogitOrg/neogit",
  "https://github.com/nvim-lua/plenary.nvim",
}
km("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit UI" })

-- grug-far: find and replace
packadd { "https://github.com/MagicDuck/grug-far.nvim" }

-- oil: file explorer
packadd { "https://github.com/stevearc/oil.nvim" }
require("oil").setup {
  columns = { "icon", "permissions", "size", "mtime" },
  delete_to_trash = true,
  constrain_cursor = "editable",
  watch_for_changes = false,
  default_file_explorer = false,
}
km("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
km("n", "<leader>-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- floke's snacks & todo-comments
packadd {
  "https://github.com/folke/snacks.nvim",
  "https://github.com/folke/todo-comments.nvim",
}

require("todo-comments").setup()

local snacks = require "snacks"

snacks.setup {
  input = { enabled = true },
  picker = {
    enabled = true,
    actions = {
      opencode_send = function(...)
        return require("opencode").snacks_picker_send(...)
      end,
    },
    win = {
      input = {
        keys = {
          ["<c-l>"] = { "opencode_send", mode = { "n", "i" } },
        },
      },
    },
  },
}

km("n", "<leader>ff", snacks.picker.files, { desc = "Find Files" })
km("n", "<leader>fg", snacks.picker.git_files, { desc = "Git Files" })
km("n", "<leader>fh", snacks.picker.help, { desc = "Help Pages" })
km("n", "<leader>fb", snacks.picker.buffers, { desc = "Find Buffer" })
km("n", "<leader>e", snacks.picker.explorer, { desc = "Buffer Diagnostics" })
km("n", "<leader>fl", snacks.picker.grep, { desc = "Live grep" })
km("n", "<leader>fw", snacks.picker.grep_word, { desc = "Grep string (under cursor)" })
km("n", "<leader>fm", snacks.picker.man, { desc = "Man Pages" })
km("n", "<leader>tt", function()
  snacks.picker.todo_comments()
end, { desc = "Todo/Fix/Fixme finder" })

-- csvview
packadd { "https://github.com/hat0uma/csvview.nvim" }
require("csvview").setup {
  parser = { comments = { "#", "//" } },
  keymaps = {
    textobject_field_inner = { "if", mode = { "o", "x" } },
    textobject_field_outer = { "af", mode = { "o", "x" } },
    jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
    jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
    jump_next_row = { "<Enter>", mode = { "n", "v" } },
    jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
  },
}

-- colorizer
packadd { "https://github.com/brenoprata10/nvim-highlight-colors" }
require("nvim-highlight-colors").setup {}
o.termguicolors = true

-- dadbod DBUI
packadd {
  "https://github.com/tpope/vim-dadbod",
  "https://github.com/kristijanhusak/vim-dadbod-ui",
  "https://github.com/kristijanhusak/vim-dadbod-completion",
}
g.db_ui_use_nerd_fonts = 1
g.db_ui_save_location = os.getenv "XDG_CACHE_HOME" .. "/nvim/dbui"

-- treesitter syntax highlighting, comments and autopairs
packadd {
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/joosepalviste/nvim-ts-context-commentstring",
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/windwp/nvim-ts-autotag",
}

require("nvim-treesitter").setup {
  ensure_installed = {},
  ignore_install = {},
  sync_install = false,
  auto_install = true,
  indent = { enable = true },
  highlight = {
    enable = true,
    disable = function(_, buf)
      local max_filesize = 100 * 1024
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

require("treesitter-context").setup()
require("ts_context_commentstring").setup { enable_autocmd = false }

local get_option = vim.filetype.get_option
vim.filetype.get_option = function(filetype, option)
  return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
    or get_option(filetype, option)
end

require("nvim-autopairs").setup()
require("nvim-ts-autotag").setup()

-- blink.cmp and LuaSnip
packadd {
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/rafamadriz/friendly-snippets",
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range "1.*" },
}

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip").setup()

require("blink.cmp").setup {
  appearance = { nerd_font_variant = "mono" },
  keymap = { preset = "default" },
  snippets = { preset = "luasnip" },
  completion = {
    documentation = { auto_show = false },
    menu = {
      draw = {
        components = {
          -- customize the drawing of kind icons
          kind_icon = {
            text = function(ctx)
              -- default kind icon
              local icon = ctx.kind_icon
              -- if LSP source, check for color derived from documentation
              if ctx.item.source_name == "LSP" then
                local color_item = require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                if color_item and color_item.abbr ~= "" then
                  icon = color_item.abbr
                end
              end
              return icon .. ctx.icon_gap
            end,
            highlight = function(ctx)
              -- default highlight group
              local highlight = "BlinkCmpKind" .. ctx.kind
              -- if LSP source, check for color derived from documentation
              if ctx.item.source_name == "LSP" then
                local color_item = require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                if color_item and color_item.abbr_hl_group then
                  highlight = color_item.abbr_hl_group
                end
              end
              return highlight
            end,
          },
        },
      },
    },
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
  fuzzy = { implementation = "prefer_rust_with_warning" },
}

-- LSP
packadd {
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/neovim/nvim-lspconfig",
}

vim.diagnostic.config {
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  virtual_text = {
    source = "if_many",
    spacing = 2,
    format = function(diagnostic)
      return diagnostic.message
    end,
  },
}

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("nvim-lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    -- pickers
    map("<leader>fd", snacks.picker.diagnostics, "Project Diagnostics")
    map("<leader>fD", snacks.picker.diagnostics_buffer, "Buffer Diagnostics")
    map("gd", snacks.picker.lsp_definitions, "Goto Definition")
    map("gr", snacks.picker.lsp_references, "References")
    map("gt", snacks.picker.lsp_type_definitions, "Goto Type Definition")
    map("gI", snacks.picker.lsp_implementations, "Goto Implementation")
    map("<leader>ds", snacks.picker.lsp_symbols, "Document Symbols")
    map("<leader>ws", snacks.picker.lsp_workspace_symbols, "Workspace Symbols")

    -- Other
    map("gD", vim.lsp.buf.declaration, "Goto Declaration")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("<leader>rn", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
    map("<leader>do", vim.diagnostic.open_float, "Diagnostic Open")

    local function yank_diagnostic_under_cursor()
      local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
      if #diagnostics > 0 then
        vim.fn.setreg("+", diagnostics[1].message)
        print "Copied diagnostic to clipboard"
      else
        print "No diagnostic found under cursor"
      end
    end

    map("<leader>dy", yank_diagnostic_under_cursor, "Diagnostic Yank")

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
      end, "Toggle Inlay Hints")
    end
  end,
})

local capabilities = require("blink.cmp").get_lsp_capabilities()

require("mason").setup()

require("mason-tool-installer").setup {
  ensure_installed = {
    "clangd",

    "pyright",
    "ruff",

    "lua_ls",
    "stylua",

    "ts_ls",
    "prettier",
    "biome",
    "tailwindcss",
    "emmet_ls",
    "cssls",
    "astro",

    "gopls",
    "goimports",
    "golangci-lint",

    "rust_analyzer",

    "sqlfmt",
    "sqlfluff",
    "tex-fmt",
    "taplo",
  },
}

require("mason-lspconfig").setup {
  ensure_installed = {},
  automatic_installation = false,
  handlers = {
    function(server_name)
      require("lspconfig")[server_name].setup { capabilities = capabilities }
    end,
  },
}

-- conform: formatting
packadd { "https://github.com/stevearc/conform.nvim" }
require("conform").setup {
  formatters_by_ft = {
    javascript = { "biome" },
    typescript = { "biome" },
    javascriptreact = { "biome" },
    typescriptreact = { "biome" },
    css = { "prettier" },
    html = { "prettier" },
    astro = { "prettier" },
    json = { "jq" },
    yaml = { "prettier" },
    vimwiki = { "prettier" },
    lua = { "stylua" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    cmake = { "cmake_format" },
    tex = { "tex-fmt" },
    go = { "gofmt", "goimports" },
    rust = { "rustfmt", lsp_format = "fallback" },
    python = { "ruff_fix", "ruff_format" },
    dockerfile = { "dockerfmt" },
    sql = { "sqlfmt" },
    toml = { "taplo" },
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

-- nvim-lint: linting
packadd { "https://github.com/mfussenegger/nvim-lint" }
local lint = require "lint"

lint.linters_by_ft = {
  c = { "clangtidy" },
  cpp = { "clangtidy" },
  go = { "golangcilint" },
  rust = { "clippy" },
  python = { "ruff" },
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

-- agent and inline completion
packadd {
  "https://github.com/github/copilot.vim",
}

vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
})

packadd {
  "https://github.com/nickjvandyke/opencode.nvim",
}

g.opencode_opts = {}
o.autoread = true

local opencode = require "opencode"

km({ "n", "x" }, "<C-a>", function()
  opencode.ask("@this: ", { submit = true })
end, { desc = "Ask opencode…" })
km({ "n", "x" }, "<C-x>", function()
  opencode.select()
end, { desc = "Execute opencode action…" })
km({ "n", "t" }, "<C-.>", function()
  opencode.toggle()
end, { desc = "Toggle opencode" })

km({ "n", "x" }, "go", function()
  return opencode.operator "@this "
end, { desc = "Add range to opencode", expr = true })
km("n", "goo", function()
  return opencode.operator "@this " .. "_"
end, { desc = "Add line to opencode", expr = true })

km("n", "<S-C-u>", function()
  opencode.command "session.half.page.up"
end, { desc = "Scroll opencode up" })
km("n", "<S-C-d>", function()
  opencode.command "session.half.page.down"
end, { desc = "Scroll opencode down" })

-- custom functions
local function clean_unused_pack()
  local unused_plugins = {}

  for _, plugin in ipairs(vim.pack.get()) do
    if not plugin.active then
      table.insert(unused_plugins, plugin.spec.name)
    end
  end

  if #unused_plugins == 0 then
    print "No unused plugins."
    return
  end

  print "Unused plugins:"
  print(table.concat(unused_plugins, "\n"))

  if vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2) == 1 then
    vim.pack.del(unused_plugins)
  end
end

km("n", "<leader>pc", clean_unused_pack)
