if [ $(uname) != 'Darwin']; then
  alias ls='ls --color=always'
fi
#alias sl='ls --color=always'
alias ndu='ncdu'
alias v='vim'
alias vi='vim'
alias svim='sudo vim'
alias nodpms='xset -dpms;xset s off'
alias sz='source ~/.zshrc'
#alias webserver='python3 -m http.server 8383'
alias webserver='sudo thttpd -D -r -d . -p 8000 -l /dev/stdout -u kyle'
#alias intrace='/home/kabaka/software/intrace/intrace-1.4.3/intrace'
#alias gc='/home/kabaka/software/gcalcli/gcalcli'
alias x="chmod +x"
alias pc="~/projects/PayCalc/pc.rb"
alias g='git'
alias gp='~/bin/genpass.rb'
alias t='~/software/timebook/t'
#alias start-alpine='tmux new ~/scripts/alpine-notify.sh'
alias ss='~/bin/ss.sh'
alias mksh='echo "#!/bin/sh" >>'
#alias grep='grep --color=auto'
alias urldecode='python -c "import sys, urllib as ul; \
      print ul.unquote_plus(sys.argv[1])"'
alias urlencode='python -c "import sys, urllib as ul; \
      print ul.quote_plus(sys.argv[1])"'
