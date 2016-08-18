source /etc/X11/xinit/xinitrc.d/*

if [ -s ~/.Xmodmap ]; then
	xmodmap ~/.Xmodmap
fi

nm-applet &
#( ( sleep 10 && qbat) & )
blueman-applet &
#( ( sleep 10 && /usr/bin/xscreensaver -no-splash -display :0.0 ) & )
#exec awesome
#xterm &
#exec twm

dunst &
exec i3


