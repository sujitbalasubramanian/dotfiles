vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = true
vim.opt.backupcopy= "yes"
vim.opt.backupdir = os.getenv("HOME") .. "/.cache/nvim/backup"
vim.opt.undodir = os.getenv("HOME") .. "/.cache/nvim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

vim.opt.cursorline = true
vim.opt.guicursor = "n-v-c:block-Cursor,i-ci:ver25"
 
vim.g.vimwiki_global_ext = 0
vim.g.vimwiki_list = {{path = "~/Documents/wiki/", syntax = "markdown", ext = "md"}}
