#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PATH="$PATH:/home/matt/bin"

alias nvidia-settings='primusrun nvidia-settings -c :8'
alias afpNITROGENmatthome='afp_client mount -u matt -p - "NITROGEN.local:matt" ~/afp_NITROGENmatthome'
alias minecraft='primusrun java -jar ~/Software/minecraftLauncher.jar'
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

function funchelp() { grep "function" "$HOME/.bashrc"; }

function edit() {
	if [[ $1 == "brc" ]]; then
		echo "not what you meant"
		return;
	fi
	for f in "$@"; do
		touch "$f";
	done
	subl3 -n "$@";
}

function editbrc() { edit ~/.bashrc "$@"; }

function gerp() { grep "$@"; }
alias grep="grep --color=always"
function trim_whitespace() {
	echo "$1" | awk '{gsub(/(^ +)|( +$)/,"")} {print $0}'
}

function line() { (
	if [[ $2 == "" ]]; then
		set -- "${@:1:1}" "." "${@:3}"
	fi
	exec 5>&1;
	FILES=$(grep --binary-files=without-match --color=always -rni "$@" | awk 'BEGIN{i=0}{i++; print i ": " $0}' | tee >(cat - >&5) | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | cut -d ":" -f2-3)
	if [[ $FILES == "" ]]; then
		echo "no matches!";
		return;
	fi
	echo -n "choose line (n,e,#): "
	read LINE_CHOICE
	if [[ $LINE_CHOICE == "n" ]]; then
		ARGS="-n"
		echo -en "choose line (in new editor) (e,#): "
		read LINE_CHOICE
	fi
	if [[ $LINE_CHOICE == "e" ]]; then
		P4_EDIT_IT="yes"
		echo -en "will p4 edit. choose line (n,#): "
		read LINE_CHOICE
	fi
	if [[ $LINE_CHOICE == "n" ]]; then
		ARGS="-n"
		echo -en "choose line (in new editor) (#): "
		read LINE_CHOICE
	fi

	FILE_AND_LINE_TO_EDIT="$(trim_whitespace "$(echo "$FILES" | sed -n "${LINE_CHOICE}p" )" )"
	FILE_TO_EDIT="${FILE_AND_LINE_TO_EDIT%:*}"

	if [[ $P4_EDIT_IT == "yes" ]]; then
		p4 edit "$FILE_TO_EDIT"
	fi

	$EDITOR $ARGS "$FILE_AND_LINE_TO_EDIT"
); }

function pn() { ping_noise "$@"; }
function ping_noise() {
	TIMES="1"
	DELAY="no"

	if [[ $1 == "-d" ]]; then
		DELAY="yes"
		if [[ $2 != "" ]]; then
			TIMES="$2"
		fi
	elif [[ $1 != "" ]]; then
		TIMES="$1"
	fi

	for i in $(seq 1 "$TIMES"); do
		if [[ $DELAY == "yes" ]]; then
			sleep 2
		fi
		( aplay -q & )
		DELAY="yes"
	done
}

function nn() { noise_notify "$@"; }
function noise_notify() {
	if [[ "$@" == "" ]]; then
		MESSAGE="$PWD";
	else
		MESSAGE="$@";
	fi

	ping_noise & notify-send -t 60000 "$MESSAGE";
}

function make_p() { (
	make -j9 -l9 "$@"
	MAKE_RESULT="$?"

	NOTIFY_STRING="$(basename $PWD): 'make_p $*' done"

	nn "$NOTIFY_STRING" &

	exit "$MAKE_RESULT"
) }
alias make_P=make_p;

function wait_for() {
	if [[ $1 == "-r" ]]; then
		REMOVE=true
		FILE="$2"
	else
		REMOVE=false
		FILE="$1"
	fi

	while [ ! -f "$FILE" ]; do
		sleep 2
	done

	echo "waited!"

	if [[ $REMOVE = true ]]; then
		rm "$FILE"
	fi
}

function anywait(){
    for pid in "$@"; do
        while kill -0 "$pid"; do
            sleep 0.5
        done
    done
}

function cdar() { cd *$@* ; }
function cdrecent() { cd $(find ./ -maxdepth 1 -type d -regex \"\\\\./[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]-.*\" | sort | tail -n 1 - ) "$@"; }
function cdlast() { cd $(find ./ -maxdepth 1 -type d | tail -n 1 - ) "$@"; }
function cd..() { cd ".." "$@"; }

function decolour() { echo -ne '\e[0m' "$@"; }

function go() { for arg in "$@" ; do xdg-open "$arg" &; done; }

function rmthisdir() {
	HERE="$PWD"
	rmdir -v "$HERE" && cd "$(dirname "$HERE")"
}

alias ls="ls --color=auto"

alias les="less"
alias lesss="less"
alias less="less -SIR"

function date() {
	if [ $# -eq 0 ]; then
		date "+%F %T (%a)";
	else
		"$(which date)" "$@"
	fi
}

function mkdatedir() {
	mkdir "$(date "+%F")-$1"
}

function tsv_view() {
	if ! [ $? ]; then
		return
	fi

	FILE="$(mktemp)"

	# all short lines go through column
	grep -v -e '[^\]\{84,\}' "$1" | column -s "	" -t >> "$FILE"

	# the rest get pasted at the end
	grep -e '[^\]\{84,\}' "$1" >> "$FILE"

	# open the resutls in less
	less -#2 -SI "$FILE"

	# remove temporary
	rm -f "$FILE"
}

function untar() { tar -xf "$1"; }
function tarxz() { tar -cJf "$1.tar.xz" "$1"; }
function untarxz() { tar -xJf "$1"; }

# print process tree, up to init
function procsup() {
	leaf=$$;
	ps -eo pid,ppid,command | awk -v leaf="$leaf" '
		{parent[$1]=$2;command[$1]=$3;}
		function print_ancestry(pid)
		{
			print pid " : " command[pid]
			if(pid!=1) print_ancestry(parent[pid])
		};
		END{
			print_ancestry(leaf)
		}
	'
}

function do_in_parallel() {
	for d in $1; do
		( cd "$d" && $2 ) &
	done
	wait
	( ping_noise & )
}

export EDITOR=vim
PS1='[\u@\h \W]\$ '

