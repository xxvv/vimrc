
call plug#begin($VIMFILES.'/plugged')

" colorscheme
Plug 'fatih/molokai'
Plug 'wwcd/desert'

Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'mileszs/ack.vim'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'python-mode/python-mode', { 'branch': 'master' }
Plug 'plasticboy/vim-markdown'
Plug 'leafgarland/typescript-vim'
Plug 'cespare/vim-toml'

call plug#end()


"-------------------------------------------------------------------------------
" Base plugins
"-------------------------------------------------------------------------------

" NERD_tree {{{
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

let NERDTreeWinSize=40
let NERDTreeDirArrows=0
let NERDTreeHighlightCursorline=0
if has('unix')
  let NERDTreeDirArrowExpandable='+'
  let NERDTreeDirArrowCollapsible='-'
endif
let NERDTreeMapJumpNextSibling=""
let NERDTreeMapJumpPrevSibling=""
let NERDTreeIgnore=['\.o$[[file]]', '\.pyc$[[file]]']
nmap <silent><F7> :NERDTreeToggle<CR>
map <silent><C-n> :NERDTreeToggle<CR>
" }}}

" Tagbar {{{
nmap <silent><F8> :TagbarToggle<CR>
" set 'stty -ixon' in ~/.bash_profile to disable XON/XOFF
map <silent><C-s> :TagbarToggle<CR>
let g:tagbar_ctags_bin = $VIMFILES.'/tools/ctags'
let g:tagbar_left = 1
let g:tagbar_hide_nonpublic = 0
let g:tagbar_autoshowtag = 1
let g:tagbar_show_visibility = 0
let g:tagbar_iconchars = ['+', '-']
let g:tagbar_compact = 1
let g:tagbar_sort = 0

let g:tagbar_type_typescript = {
  \ 'ctagstype': 'typescript',
  \ 'kinds': [
  \ 'c:classes',
  \ 'n:modules',
  \ 'f:functions',
  \ 'v:variables',
  \ 'v:varlambdas',
  \ 'm:members',
  \ 'i:interfaces',
  \ 'e:enums',
  \ ]
  \ }
" }}}

"lightline {{{
set noshowmode
let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
  let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

let g:lightline = {
  \ 'colorscheme': 'landscape',
  \ 'mode_map': { 'c': 'NORMAL' },
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'fugitive' ],
  \             [ 'filename' ] ],
  \  'right': [ [ 'lineinfo' ],
  \             [ 'percent' ],
  \             [ 'filetype', 'fileformat', 'fileencoding' ] ]
  \ },
  \ 'component_function': {
  \   'filename': 'LightlineFilename',
  \   'modified': 'LightLineModified',
  \   'readonly': 'LightLineReadonly',
  \   'fugitive': 'LightLineFugitive',
  \   'fileformat': 'LightLineFileformat',
  \   'filetype': 'LightLineFiletype',
  \   'fileencoding': 'LightLineFileencoding',
  \   'mode': 'LightLineMode',
  \ },
  \ }

function! LightLineModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : ''
endfunction

function! LightLineReadonly()
  if has('nvim')
    return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '' : ''
  else
    return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'RO' : ''
  endif
endfunction

function! LightLineFugitive()
  if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
    let branch = fugitive#head()
    if has('nvim')
      return branch !=# '' ? ' '.branch : ''
    else
      return branch !=# '' ? branch : ''
    endif
  endif
  return ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 120 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 120 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 120 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! LightlineFilename()
  return ('' != expand('%') ? expand('%') : '[No Name]') .
        \ ('' != LightLineReadonly() ? ' ' . LightLineReadonly() : '') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

"}}}

"fzf{{{
let g:fzf_command_prefix = 'Fzf'

if executable('rg')
  let $FZF_DEFAULT_COMMAND='rg --files --hidden --follow --ignore-file ' . expand('$VIMFILES/tools/.ignore')
  let $FZF_DEFAULT_OPTS='--color bg:-1,bg+:-1'
elseif executable('ag')
  let $FZF_DEFAULT_COMMAND='ag --hidden  --path-to-ignore ' . expand('$VIMFILES/tools/.ignore') . ' -g ""'
  let $FZF_DEFAULT_OPTS='--color bg:-1,bg+:-1'
endif

map <silent><c-p> :FzfFiles<CR>
map <silent><c-b> :FzfBuffers<CR>

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)
"}}}

"Ack{{{
let g:ack_mappings = {
  \ "t": "<C-W><CR><C-W>T",
  \ "T": "<C-W><CR><C-W>TgT<C-W>j",
  \ "o": "<CR>",
  \ "O": "",
  \ "go": "",
  \ "h": "",
  \ "H": "",
  \ "v": "",
  \ "gv": "",
  \ "i": "<C-W><CR><C-W>K",
  \ "gi": "<C-W><CR><C-W>K<C-W>b",
  \ "s": "<C-W><CR><C-W>H<C-W>b<C-W>J<C-W>t",
  \ "gs": "<C-W><CR><C-W>H<C-W>b<C-W>J" }

if executable('rg')
  let g:ackprg = 'rg --vimgrep --no-heading --ignore-file ' . expand('$VIMFILES/tools/.ignore')
elseif executable('ag')
  let g:ackprg = 'ag --vimgrep --path-to-ignore ' . expand('$VIMFILES/tools/.ignore')
endif
"}}}

"vim-commentary{{{
autocmd FileType cmake setlocal commentstring=#\ %s
"}}}

"-------------------------------------------------------------------------------
" Coding plugins
"-------------------------------------------------------------------------------

"markdown {{{
let g:vim_markdown_folding_disabled = 1
"}}}

"python-mode{{{
let g:pymode_folding = 1
let g:pymode_rope = 1
let g:pymode_rope_auto_project = 0
let g:pymode_rope_goto_definition_bind = "<C-]>"
let g:pymode_rope_goto_definition_cmd = 'e'
let g:pymode_rope_regenerate_on_write = 0
let g:pymode_options_max_line_length = 100
let g:pymode_options_colorcolumn=0
let g:pymode_lint = 1
let g:pymode_lint_on_write = 1
let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'mccabe', 'pylint']
let g:pymode_lint_options_mccabe = {'complexity': 8}
" Using local .pylintrc
let g:pymode_lint_options_pylint = {'rcfile': ''}
"}}}

"vim-go{{{
let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 1
let g:go_list_type = "quickfix"

let g:go_def_mode = 'gopls'
let g:go_info_mode = 'gopls'
" let g:go_lsp_log = []
" let g:go_debug = ['lsp']

let g:go_metalinter_command='golangci-lint'
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
" let g:go_metalinter_autosave = 1
" let g:go_metalinter_autosave_enabled = ['vet', 'golint']
" let g:go_metalinter_disabled = []
let g:go_metalinter_command = '--enable vet --enable golint --enable errcheck --exclude comment --exclude check'
let g:go_metalinter_deadline = '5s'

augroup go
  autocmd!

  autocmd FileType go nmap <C-g> :GoDeclsDir<cr>

  autocmd FileType go nmap <leader>b <Plug>(go-build)
  autocmd FileType go nmap <leader>r <Plug>(go-run)
  autocmd FileType go nmap <leader>t <Plug>(go-test)
  autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
  autocmd FileType go nmap <Leader>i <Plug>(go-info)
  autocmd FileType go nmap <Leader>l <Plug>(go-metalinter)

  " :GoAlternate  commands :A, :AV, :AS and :AT
  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
augroup end

"}}}

"cscope{{{
if has("cscope")
  " set csprg=$VIMFILES.'/tools/cscope'
  set csto=0
  set cst
  set nocsverb
  " add any database in current directory
  if filereadable("cscope.out")
    cs add cscope.out
    " else add database pointed to by environment
  elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
  endif
  set csverb

  map g<C-]> :cs find 1 <C-R>=expand("<cword>")<CR><CR>
  map g<C-\> :cs find 3 <C-R>=expand("<cword>")<CR><CR>

  nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
  nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
  nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
  nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
  nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
  nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
  nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>
  nmap <C-_>a :cs find a <C-R>=expand("<cword>")<CR><CR>
endif
"}}}

" vim: ts=2 sw=2 et