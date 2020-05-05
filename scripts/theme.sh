#!/bin/bash

THEMEDIR=$HOME/dotfiles/config/termite
CONFIG=$HOME/.config/termite/config
THEME=""

case $1 in
    'l' | 'light') THEME=$THEMEDIR/light ;; 
    'd' | 'dark')  THEME=$THEMEDIR/dark  ;;
    *) exit 1;;
esac

unlink $CONFIG
ln -s $THEME $CONFIG
killall -USR1 termite
