#!/bin/sh

urxvtd -q -f -o

setxkbmap -option compose:ralt
xset b on
xset r rate 200 25
xbindkeys
xmodmap ~/.xmodmap

exec awesome -c ~/.config/awesome/rc.lua >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
#exec ck-launch-session awesome

