local o = vim.opt
local g = vim.g

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

o.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

g.netrw_banner = 0
g.netrw_liststyle = 0

vim.cmd [[
let g:vimwiki_list = [{'path': '~/Dropbox/Notes', 'syntax': 'markdown', 'ext': 'md'}]
]]
