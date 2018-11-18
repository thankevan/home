
"""""""""""""""""""""""""""""""
"  GENERAL DISPLAY/OPERATION  "
"""""""""""""""""""""""""""""""
" Turn off vi compatibility for better features.
set nocp

" Don't write backup files.
set nobackup
set nowritebackup
set noswapfile

" Backspace over autoindent, line breaks, and over the start of insert.
set backspace=indent,eol,start

"""""""""""""""""""""""""""""
"  FILETYPE CUSTOMIZATIONS  "
"""""""""""""""""""""""""""""

" Turn file type detection on, as well as for indentation and plugins.
filetype plugin indent on 

" Set filetypes for my dot files.
autocmd BufRead,BufNew .bash*    set filetype=sh
autocmd BufRead,BufNew .screenrc set filetype=sh
autocmd BufRead,BufNew .inputrc  set filetype=sh

""""""""""""""""
" LINE OPTIONS "
""""""""""""""""

" Turn off text wrapping.
set textwidth=0

" Show line numbers.
set nu

" Keep a buffer of lines above and below the cursor.
set scrolloff=5

""""""""""""""""""""""""""""""""
"  SEARCHING AND HIGHLIGHTING  "
""""""""""""""""""""""""""""""""

" Turn on syntax highlighting.
syntax on

" Incremental search.
set incsearch

" Highlight all search matches.
set hlsearch

" Case sensitive searching.
set noignorecase

" Press space to clear search highlighting and any message already displayed, get rid of preview window.
nnoremap <silent> <SPACE> :silent noh<Bar>echo<CR><C-W><C-Z>

" Highlight matching bracket.
set showmatch

" Set comment colors.
hi Comment ctermfg=Blue
hi Directory ctermfg=Blue
hi SpecialKey ctermfg=Blue

" Search mappings: These will make it so that going to a search result will center its line.
nnoremap N Nzz
nnoremap n nzz
nnoremap * *zz
nnoremap # #zz


""""""""""""""""""""""""""
"  TABS AND INDENTATION  "
""""""""""""""""""""""""""
" Turn on indenting.
set autoindent
set smartindent
set cindent

" Set my tabstops.
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Convert tabs to spaces.
set expandtab

" Map tab to shift left and right, deselect if not selected, reselect if selected.
nnoremap <TAB>    V><ESC>
nnoremap <S-TAB>  V<LT><ESC>
vnoremap <TAB>    >gv
vnoremap <S-TAB>  <LT>gv
nnoremap >        V><ESC>
nnoremap <LT>     V<LT><ESC>
vnoremap >        >gv
vnoremap <LT>     <LT>gv

" Allow space to indent one space as tab does above
" Add the space just before first word
vnoremap <SPACE> :s/^\(\s*\)/\1 /<CR>:noh<BAR>echo<CR>gv

" Turn off folding for all file types.
set nofoldenable
set foldcolumn=0
autocmd BufLeave * if (&fen == 0) | set foldcolumn=0 | endif


""""""""""""""""""""""
"  WINDOW SPLITTING  "
""""""""""""""""""""""
" On enter, collapse other windows, get rid of preview window.
map <C-m> <C-W><C-Z><C-w>_

" Set the minimum window height to 0 for collapsing other windows.
set winminheight=0

" Have ^w kick out of insert mode first so it doesn't randomly delete stuff.
inoremap <C-w> <ESC><C-w>


""""""""""""""""""
"  STATUS LINES  "
""""""""""""""""""

" Always show status line.
set laststatus=2

" Show the long vim commands you are executing as you type them in.
set showcmd

" Status add full path and file type to options, move options to right.
" Make all text black on grey, modified file = red from 2 User highlights.
function! SetupStatusLine()
  hi User1 ctermbg=red ctermfg=white
  hi User2 ctermbg=grey ctermfg=black
  hi User3 ctermbg=black ctermfg=darkyellow
  
  " Here's a breakdown.
  " Some general info: 
  "   %#*           Means set the highlighting to the User# highlight colors.
  "   %xxx(yyy%)    This is a grouping for setting alignment/width (xxx) of (yyy) inside the grouping.
  "   %-#.@         This is for formatting, - is left align, # is min width, @ is max width but optional.
  "
  " [%2*]                             Set highlighting to User2 (black on grey).
  " [%<]                              Truncate here if the line is too long.
  " [%F\ ]                            Full path to file in the buffer. 
  " [%=]                              Separation point between left and right aligned items.
  " [%-5.(%)\ ]                       Empty group at least 5 wide followed by a space.
  " [%-8.(%2*%y%)\ ]                  Display filetype (%y) in User2 highlighting (black on grey).
  " [%-10.(%1*%m%*%2*%r%w%h%)\ ]      Display modified (in red), readonly, preview, and help flags. 
  " [%-8.(%2*%l,%v%)\ ]               Display line number, virtual column number.
  " [%2*]                             Set highlighting back to User2.
  " [%P]                              Display percentage of way through file. 

  set statusline=%2*%<%F\ %=%-5.(%)\ %-8.(%2*%y%)\ %-10.(%1*%m%*%2*%r%w%h%)\ %-8.(%2*%l,%v%)\ %2*%P
endfunction
call SetupStatusLine()
