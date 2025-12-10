" set encoding
set encoding=UTF-8
" Press F2 to switch between paste and nopaste mode
set pastetoggle=<F2>
" Helpful line# column# indicator
set ruler
" Enhance commendline autocomplete
set wildmenu
" Ignore case when searching...
set ignorecase
" ...except for when you specifically use capital letters
set smartcase
" Let VIM modify the terminal title
set title
" Autoindentation
set autoindent
set copyindent
" Show the matching brace
set showmatch
" Don't use swap files
set noswapfile
" Use backup files
set backupcopy=yes
" Use a visual bell rather than an audio one
set visualbell
" Don't use error bells
set noerrorbells
" Show a line on the line you're currently on
set cursorline
" No folding
set nofoldenable
" Syntax Highlighting
syntax on
filetype on
filetype plugin on
filetype indent on
" Highlight matches to search strings
set hlsearch
" Have j and k go up/down one visual line rather than actual line
nnoremap j gj
nnoremap k gk
" <leader>l toggles line numbers
nnoremap <leader>l :setlocal number!<CR>
" <leader>q toggles search highlighting
nnoremap <leader>q :nohlsearch<CR>
" <leader>s fix syntax
nnoremap <leader>s :syntax sync fromstart<CR>
" Ignore CSV files
au BufRead,BufNewFile *.csv match
" Colorscheme
colorscheme brogrammer
" indentation search
nnoremap <leader>j m':exec '/\%' . col(".") . 'c\S'<CR>``n
nnoremap <leader>k m':exec '?\%' . col(".") . 'c\S'<CR>``n
" Spellcheck
map <F5> :setlocal spell! spelllang=en_us<CR>
" vimdiff ignore empty lines
set diffopt+=iwhite
set diffexpr=MyDiff()
function MyDiff()
    let opt = ""
    if &diffopt =~ "icase"
        let opt = opt . "-i "
    endif
    if &diffopt =~ "iwhite"
        let opt = opt . "-w -B " " vim uses -b by default
    endif
    silent execute "!diff -a " . opt .
                \ v:fname_in . " " . v:fname_new .  " > " . v:fname_out
endfunction

" Do not wrap text
set textwidth=0

" highlight custom gitconfig files
au BufRead,BufNewFile */gitconfig setfiletype gitconfig
au BufRead,BufNewFile *.gitconfig setfiletype gitconfig
" highlight custom sshconfig files
au BufRead,BufNewFile */sshconfig setfiletype sshconfig
au BufRead,BufNewFile *.sshconfig setfiletype sshconfig

" Show max line from editorconfig
let g:EditorConfig_max_line_indicator = "line"

" Ale configration
let g:ale_fix_on_save = 1
let g:ale_linters = {
\   'json': ['jq', 'jsonlint', 'spectral'],
\}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'css': ['prettier'],
\   'html': ['prettier'],
\   'javascript': ['eslint', 'prettier'],
\   'json': ['prettier'],
\   'markdown': ['prettier'],
\   'php': ['php_cs_fixer', 'phpcbf'],
\   'python': ['autopep8'],
\   'scss': ['prettier'],
\   'typescript': ['eslint', 'prettier'],
\   'yaml': ['prettier'],
\}
let g:ale_completion_autoimport = 1
let g:ale_completion_enabled = 1
" go load all symbols in package
let g:ale_go_golangci_lint_package = 1
nnoremap <leader>f :ALEFix<CR>

" Powerline
set rtp+=$POWERLINE_VIM
set laststatus=2
set t_Co=256
set noshowmode

" Don't autoformat on save
let g:format_on_save = 0
let g:ale_fix_on_save = 0

" Disable "Thanks for flying Vim"
" See https://mattdturner.com/wordpress/2011/04/how-to-stop-thanks-for-flying-vim-message/
let &titleold=substitute(getcwd(), $HOME, "~", "")

" Source external files
for f in split(glob('~/.local/share/includes/**/*.vim'), '\n')
    exe 'source' f
endfor
