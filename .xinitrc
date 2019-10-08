source /etc/X11/xinit/xinitrc.d/*

if [ -s ~/.Xmodmap ]; then
	xmodmap ~/.Xmodmap
fi

# enable Print Screen compose key
setxkbmap -option compose:prsc

# try to make custom compose sequences available to more apps
export GTK_IM_MODULE=xim
# export XMODIFIERS="@im=none"
export QT_IM_MODULE=xim

#make eclipse stop flickering
export SWT_GTK3=0

nm-applet &
( ( sleep 10 && qbat) & )
blueman-applet &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/bin/gnome-keyring-daemon --start --components=secrets
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

eval $(/usr/bin/ssh-agent -s)

( ( sleep 10 && /usr/bin/xscreensaver -no-splash -display :0.0 ) & )
#exec awesome

#xterm &
#exec twm

dunst &
exec i3


