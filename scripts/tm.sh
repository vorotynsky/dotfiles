#!/bin/sh
# (c) 2020 Vorotynsky Maxim <vorotynsky.maxim@gmail.com>
# terminal copy

# number  amount of new terminals
# -i3s    use i3-sensible-terminal
# without arguments: copies one terminal

sid=$(( $(ps -o sid= -p "$$") ))
emulator_id=$(( $(ps -o ppid= -p $sid) ))
emulator_name=$(ps -o comm= -p $emulator_id)

count=1

shopt -s extglob
for var in $@
do
    case "$var" in
    +([0-9]) )
        count=$1 ;;
    "-i3s") 
        emulator_name="i3-sensible-terminal"
    esac
done


case $emulator_name in
    electron) # vscode
        vscode=$(which code)
        emulator="$vscode ."
        ;;
    vim | nvim) # copies terminal emulator, not vim
        emulator_id=$(( $(ps -o ppid= -p $emulator_id) ))
        emulator_id=$(( $(ps -o ppid= -p $emulator_id) ))
        emulator_name=$(ps -o comm= -p $emulator_id)
        emulator=$(which $emulator_name)
        ;;

    *) emulator=$(which $emulator_name) ;;
esac


if [ $count -gt 10 ]
then
    printf "Copy $count times? [y/N] "
    read
    case $(echo "$REPLY" | awk '{print tolower($0)}') in
        "y" | "yes") ;;
        *) exit 1
    esac
fi


for n in $(seq $count) 
do
    $emulator &
done
