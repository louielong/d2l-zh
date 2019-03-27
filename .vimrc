set nu
set tabstop=4
set colorcolumn=80
set ch=2
syntax on
filetype on
set laststatus=2
set showmatch
" set autoindent

autocmd FileType yaml,yml set sw=2
autocmd FileType yaml,yml set sts=2
autocmd FileType yaml,yml set et

map <C-E> :%s/\s\+$//
