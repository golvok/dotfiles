source /etc/X11/xinit/xinitrc.d/*

if [ -s ~/.Xmodmap ]; then
	xmodmap ~/.Xmodmap
fi

nm-applet &
( ( sleep 10 && qbat) & )
blueman-applet &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

#( ( sleep 10 && /usr/bin/xscreensaver -no-splash -display :0.0 ) & )
#exec awesome

#xterm &
#exec twm

dunst &
exec i3


