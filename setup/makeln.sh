#!/bin/bash
# dotfiles配下の各ファイルのシンボリックリンクをホームディレクトリに作成
# 元々あるファイルに関してはバックアップ
# ~/.dotfiles/bkup[YYmmddHHiiss]を生成

builtin cd `dirname $0` && builtin cd ../home
bkupdir=$HOME"/.dotfiles/bkup"`date +%Y%m%d%H%M%S`
mkdir -p ${bkupdir}

__set_dotfiles ()
{
  local dotfilename=$1
  if [ -e ~/${dotfilename} ]; then
    mv ~/${dotfilename} ${bkupdir}/
  fi
  [ -h ${HOME}/${dotfilename} ] && unlink ${HOME}/${dotfilename}
  ln -s `pwd`/${dotfilename} ~/
}

for filename in `ls -a | grep -E "^\.[a-z]+"`; do
  __set_dotfiles ${filename}
done

