
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
autocmd BufRead,BufNew,BufNewFile .bash*    set filetype=sh
autocmd BufRead,BufNew,BufNewFile .screenrc set filetype=sh
autocmd BufRead,BufNew,BufNewFile .inputrc  set filetype=sh

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

" Syntax highlighting for really long lines & files
" set synmaxcol=0
" syntax sync minlines=10000

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

" search and move to ~top of screen
"nnoremap N Nzt
"nnoremap n nzt
"nnoremap * *zt
"nnoremap # #zt


"""""""""""""""""""""""""""""""""""""""
"  TABS, WHITESPACE, AND INDENTATION  "
"""""""""""""""""""""""""""""""""""""""
" To toggle viewing whitespace:
" set list!
"
" To prevent converting tabs to spaces:
" set noexpandtab
"
" You can do %retab! after the above to fix spaces but it will also 'fix'
" spaces in the middle of a line.
" Use this regex instead: %s#\v(^(\t*|(  )*))@<=  #\t#gc
" %s       = substitute on all lines
" #        = use # instead of / for readability
" \v       = use very magic mode - less escapes needed
" (^       = start group and start at beginning of line
" (\t*     = start group and match any number of tabs (at the start of line)
" |(  )*   = OR match groups of two spaces
" ))       = close previous groups
" @<=      = positive lookbehind (must exist but won't be included in the 'match')
" '  #\t#' = replace two spaces with tab
" gc i     = global (multiple matches per line) & confirm

" Turn on indenting.
set autoindent
set smartindent
set cindent

" Set my tabstops.
autocmd BufRead,BufNew,BufNewFile * set tabstop=2
autocmd BufRead,BufNew,BufNewFile * set softtabstop=2
autocmd BufRead,BufNew,BufNewFile * set shiftwidth=2

" Convert tabs to spaces. (:retab to do this manually)
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

" Set how whitespace and other chars are displayed when you use `set list!`
set listchars=eol:¬,tab:>_,trail:~,extends:>,precedes:<,space:·

" Highlight trailing whitespace in red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

""""""""""""""""""""""
"  WINDOW SPLITTING  "
""""""""""""""""""""""
" On enter, collapse other windows, get rid of preview window.
map <C-m> <C-W><C-Z><C-w>_

" Set the minimum window height to 0 for collapsing other windows.
set winminheight=0

" Have ^w kick out of insert mode first so it doesn't randomly delete stuff.
inoremap <C-w> <ESC><C-w>


""""""""""""""""""""
"  TAB COMPLETION  "
""""""""""""""""""""

" Fix coloring.
hi PmenuSel ctermfg=7 ctermbg=4
hi PmenuSbar ctermfg=Gray ctermbg=Blue
hi PmenuThumb cterm=reverse

" Set the preview window to 3 lines high.
set previewheight=3

" Insert only the longest match, open the menu even if there is only one match, show preview window.
set completeopt=longest,menuone,preview

" Make enter behave the same regardless of the complete menu state.
"http://vim.wikia.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"


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

""""""""""""""""
" Better Tilde "
""""""""""""""""

function! BetterTilde()
  let l:let = getline('.')[col('.') - 1] "get the letter under the cursor

  echo l:let

  if l:let =~ '"'
    silent exe "normal s'\<ESC>"
  elseif l:let =~ "'"
    silent exe "normal s\"\<ESC>"
  else
    nunmap ~
    silent exec "normal ~\<left>"
    nnoremap ~ :call BetterTilde()<CR>
  endif

endfunction
nnoremap ~ :call BetterTilde()<CR>

""""""""""""""""""""
"  LOCAL OVERRIDES "
""""""""""""""""""""

" search upward to find the file
let localvimscript=findfile('.vimscript_file', '.;')
if filereadable(expand(localvimscript))
  exec "source " . expand(localvimscript)

"  The following command might be too verbose, you can just run this to check
"  tabs/spaces formatting and where the settings came from:
"  verbose set ts? et?
"
"  au BufReadPost,BufNewFile *.* verbose set ts? et?
endif
