local add, now = MiniDeps.add, MiniDeps.now

now(function()
  require("mini.notify").setup()
  vim.notify = require("mini.notify").make_notify()

  require("mini.icons").setup()

  require("mini.indentscope").setup {
    draw = {
      animation = require("mini.indentscope").gen_animation.none(),
    },
  }

  require("mini.statusline").setup()
end)
