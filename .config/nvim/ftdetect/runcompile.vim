"small compiler script

function! Compile()
    if &filetype == 'c'
        exec "!gcc % -o %<"
    elseif &filetype == 'cpp' || &filetype == 'cc' || &filetype == 'c++'
        exec "!g++ % -o %<"
    elseif &filetype == 'java'
        exec "!javac %"
    endif
endfunction

function! Run()
    if &filetype == 'c' || &filetype == 'cpp' || &filetype == 'cc' || &filetype == 'c++'
        exec "te ./%<"
    elseif &filetype == 'java'
        exec "te java %<"
    elseif &filetype == 'python'
        exec "te python3 %"
    elseif &filetype == 'sh' || &filetype =='bash'
        exec "!chmod +x %"
        exec "te ./%"
    endif
endfunction

function! CompileandRun()
    if &filetype == 'c'
        exec "!gcc % -o %<"
        exec "te ./%<"
    elseif &filetype == 'cpp' || &filetype == 'cc' || &filetype == 'c++' 
        exec "!g++ % -o %<"
        exec "te ./%<"
    elseif &filetype == 'java'
        exec "!javac %"
        exec "te java %<"
    endif 
endfunction 

function Launch()
    if &filetype == 'html'
        exec "!firefox %"
    elseif &filetype == 'md' || &filetype == 'markdown'
        exec "!firefox %"
    endif 
endfunction

command! Run call Run()
command! Compile call Compile()
command! Compilerun call CompileandRun()
command! Launch call Launch()

map <F8> :call Compile()<CR>
map! <F8> <Esc>:call Compile()<CR>
autocmd VimEnter,BufEnter * 
            \if &filetype == 'html' || &filetype == 'markdown' 
                \ | map <F9> :call Launch()<CR>
                \ | map! <F9> <Esc>:call Launch()<CR>
            \ | else
                \ | map <F9> :call Run()<CR>
                \ | map! <F9> <Esc>:call Run<CR> 
            \ | endif
map <F10> :call CompileandRun()<CR>
map! <F10> <Esc>:call CompileandRun()<CR>
