filetype off
if &compatible
  set nocompatible
endif

"plugin
"管理
"no use git (https://github.com/tpope/vim-pathogen)
"ls ~/.vim/localpluginsで確認
execute pathogen#infect('localbundle/{}')
"use git (https://github.com/Shougo/dein.vim)
call dein#begin(expand('~/.vim/bundle'))

"filer
call dein#add('kien/ctrlp.vim')
call dein#add('nixprime/cpsm', {'build': 'bash install.sh'})
call dein#add('Shougo/unite.vim')
"補完
call dein#add('Shougo/neocomplete.vim')
" Git操作プラグイン
call dein#add('tpope/vim-fugitive')

" Example
"call dein#add('Shougo/vimshell', { 'rev': '3787e5' }) " tag指定
"call dein#add('Shougo/vimproc.vim', {'build': 'make'})
call dein#end()
filetype on
filetype plugin indent on
" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

set number
set nowrap
set title
set ruler
set ambiwidth=double
set tabstop=2
set expandtab
set shiftwidth=2
"set smartindent
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set nrformats-=octal
set hidden
set history=50
set virtualedit=block
set whichwrap=b,s,[,],<,>
set backspace=indent,eol,start
set wildmenu
set display=lastline
set clipboard+=unnamed
set mouse=a
set cursorline
set hlsearch
set showcmd
colorscheme darkblue|colorscheme hybrid
" 挿入モードの表示設定
augroup insertmode-colorsheme
  autocmd!
  autocmd InsertEnter * call SetInsertmodeColorsheme(1)
  autocmd InsertLeave * call SetInsertmodeColorsheme(0)
augroup END
function! SetInsertmodeColorsheme(is_insert)
  if a:is_insert == 1
    hi CursorLine term=underline cterm=underline ctermbg=234
    hi CursorLineNr ctermbg=200
  else
    hi CursorLine term=NONE cterm=NONE ctermbg=234
    hi CursorLineNr ctermbg=234
  endif
endfunction
syntax on
hi LineNr ctermfg=245
hi VertSplit ctermfg=214 guifg=#303030

"keymaps
""other
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap <Space> <Nop>
nnoremap Q <Nop>
nnoremap Y y$
nnoremap <CR> o<ESC>
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
function! SwitchRelativeNumber()
  if &relativenumber == 0
    set nonu|set rnu
  else 
    set nu|set nornu
  endif
endfunction
noremap <C-n> :call SwitchRelativeNumber()<CR>
nnoremap Z :source ~/.vimrc<CR>
nnoremap x "_x
nnoremap X "_X

""バッファー
nnoremap = :bprevious<CR>
nnoremap - :bnext<CR>
nnoremap <Bar> :bf<CR>
"nnoremap <silent>bl :bl<CR>
augroup swapchoice-readonly
  autocmd!
  autocmd SwapExists * let v:swapchoice = 'o'
augroup END
""レジスタ
noremap <Space>ls :reg<CR>
noremap <Space> "*
noremap <Space><Space> "_
cnoremap <C-R><C-R> <C-R>"
""tab操作
noremap t gt
noremap T gT
hi TabLine term=bold cterm=bold ctermbg=0 ctermfg=0*
hi TabLineFill term=bold cterm=bold ctermbg=0
hi TabLineSel term=bold cterm=bold ctermbg=6 ctermfg=0*
""vimgrep
nnoremap <C-h> :cprevious<CR>
nnoremap <C-l> :cnext<CR>
nnoremap <C-k> :<C-u>cfirst<CR>
nnoremap <C-j> :<C-u>clast<CR>
""直前のコマンド繰り返し
noremap <C-@> @:
"
"" add commands
command! -nargs=1 -complete=file Rename f <args>|call delete(expand('#'))

"ステータスライン
set laststatus=2
set statusline=%<     " 行が長すぎるときに切り詰める位置
set statusline+=[%n]  " バッファ番号
set statusline+=%m    " %m 修正フラグ
set statusline+=%r    " %r 読み込み専用フラグ
set statusline+=%h    " %h ヘルプバッファフラグ
set statusline+=%w    " %w プレビューウィンドウフラグ
set statusline+=%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}  " fencとffを表示
set statusline+=%y    " バッファ内のファイルのタイプ
set statusline+=\     " 空白スペース
if winwidth(0) >= 130
  set statusline+=%F    " バッファ内のファイルのフルパス
else
  set statusline+=%t    " ファイル名のみ
endif
set statusline+=%=    " 左寄せ項目と右寄せ項目の区切り
set statusline+=%{fugitive#statusline()}  " Gitのブランチ名を表示(plugin vim-fugitiveが必要)
set statusline+=\ \   " 空白スペース2個
set statusline+=%1l   " 何行目にカーソルがあるか
set statusline+=/
set statusline+=%L    " バッファ内の総行数
set statusline+=,
set statusline+=%c    " 何列目にカーソルがあるか
set statusline+=%V    " 画面上の何列目にカーソルがあるか
set statusline+=\ \   " 空白スペース2個
set statusline+=%P    " ファイル内の何％の位置にあるか

"" 無視検索リスト
let g:ctrlp_custom_ignore = {
\ 'dir':  '\v(^|[\/])(\.git|\.svn|\.vagrant|\.atom|\.settings|node_modules)$',
\ 'file': '\v\.(exe|so|dmg|png|jpg|gif|swp|zip|gz|bz|jar|war|app)$',
\ 'link': '/here/write/some_bad_symbolic_links'
\}
"" ファイル検索コマンド変更(ag使用)
let g:ctrlp_user_caching = 0
let g:ctrlp_user_command = 'ag %s -U -i --nocolor --nogroup --hidden -g ""'
let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}
"" recache clear
nnoremap <F5> <ESC>:CtrlPClearCache<CR>:CtrlP<CR>

"" net rw設定
let g:netrw_liststyle = 3 " netrwのデフォルトをtree view
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+' " .で始まるファイルは表示しない
let g:netrw_altv = 1 " 'v'のデフォルトを右側
let g:netrw_alto = 1 " 'o'のデフォルトを下側
" netrwのkeymap設定
augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END
function! NetrwMapping()
  noremap <buffer> - <Nop>
  noremap <buffer> h :Ntree ..<CR>
  noremap <buffer> l :Ntree<CR>
  noremap <buffer> X <Nop>
  noremap <buffer> <C-j> 5j
  noremap <buffer> <C-k> 5k
  noremap <buffer> K $2F<Bar>f "zy0?^<C-R>z [^<Bar>]<CR>
endfunction

"unite.vim設定
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--nocolor --nogroup'
let g:unite_source_grep_max_candidates = 200
let g:unite_source_grep_recursive_opt = ''
" unite-grepの便利キーマップ
vnoremap /g y:Unite grep::-iRn:<C-R>=escape(@", '\\

" (あれば)個別設定ファイル読み込み
let $LOCAL_MYVIMRC=$PWD.'/.localvimrc'
if filereadable($LOCAL_MYVIMRC)
  source $LOCAL_MYVIMRC
endif
