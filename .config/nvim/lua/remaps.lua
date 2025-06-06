local g = vim.g
local km = vim.keymap.set

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

km("n", "<leader>n", [[:Ex<cr>]])

km("n", "<leader><leader>", [[:so %<cr>]])
km("v", "<leader><leader>", [[:so<cr>]])
