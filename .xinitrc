#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# enable Print Screen compose key
setxkbmap -option compose:prsc

# try to make custom compose sequences available to more apps
# export GTK_IM_MODULE=xim
# export XMODIFIERS="@im=none"
# export QT_IM_MODULE=xim

# make eclipse stop flickering
# export SWT_GTK3=0

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/bin/gnome-keyring-daemon --start --components=secrets

eval $(/usr/bin/ssh-agent -s)

function startup_programs() {
    sleep 5
    nm-applet &
    qbat &
    dunst & # notification daemon
    # xidlehook --not-when-fullscreen --not-when-audio --timer $((15 * 60)) 'systemctl suspend' '' &
    # /usr/bin/xscreensaver -no-splash -display :0.0 &
}
startup_programs &
exec i3
