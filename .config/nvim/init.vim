set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath = &runtimepath
    source ~/.vimrc

    map <F2> : NERDTreeToggle<CR>
    map <F3> : TagbarToggle<CR>
set noshowmode
set tabstop=4 shiftwidth=4 expandtab
let g:vimtex_view_method = "zathura"
"set cursorline
colorscheme wpgtk
"let g:airline_theme='wal'

"let g:airline_theme='wal'"
" Function: return current mode
" abort -> function will abort soon as error detected
let g:currentmode={ 'n' : 'Normal ', 'no' : 'N·Operator Pending ', 'v' : 'Visual ', 'V' : 'V·Line ', '^V' : 'V·Block ', 's'     : 'Select ', 'S': 'S·Line ', '^S' : 'S·Block ', 'i' : 'Insert ', 'R' : 'Replace ', 'Rv' : 'V·Replace ', 'c' : 'Command ', 'cv' : 'Vim Ex ', 'ce' : 'Ex ', 'r' : 'Prompt ', 'rm' : 'More ', 'r?' : 'Confirm ', '!' : 'Shell ', 't' : 'Terminal '}
function! ModeCurrent() abort
    let l:modecurrent = mode()
    " use get() -> fails safely, since ^V doesn't seem to register
    " 3rd arg is used when return of mode() == 0, which is case with ^V
    " thus, ^V fails -> returns 0 -> replaced with 'V Block'
    let l:modelist = toupper(get(g:currentmode, l:modecurrent, 'V·Block '))
    let l:current_status_mode = l:modelist
    return l:current_status_mode
endfunction

set laststatus=2
set statusline=
set statusline+=%1*\ %{ModeCurrent()}
set statusline+=%2*\ %F
set statusline+=%2*\ %m
set statusline+=%=
"set statusline+=%3*\ %{LinterStatus()}"
set statusline+=%2*\ %{strlen(&ft)?&ft:'none'}\ %*  " filetype
set statusline+=%2*\ %{strlen(&fenc)?&fenc:&enc} " encoding
set statusline+=%2*\[%{&fileformat}]\ %*             " file format
set statusline+=%1*\ %p%%\ %*
set statusline+=%1*\ %l/%L\ ln
set statusline+=%1*\ :
set statusline+=%1*\ %c\ %*
tnoremap <C-b> <C-\><C-n>

