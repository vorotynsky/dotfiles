#!/bin/bash

DOTCONF=$HOME/dotfiles/config
CONFIG=$HOME/.config/termite/config
THEME=""
FILESTAT=$HOME/.cache/theme
echo "" >> $FILESTAT

function swap {
    case $THEME in 
        'light') THEME='dark';;
        'dark' ) THEME='light';;
        *) exit 1;;
    esac
}

case $1 in
    'l' | 'light') THEME=light ;; 
    'd' | 'dark')  THEME=dark  ;;
    *)  THEME=$(cat $FILESTAT)
        swap                   ;;
esac

echo $THEME > $FILESTAT

function switch {
    unlink $2
    ln -s "$1/$THEME" $2
}

#        theme source                  config file
switch   $DOTCONF/termite              $DOTCONF/termite/config
switch   $DOTCONF/polybar/colors       $DOTCONF/polybar/colors.ini
switch   $DOTCONF/zathura              $DOTCONF/zathura/zathurarc

killall -USR1 termite
($HOME/dotfiles/config/polybar/launchi3.sh 2> /dev/null > /dev/null)
