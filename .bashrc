#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PATH="$PATH:/home/matt/bin"

alias ls='ls --color=auto'
alias nvidia-settings='primusrun nvidia-settings -c :8'
alias afpNITROGENmatthome='afp_client mount -u matt -p - "NITROGEN.local:matt" ~/afp_NITROGENmatthome'
alias minecraft='primusrun java -jar ~/Software/minecraftLauncher.jar'
alias go=gnome-open
alias xo=xdg-open
alias gcc-m='gcc -std=c99 -lm'
alias gcc-md='gcc-m -Wall -pedantic -Wextra'
alias make='make -j9 -l10'
alias gitst='git status'
alias remake='make clean && make'
alias wine32='WINEPREFIX=~/.wine32 WINEARCH=wine32'
alias cdcs='cd ~/Documents/school/University/year_3-2014/semester_2/'

function virtualbox() {
    sudo modprobe vboxdrv;
    sudo modprobe vboxnetadp;
    sudo modprobe vboxnetflt;
    /usr/bin/virtualbox;
}

man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

go-loop() {
	for f in "$@"; do
		gnome-open "$f"
	done
}

export EDITOR=vim
PS1='[\u@\h \W]\$ '

