#!/bin/bash -x

FROM=$PWD
TO=$HOME


if [ -d $FROM/bashrc.d ]; then
    ln -s $FROM/bashrc.d $TO/bashrc.d
fi
ln -s $FROM/dot_emacs  $TO/.emacs
ln -s $FROM/gitconfig  $TO/.gitconfig
if [ -f $TO/emacs.d ]; then
    ln -s $FROM/emacs.d   $TO/emacs.d 
fi
ln -s $FROM/bashrc_local  $TO/.bashrc_local


#if [ -f ~/.bashrc ]; then
#cat <<EOF >> $TO/.bashrc  
#if [ -f ~/.bashrc_local ]; then
#    . ~/.bashrc_local
#fi
#
#EOF
#fi
