#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

#exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
#exec $1
#if [ -z "$1" ] 
exec i3
#  then
#    exec i3
#elif [ "$1" = "i3" ] 
#  then
#    exec i3
#elif [ "$1" = "gnome-session" ] 
#  then
#    exec gnome-session
#elif [ "$1" = "gnome" ] 
#  then
#    exec gnome-session
#else
#  echo "Invalid window manager specified"
#fi
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
