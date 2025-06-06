local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

local km = vim.keymap.set

now(function()
  add { source = "lewis6991/gitsigns.nvim" }
  add { source = "mbbill/undotree" }

  km('n', '<leader>u', vim.cmd.UndotreeToggle)

  require("mini.pairs").setup()

  local win_config = function()
    local height = math.floor(0.618 * vim.o.lines)
    local width = math.floor(0.618 * vim.o.columns)
    return {
      anchor = 'NW',
      height = height,
      width = width,
      row = math.floor(0.5 * (vim.o.lines - height)),
      col = math.floor(0.5 * (vim.o.columns - width)),
    }
  end

  require("mini.pick").setup { window = { config = win_config } }

  local extra = require('mini.extra')
  extra.setup()
  local hi_words = extra.gen_highlighter.words

  require('mini.hipatterns').setup({
    highlighters = {
      fixme = hi_words({ 'FIXME', 'Fixme', "fixme" }, 'MiniHipatternsFixme'),
      hack = hi_words({ 'HACK', 'Hack', "hack" }, 'MiniHipatternsHack'),
      todo = hi_words({ 'TODO', 'Todo', "todo" }, 'MiniHipatternsTodo'),
      note = hi_words({ 'NOTE', 'Note', "note" }, 'MiniHipatternsNote'),
    }
  })

  km('n', "<leader>pc", function() MiniPick.builtin.cli() end)
  km('n', "<leader>pf", function() MiniPick.builtin.files() end)
  km('n', "<leader>pb", function() MiniPick.builtin.buffers() end)
  km('n', "<leader>pg", function() MiniPick.builtin.live_grep() end)

  km('n', "<leader>pe", function() MiniExtra.pickers.diagnostic() end)
  km('n', "<leader>ps", function() MiniExtra.pickers.lsp({ scope = 'document_symbol' }) end)
  km('n', "<leader>pt", function() MiniExtra.pickers.explorer() end)

  km('n', "<leader>pha", function() MiniExtra.pickers.hipatterns() end)
end)

later(function()
  add { source = "MagicDuck/grug-far.nvim" }
end)

later(function()
  require("mini.ai").setup()
end)

later(function()
  require("mini.surround").setup()
end)

later(function()
  require("mini.git").setup()
  require("mini.diff").setup()
end)
