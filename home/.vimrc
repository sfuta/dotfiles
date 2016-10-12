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
" 日本語化
call dein#add('vim-jp/vimdoc-ja')

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

"行番号:ON, 折り返し:OFF, タイトル表示:ON, カーソル位置表示:ON, 全角文字幅:2
set number nowrap title ruler ambiwidth=double
" インデント設定(tab幅:2, tab->space, indent幅:2, smartindent:ON
set tabstop=2 expandtab shiftwidth=2 smartindent
" 特殊文字表示設定
set list listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%

set hidden            " バッファー設定(未保存でも別バッファ表示可)
set nrformats-=octal  " inc,dec(ctrl-a,ctrl-x)にて、8進数フォーマット除去
set virtualedit=block " 矩形選択時、文字がない場合も編集可
set history=50        " コマンドラインの履歴登録数
set wildmenu          " コマンドラインにて補完候補表示
set showcmd           " Normalモード等のときの入力文字を表示
" 行またぎ時の設定
set whichwrap=b,s,[,],<,>      " (Leftキー等)キー入力で前/次の行に移動
set backspace=indent,eol,start " <BS>設定(Insert mode利用可、インデント削除可、行連結可)
set display=lastline           " 長い行は省略せず表示
" レジスタとクリップボード連携
set clipboard+=unnamed

set mouse=a    " マウス連携
set cursorline " カーソルがある行のハイライトON
set hlsearch   " 検索文字のハイライトON

set foldmethod=indent " インデントで折り畳み
set foldlevelstart=99 " 初回は折り畳みなし

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

"filetype追加
autocmd BufRead,BufNewFile *.es6 set filetype=javascript

"keymaps
""other
nnoremap ZZ <Nop>| nnoremap ZQ <Nop>| nnoremap <Space> <Nop>| nnoremap Q <Nop>
nnoremap j gj| nnoremap gj j
nnoremap k gk| nnoremap gk k
nnoremap Y y$
nnoremap <CR> o<ESC>
nnoremap <Esc><Esc> :<C-u>set nohlsearch!<CR>

function! SwitchRelativeNumber()
  if &relativenumber == 0
    set nonu rnu
  else 
    set nu nornu
  endif
endfunction
noremap <C-n> :call SwitchRelativeNumber()<CR>

nnoremap Z :source ~/.vimrc<CR>:noh<CR>:echo 'Reloaded .vimrc!!'<CR>
nnoremap x "_x| nnoremap X "_X

""バッファー
nnoremap = :bprevious<CR>
nnoremap - :bnext<CR>
nnoremap <Bar> :bf<CR>
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
""tab色
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

"" カーソル配下の単語を検索処理よりハイライトする
function! HighlightWordBySearch__()
  let l:keepline = winline() - 1
  exe "normal! g#Nzt" . (l:keepline > 0 ? l:keepline . "\<C-y>" : "" )
  redraw
  return getreg('/')
endfunction
nnoremap # <Esc>:call setreg('/', HighlightWordBySearch__())<CR>

"" add commands
command! -nargs=1 -complete=file Rename f <args>|call delete(expand('#'))

"ステータスライン
"左寄せ
set laststatus=2
set statusline=%<     " 長い時は左から切捨て
set statusline+=[%n]  " バッファ番号
set statusline+=%r    " [RO](readonly)表示
set statusline+=%h    " [Help](helpバッファ)表示
set statusline+=%w    " previewか？
set statusline+=%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}  " enc,fileformat表示
set statusline+=%y    " filetype表示
set statusline+=%m    " [+](修正中)表示
set statusline+=\     " 
if winwidth(0) >= 80
  set statusline+=%0.40F " フルパス(最大40文字)
else
  set statusline+=%t     " ファイル名のみ
endif
"右寄せ
set statusline+=%=\    " 区切り(右寄せ開始)
set statusline+=0x%B\  " カーソル下文字コード(16進数)
set statusline+=%{fugitive#statusline()} " Gitブランチ名表示(plugin vim-fugitiveが必要)
set statusline+=\ \   " 
set statusline+=%1l/%L, " [行位置]/[総行数],
set statusline+=%c%V    " [列位置](-[仮想列位置])
set statusline+=\ \   " 
set statusline+=%P    " ファイル位置(%)

"ctrlp.vim設定
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

let g:is_set_dev_plugin = 0
" (あれば)個別設定ファイル読み込み
let $LOCAL_MYVIMRC=$PWD.'/.localvimrc'
if filereadable($LOCAL_MYVIMRC)
  source $LOCAL_MYVIMRC
endif
" プラグイン開発用ディレクトリ設定
if g:is_set_dev_plugin
  execute pathogen#infect('dev/{}')
endif
