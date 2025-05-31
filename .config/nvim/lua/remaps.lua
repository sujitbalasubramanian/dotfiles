local g = vim.g
local k = vim.keymap

g.mapleader = " "
g.localleader = "\\"

k.set("v", "J", ":m '>+1<CR>gv=gv")
k.set("v", "K", ":m '<-2<CR>gv=gv")

k.set("n", "H", [[:bnext<CR>]])
k.set("n", "L", [[:bprev<CR>]])
k.set("n", "<leader>bd", [[:bdelete<CR>]])

k.set("n", "<leader><leader>", [[:so %<CR>]])
k.set("v", "<leader><leader>", [[:so<CR>]])
