"Terminal configuration
set shell=\/bin\/zsh\ -l
nnoremap th :sp +res10 term://bash<CR>
nnoremap tv :vsp term://bash<CR>
nnoremap tn :terminal<CR>
tnoremap <C-v> <C-\><C-n><CR>
tnoremap <C-q> <C-d><CR>
autocmd TermOpen,TermEnter * nnoremap <buffer><Leader>q i<C-d><CR> 
autocmd TermOpen * setlocal rnu! nu!

"python interpreter
command! Pi :sp term://python3 
command! Pvi :vsp term://python3 
command! Pti :term://python3 
