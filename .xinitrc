#!/bin/sh

setxkbmap -option compose:ralt
xset b on
xset r rate 200 25
xbindkeys
xmodmap /home/kabaka/.xmodmap

exec awesome -c /home/kabaka/.config/awesome/rc.lua >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
#exec ck-launch-session awesome

