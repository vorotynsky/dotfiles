#!/bin/zsh

cd ~/.cache/
cp ./histfile ./histfile.bad
strings -eS ./histfile.bad > ./histfile
fc -R ./histfile

