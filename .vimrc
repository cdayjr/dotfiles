" pathogen
execute pathogen#infect()
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
" Scroll at 3 lines near the edge, rather than right at the edge
set scrolloff=3
" Make the backspace key be more intuitive
set backspace=indent,eol,start
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
" Error past 120 characters
match ErrorMsg '\%>120v.\+'
" Ignore CSV files
au BufRead,BufNewFile *.csv match
" Colorscheme
colorscheme molokai
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
    silent execute "!diff -a --binary " . opt .
                \ v:fname_in . " " . v:fname_new .  " > " . v:fname_out
endfunction

" Wrap markdown text at 72 characters
au BufRead,BufNewFile *.md setlocal textwidth=72
au BufRead,BufNewFile *.txt setlocal textwidth=72
" Wrap git commit messages at 72 characters
au FileType gitcommit setlocal textwidth=72

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_aggregate_errors = 1
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Show max line from editorconfig
let g:EditorConfig_max_line_indicator = "line"

" Neoformat
let g:neoformat_run_all_formatters = 1
let g:neoformat_only_msg_on_error = 1

" Neoformat toggle
nnoremap <leader>n :call NeoformatToggle()<CR>
let g:format_on_save = 1
function! NeoformatToggle()
  if g:format_on_save
    let g:format_on_save = 0
    " Disable editorconfig autoformatting rules as well
    let g:EditorConfig_disable_rules = [
          \ 'charset',
          \ 'end_of_line',
          \ 'insert_final_newline',
          \ 'trim_trailing_whitespace'
          \ ]
    EditorConfigReload
    echom "Auto formatters disabled"
  else
    let g:format_on_save = 1
    " re-enable editorconfig autoformatting rules
    let g:EditorConfig_disable_rules = []
    EditorConfigReload
    echom "Auto formatters enabled"
  endif
endfunction
function! NeoformatToggled()
  if g:format_on_save
    Neoformat
  endif
endfunction
" Neoformat on save
augroup fmt
  autocmd!
  autocmd BufWritePre * :call NeoformatToggled()
augroup END

" Neoformat PHP
" Toggle for php cs fixers
let g:neoformat_enabled_php = ['phpcsfixer', 'phpcbf']
let g:neoformat_php_phpcsfixer = {
  \ 'exe': 'php-cs-fixer',
  \ 'args': ['fix', '-q', '--config=/Users/cday/.php_cs.php'],
  \ 'replace': 1
  \ }

" Powerline
set rtp+=$POWERLINE_VIM
set laststatus=2
set t_Co=256
set noshowmode
