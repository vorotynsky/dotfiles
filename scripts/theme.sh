#!/bin/bash

CONFIG=$HOME/.config/termite/config
THEME=""

case $1 in
    'l' | 'light') THEME=light ;; 
    'd' | 'dark')  THEME=dark  ;;
    *) exit 1;;
esac

function switch {
    unlink $2
    ln -s "$1/$THEME" $2
}

#        theme source                               config file
switch   $HOME/dotfiles/config/termite              $HOME/dotfiles/config/termite/config
switch   $HOME/dotfiles/config/polybar/colors       $HOME/dotfiles/config/polybar/colors.ini

killall -USR1 termite
($HOME/dotfiles/config/polybar/launchi3.sh 2> /dev/null > /dev/null)
