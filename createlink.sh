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
ln -s $FROM/bashrc_local  $TO/.bashrc_local_private
mkdir -p $HOME/.ssh
ln -s $FROM/dot_ssh $HOME/.ssh/config
ln -s $FROM/tmux/dot_tmux.conf  $TO/.tmux.conf
ln -s $FROM/tmux/dot_tmux.d     $TO/.tmux
mkdir -p $HOME/.vagrant.d/
ln -s $FROM/vagrant/Vagrantfile  $HOME/.vagrant.d/Vagrantfile

if [ -f ~/.bashrc ]; then
	cat <<EOF >> $TO/.bashrc  
if [ -f ~/.bashrc_local_private ]; then
    source ~/.bashrc_local_private
fi
EOF
	source ~/.bashrc_local_private
fi
