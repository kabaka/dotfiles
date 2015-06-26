#setopt NOHUP
#setopt NOTIFY
#setopt NO_FLOW_CONTROL
setopt INC_APPEND_HISTORY SHARE_HISTORY
setopt APPEND_HISTORY
#setopt AUTO_LIST		# these two should be turned off
#setopt AUTO_REMOVE_SLASH
#setopt AUTO_RESUME		# tries to resume command of same name
unsetopt BG_NICE		# do NOT nice bg commands
setopt CORRECT			# command CORRECTION
setopt EXTENDED_HISTORY		# puts timestamps in the history
#setopt HASH_CMDS		# turns on hashing
setopt MENUCOMPLETE
setopt ALL_EXPORT

setopt   notify globdots correct pushdtohome cdablevars autolist
setopt   correctall autocd recexact longlistjobs
setopt   autoresume histignoredups pushdsilent 
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash

# Autoload zsh modules when they are referenced
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
#zmodload -ap zsh/mapfile mapfile

autoload -U zmv

export GREP_COLOR="1;33"
export GPGKEY="A30E6576"

SVN_EDITOR='vim'
VISUAL='vim'
PATH="$HOME/bin:$HOME/bin/local:/usr/local/bin:/usr/local/sbin/:/bin:/sbin:/usr/bin:/usr/sbin:$PATH"
TZ="UTC"
HISTFILE=$HOME/.zhistory
HISTSIZE=1000
SAVEHIST=10000
HOSTNAME="`hostname`"
PAGER='less'
EDITOR='vim'


# I am not really a fan of this color thing, but it was copy/pasted and I am
# too lazy to change.
autoload colors zsh/terminfo

if [[ "$terminfo[colors]" -ge 8 ]]; then
  colors
fi

for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
  eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
  eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
  (( count = $count + 1 ))
done
PR_NO_COLOR="%{$terminfo[sgr0]%}"

PS1="[$PR_RED%n%(!.$PR_LIGHT_RED.$PR_LIGHT_WHITE)@%m%f $PR_LIGHT_CYAN%c%(!.$PR_LIGHT_RED]$PR_NO_COLOR.$PR_NO_COLOR]) %(!.#.$) "


# lol how do I utf-8 with uclibc

#LC_ALL='en_US.UTF-8'
#LANG='en_US.UTF-8'
#LC_CTYPE=C
CHARSET=UTF-8

unsetopt ALL_EXPORT

for f in ~/.zsh-includes/*; do
  source $f
done

case $TERM in
  xterm) TERM=xterm-256color
  ;;  
esac

#beep -f 220 -l 25 -d 25
#beep -f 240 -l 25 -d 25
#beep -f 260 -l 25

export PERL_LOCAL_LIB_ROOT="/home/kabaka/perl5";
export PERL_MB_OPT="--install_base /home/kabaka/perl5";
export PERL_MM_OPT="INSTALL_BASE=/home/kabaka/perl5";
export PERL5LIB="/home/kabaka/perl5/lib/perl5/x86_64-linux-thread-multi:/home/kabaka/perl5/lib/perl5";
export PATH="/home/kabaka/perl5/bin:$PATH";

