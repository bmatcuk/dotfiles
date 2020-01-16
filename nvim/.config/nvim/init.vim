" Recommended nvim 0.4.0+ (brew install --HEAD neovim)
"
" Install vim-plug first: https://github.com/junegunn/vim-plug
" Then start nvim with:
"   nvim +PlugInstall +UpdateRemotePlugins
call plug#begin()
" general plugins
Plug 'tpope/vim-sensible'
Plug 'guns/xterm-color-table.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'

" added functionality
Plug 'mhinz/vim-startify'
Plug 'Olical/vim-enmasse'
Plug 'dstein64/vim-win'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'Shougo/defx.nvim'
Plug 'kristijanhusak/defx-icons'
Plug 'kristijanhusak/defx-git'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'

" editing
Plug 'vim-scripts/restore_view.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'sheerun/vim-polyglot'
Plug 'luochen1990/rainbow'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'wellle/targets.vim'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'
call plug#end()

" pip3 install pynvim
let g:python3_host_prog='/usr/local/opt/python/bin/python3'
let g:python_host_prog='/usr/local/bin/python'

set tabstop=2
set expandtab
set shiftwidth=2
set softtabstop=2
set number
set relativenumber
set splitbelow
set splitright
set hidden
set showmatch
set hlsearch
set ignorecase
set smartcase
set list
set listchars=tab:··,trail:␠,nbsp:⎵,extends:>,precedes:<
set viewoptions=cursor,folds
set updatetime=250
set wildignore+=*/.git/*,*/tmp/*,*.swp
set shortmess+=c
set signcolumn=yes
set noshowmode
set showtabline=2
autocmd VimResized * wincmd =

set background=dark
colorscheme nord

let mapleader=","
nnoremap <silent> <leader>/ :nohlsearch<CR>

" brew install fzf
nnoremap <C-p> :Files<CR>
let g:fzf_layout = { 'down': '~30%' }

" brew install ripgrep
if executable('rg')
  command! -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
    \   fzf#vim#with_preview({'options': '--nth=4.. --delimiter=:'}, 'right:50%'),
    \   0)

  " :grep! --args query
  set grepprg=rg\ --vimgrep
  let g:rg_derive_root = 1
  nnoremap \ :Rg<CR>
  nnoremap <leader>\ :Rg <C-r><C-w><CR>
endif
augroup mylocquickcmds
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    lwindow
augroup END

" lightline settings
let g:lightline#bufferline#unicode_symbols=1
let g:lightline#bufferline#unnamed='[No Name]'
let g:lightline = {
  \ 'colorscheme': 'nord',
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': { 'left': '', 'right': '' },
  \ 'active': {
    \ 'left': [
      \ ['mode', 'paste'],
      \ ['git'],
      \ ['readonly', 'filename', 'currentfunc']
    \ ],
    \ 'right': [
      \ ['percent', 'line', 'column'],
      \ ['fileencodingandformat'],
      \ ['filetype'],
      \ ['cocwarning', 'cocerror']
    \ ]
  \ },
  \ 'inactive': {
    \ 'left': [['relativepath']],
    \ 'right': [
      \ ['percent', 'line', 'column'],
      \ ['fileencodingandformat'],
      \ ['filetype']
    \ ]
  \ },
  \ 'tabline': {
    \ 'left': [['buffers']],
    \ 'right': []
  \ },
  \ 'component': {
    \ 'column': '%v',
    \ 'filename': '%t%m',
    \ 'fileencodingandformat': '%{&fenc!=#""?&fenc:&enc}[%{&ff}]',
    \ 'line': '%l/%L ',
    \ 'paste': '[%{&paste?"PASTE":""}]',
    \ 'percent': '%3p%% ☰',
    \ 'relativepath': '%f%m'
  \ },
  \ 'component_function': {
    \ 'currentfunc': 'LightlineCurrentFunc',
    \ 'git': 'LightlineGitStatus',
    \ 'readonly': 'LightlineReadonly'
  \ },
  \ 'component_expand': {
    \ 'buffers': 'lightline#bufferline#buffers',
    \ 'cocerror': 'LightlineCocError',
    \ 'cocwarning': 'LightlineCocWarning',
  \ },
  \ 'component_type': {
    \ 'buffers': 'tabsel',
    \ 'cocerror': 'error',
    \ 'cocwarning': 'warning'
  \ }
\}

function! LightlineReadonly()
  return &readonly ? '' : ''
endfunction
function! LightlineGitStatus()
  return get(g:, 'coc_git_status', '')
endfunction
function! LightlineCurrentFunc()
  let l:func = get(b:, 'coc_current_function', '')
  if empty(l:func)
    return ''
  endif
  return '('.l:func.')'
endfunction
function! s:lightline_coc_diagnostic(kind, sign) abort
  let info = get(b:, 'coc_diagnostic_info', 0)
  if empty(info) || get(info, a:kind, 0) == 0
    return ''
  endif
  return a:sign.' '.info[a:kind]
endfunction
function! LightlineCocError()
  return s:lightline_coc_diagnostic('error', '✗')
endfunction
function! LightlineCocWarning()
  return s:lightline_coc_diagnostic('warning', '◆')
endfunction

" update colors for lightline errors and warnings
function! s:patch_lightline_colorscheme() abort
  try
    let l:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette

    let l:palette.normal.error[0][2] = l:palette.normal.error[0][3]
    let l:palette.normal.error[0][3] = '0'
    let l:palette.normal.warning[0][2] = l:palette.normal.warning[0][3]
    let l:palette.normal.warning[0][3] = '0'
  catch
  endtry
endfunction
call s:patch_lightline_colorscheme()

augroup mylightline
  autocmd!
  autocmd User CocDiagnosticChange call lightline#update()
  autocmd ColorScheme * call s:patch_lightline_colorscheme()
augroup END

" execute macros over a visual selection with @x where x = macro register
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" highlight current match with *, rather than moving to the next match
nnoremap <silent> * :let stay_star_view = winsaveview()<CR>*:call winrestview(stay_star_view)<CR>

" defx
nnoremap <silent> <leader>e :Defx `expand('%:p:h')` -search=`expand('%:p')` -columns='indent:git:icons:filename:type' -split=vertical -winwidth=50 -direction=topleft<CR>
augroup mydefx
  autocmd!
  autocmd FileType defx call s:defx_my_settings()
augroup END
function! s:defx_my_settings() abort
  " Define mappings
  nnoremap <silent><buffer><expr> <CR>
        \ defx#is_directory() ?
        \ defx#do_action('open') :
        \ defx#do_action('multi', ['drop', 'quit'])
  nnoremap <silent><buffer><expr> c
        \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
        \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
        \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> v
        \ defx#do_action('multi', [['drop', 'vsplit'], 'quit'])
  nnoremap <silent><buffer><expr> P
        \ defx#do_action('open', 'pedit')
  nnoremap <silent><buffer><expr> o
        \ defx#do_action('open_or_close_tree')
  nnoremap <silent><buffer><expr> K
        \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N
        \ defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> d
        \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
        \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> !
        \ defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x
        \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy
        \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> ;
        \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> .
        \ defx#do_action('repeat')
  nnoremap <silent><buffer><expr> <BS>
        \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
        \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
        \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>
        \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
        \ defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j
        \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
        \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l>
        \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
        \ defx#do_action('print')
  nnoremap <silent><buffer><expr> cd
        \ defx#do_action('change_vim_cwd')
endfunction

" startify
let g:startify_session_persistence = 1
let g:startify_change_to_vcs_root = 1
let g:startify_enable_special = 0
let g:startify_change_to_dir = 0
let g:startify_lists = [
  \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
  \ { 'type': 'sessions',  'header': ['   Sessions']       },
\ ]

let g:startify_custom_header = []
let g:startify_custom_footer = 'startify#pad(split(system("fortune -s computers linuxcookie softwareengineering | cowsay -f kitten"), "\n"))'

" vim-win - <leader>w will enter vim-mode 'mode'; <space>w will exit vim-win
" after just one command: this is useful if all you want to do is switch which
" window is active.
nnoremap <silent> <space>w :<C-u>Win 1<CR>

" coc
"
" coc - general extensions
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-lists',
  \ 'coc-git',
  \ 'coc-yank',
  \ 'coc-pairs',
\]

" coc - language extensions
let g:coc_global_extensions = extend(g:coc_global_extensions, [
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-json',
  \ 'coc-tsserver',
  \ 'coc-go',
  \ 'coc-rls',
\])

" coc - linter extensions
let g:coc_global_extensions = extend(g:coc_global_extensions, [
  \ 'coc-eslint',
  \ 'coc-stylelintplus',
\])

" coc - tab/stab to cycle through completions/snippet jump locations
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump', ''])\<CR>" :
  \ "\<TAB>"
inoremap <silent><expr><S-TAB>
  \ pumvisible() ? "\<C-p>" :
  \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('snippetPrev', [])\<CR>" :
  \ "\<S-TAB>"

" coc - enter to confirm completion
inoremap <silent><expr> <cr>
  \ pumvisible() ? coc#_select_confirm() :
  \ "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" coc - hide floats; restart (unfortunately, some extensions break every now and again)
nmap <silent> <leader>ch <Plug>(coc-float-hide)
nmap <silent> <leader>cr :<C-u>CocRestart<cr>

" coc - navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" coc - goto mappings
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" coc - show documentation with K
" set keywordprg=:call\ <SID>show_documentation()
nmap <silent> <space>d <Plug>(coc-diagnostic-info)
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

augroup mycoc
  autocmd!

  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

  " coc - highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END

" coc - mapping to rename current word
nmap <silent> <leader>rn <Plug>(coc-rename)

" coc - format region
xmap <silent> <leader>f <Plug>(coc-format-selected)
nmap <silent> <leader>f <Plug>(coc-format-selected)

" coc - format entire file using :Format
command! -nargs=0 Format :call CocAction('format')

" coc - code action on region
xmap <silent> <leader>a <Plug>(coc-codeaction-selected)
nmap <silent> <leader>a <Plug>(coc-codeaction-selected)

" coc - code action / fix current line
nmap <silent> <leader>ac <Plug>(coc-codeaction)
nmap <silent> <leader>qf <Plug>(coc-fix-current)

" coc list shortcuts
nnoremap <silent> <leader>be :<C-u>CocList --normal buffers<cr>
nnoremap <silent> <space>a :<C-u>CocList diagnostics<cr>
nnoremap <silent> <space>c :<C-u>CocList commands<cr>
nnoremap <silent> <space>h :<C-u>CocList cmdhistory<cr>
nnoremap <silent> <space>l :<C-u>CocList lists<cr>
nnoremap <silent> <space>m :<C-u>CocList marks<cr>
nnoremap <silent> <space>o :<C-u>CocList outline<cr>
nnoremap <silent> <space>r :<C-u>CocList mru<cr>
nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>

" filetype-specific
augroup myfilespecific
  autocmd!
  autocmd filetype crontab setlocal nobackup nowritebackup
  autocmd filetype go setlocal noexpandtab
  autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')
  autocmd BufEnter * :syntax sync fromstart
augroup END

" rainbow settings
let g:rainbow_active = 1
let g:rainbow_conf = {
\       'guifgs': ['#df0000', '#df5f00', '#dfdf00', '#00af00', '#005fff', '#5f00ff', '#8700df'],
\       'ctermfgs': ['160', '166', '184', '34', '27', '57', '92'],
\       'operators': '_,_',
\       'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\       'separately': {
\               '*': {},
\               'tex': {
\                       'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\               },
\               'vim': {
\                       'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\               },
\               'xml': {
\                       'parentheses': ['start=/\v\<\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'))?)*\>/ end=#</\z1># fold'],
\               },
\               'xhtml': {
\                       'parentheses': ['start=/\v\<\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'))?)*\>/ end=#</\z1># fold'],
\               },
\               'html': {
\                       'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\               },
\               'php': {
\                       'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold', 'start=/(/ end=/)/ containedin=@htmlPreproc contains=@phpClTop', 'start=/\[/ end=/\]/ containedin=@htmlPreproc contains=@phpClTop', 'start=/{/ end=/}/ containedin=@htmlPreproc contains=@phpClTop'],
\               },
\               'css': 0,
\       }
\}

" load local config
runtime local.vim
