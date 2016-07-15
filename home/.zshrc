########################################
# my config

########################################
# bash設定の読み込みを追加
source ~/.bash_profile
source ~/.bashrc

alias peco='peco --layout=bottom-up'
. ~/.mytools/peco/init.sh
#. ~/.mytools/step/init.sh

# cd shortcut
## shift + up で上階層のディレクトリに移動
function _local_up_cd(){
    builtin cd ..
    echo "\r\n"
    zle reset-prompt
}
zle -N _local_up_cd
bindkey '[1;2A' _local_up_cd

## shift + down で下2階層のディレクトリをpecoで表示して移動
function _local_down_cd(){
    local select_path=$(find . -type d -maxdepth 2 -mindepth 1 2>/dev/null | grep -v "\/\." | peco)
    if [ ${select_path} ]; then
        cd "${select_path}"
        zle reset-prompt
    fi
}
zle -N _local_down_cd
bindkey '[1;2B' _local_down_cd

#open wandbox
alias wand='open http://melpon.org/wandbox'
alias phptest='open https://wandbox.fetus.jp'

alias mhh='cat ~/.mytools/help'
alias ctags="`brew --prefix`/bin/ctags"
alias diff='colordiff'
alias gnet="osascript .mytools/osa/hothot.scpt 'Google Chrome'"
alias chat="osascript .mytools/osa/hothot.scpt 'Slack'"
alias dir="osascript .mytools/osa/hothot.scpt 'Finder'"

# disabled zsh options
unsetopt auto_cd

# pash config
#export PATH="/opt/chefdk/embedded/bin:$PATH"
# stop ctrl-s/ctrl-q
setopt NO_FLOW_CONTROL
# prompt config
PS1='%{[32m%}[%m][20%D %T]%{[00m%} %~
%# '
# terminfo config
export TERMINFO=~/.terminfo
# add plugin
source ~/workspace/setuptools/enhancd/init.sh
########################################

