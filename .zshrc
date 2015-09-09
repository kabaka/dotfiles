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
setopt PROMPT_SUBST

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

autoload -U promptinit
autoload -U zmv
autoload -U edit-command-line

promptinit


export GREP_COLOR="1;33"
export GPGKEY="A30E6576"
export KEYTIMEOUT=1

PATH="$HOME/bin:$HOME/bin/local:$HOME/bin/local/node_modules/bin:/usr/local/bin:/usr/local/sbin/:/bin:/sbin:/usr/bin:/usr/sbin:$PATH"

# default applications
#
SVN_EDITOR='vim'
VISUAL='vim'
EDITOR='vim'

PAGER='less'
BROWSER='chromium-browser'


TZ="UTC"

HISTFILE=$HOME/.zhistory
HISTSIZE=1000
SAVEHIST=10000
HOSTNAME="`hostname`"

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

# CodeMonkeyMike/ZshTheme-CodeMachine
function prompt_git() {
  tester=$(git rev-parse --git-dir 2> /dev/null) || return

  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""

  if $(echo "$(git log origin/$(git_current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi

  if $(echo "$INDEX" | grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
  fi

  if $(echo "$INDEX" | grep -E -e '^[ MARC][MD] ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi

  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi

  if $(echo "$INDEX" | grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi

  if [[ -n $STATUS ]]; then
    STATUS=" $STATUS"
  fi

  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(prompt_git_current_branch)$STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$PR_LIGHT_WHITE%}[%{$PR_YELLOW%} "
ZSH_THEME_GIT_PROMPT_AHEAD="%{$PR_MAGENTA%}↑"
ZSH_THEME_GIT_PROMPT_STAGED="%{$PR_GREEN%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$PR_RED%}●"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$PR_WHITE%}●"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$PR_RED%}✘"
ZSH_THEME_GIT_PROMPT_SUFFIX="$PR_LIGHT_WHITE]%{$PR_NO_COLOR%} "

function prompt_git_current_branch() {
  echo $(git_current_branch || echo "(no branch)")
}

function git_current_branch() {
  echo "$(git branch --no-color | grep '\*' | cut -d' ' -f2-)"
}

SSH="$PR_LIGHT_GREEN(ssh)$PR_NO_COLOR "

function prompt_ssh() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo $SSH;
  fi
}

function prompt_return() {

  if [[ $? -ne 0 ]]; then
    echo "[%{$PR_LIGHT_RED%}%?%{$PR_NO_COLOR%}] "
  fi
}

PROMPT='$(prompt_return)$(prompt_ssh)$PR_LIGHT_MAGENTA%c %(!.$PR_LIGHT_RED.$PR_LIGHT_WHITE)%#$PR_NO_COLOR '
RPROMPT_BASE='$(prompt_git)$PR_RED%n$PR_WHITE@%(!.$PR_LIGHT_RED.$PR_LIGHT_WHITE)%m%f$PR_NO_COLOR'

function zle-line-init zle-keymap-select {
VIM_PROMPT="%{$PR_LIGHT_WHITE%}[%{$PR_LIGHT_YELLOW%}vi mode %{$PR_LIGHT_RED%}NORMAL%{$PR_LIGHT_WHITE%}]%{$PR_NO_COLOR%}"
RPROMPT="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $RPROMPT_BASE"
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select


# lol how do I utf-8 with uclibcalpine

LC_ALL='en_US.UTF-8'
LANG='en_US.UTF-8'
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

beep -f 220 -l 25 -d 25
beep -f 240 -l 25 -d 25
beep -f 260 -l 25

export PERL_LOCAL_LIB_ROOT="/home/kabaka/perl5";
export PERL_MB_OPT="--install_base /home/kabaka/perl5";
export PERL_MM_OPT="INSTALL_BASE=/home/kabaka/perl5";
export PERL5LIB="/home/kabaka/perl5/lib/perl5/x86_64-linux-thread-multi:/home/kabaka/perl5/lib/perl5";
export PATH="/home/kabaka/perl5/bin:$PATH";
eval "$(dircolors ~/.dircolors)"

