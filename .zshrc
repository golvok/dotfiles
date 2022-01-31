# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=100000
setopt appendhistory autocd beep nomatch notify interactivecomments
unsetopt extendedglob
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' max-errors 2
zstyle :compinstall filename '/home/matt/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

source ~/.bourne-shell-compatible-rc

#------------------------------
# Keybindings
# from http://zshwiki.org/home/zle/bindkeys
#------------------------------
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A myKeyCodes

myKeyCodes[Home]="$terminfo[khome]"
myKeyCodes[End]="$terminfo[kend]"
myKeyCodes[Insert]="$terminfo[kich1]"
myKeyCodes[Backspace]="$terminfo[kbs]"
myKeyCodes[Delete]="$terminfo[kdch1]"
myKeyCodes[Up]="$terminfo[kcuu1]"
myKeyCodes[Down]="$terminfo[kcud1]"
myKeyCodes[Left]="$terminfo[kcub1]"
myKeyCodes[Right]="$terminfo[kcuf1]"
myKeyCodes[PageUp]="$terminfo[kpp]"
myKeyCodes[PageDown]="$terminfo[knp]"

# setup key accordingly
bindkey -- "$myKeyCodes[Home]"      beginning-of-line
bindkey -- "$myKeyCodes[End]"       end-of-line
bindkey -- "$myKeyCodes[Insert]"    overwrite-mode
bindkey -- "$myKeyCodes[Backspace]" backward-delete-char
bindkey -- "$myKeyCodes[Delete]"    delete-char
bindkey -- "$myKeyCodes[Up]"        up-line-or-history
bindkey -- "$myKeyCodes[Down]"      down-line-or-history
bindkey -- "$myKeyCodes[Left]"      backward-char
bindkey -- "$myKeyCodes[Right]"     forward-char
bindkey -- "$myKeyCodes[PageUp]"    up-line-or-history
bindkey -- "$myKeyCodes[PageDown]"  down-line-or-history

bindkey -- "^[[1;5D" emacs-backward-word
bindkey -- "^[[1;5D" emacs-forward-word

# enable keypad-transmit when line editing
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        echoti smkx
    }
    function zle-line-finish () {
        echoti rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

#------------------------------
# Window title
# mostly stolen from https://github.com/MrElendig/dotfiles-alice/blob/master/.zshrc and
#------------------------------
case $TERM in
  termite|*xterm*|rxvt|rxvt-unicode|rxvt-256color|rxvt-unicode-256color|(dt|k|E)term)
    precmd () {
      print -Pn "\e]0;" # preable
      if [[ $TERM == *screen* ]]; then
        print -Pn "[screen: %n@%M]"
      else
        if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
          print -Pn "[%n@%M]"
        fi
        print -Pn "%2~"
      fi
      print -Pn "\a" # postamble
    }
    preexec () {
      print -Pn "\e]0;" # preable
      if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
        print -Pn "[%n@%M]"
      fi
      print -Pn "%2~ ($1)"
      print -Pn "\a" # postamble
    }
    ;;
esac

setprompt() {
  setopt prompt_subst

  if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
    p_host='%F{yellow}%M%f'
  else
    p_host='%F{green}%M%f'
  fi

  PS1=${(j::Q)${(Z:Cn:):-$'
    %F{cyan}[%f
    %(!.%F{red}%n%f.%F{green}%n%f)
    %F{cyan}@%f
    ${p_host}
    %F{cyan}][%f
    %F{blue}%~%f
    %F{cyan}]%f
    %(!.%F{red}%#%f.%F{green}%#%f)
    " "
  '}}

  PS2=$'%_>'
  RPROMPT=$'${vcs_info_msg_0_}'
}
setprompt

