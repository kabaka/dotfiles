if [ $(uname) != 'Darwin' ]; then
  alias ls='ls --color=always'
fi
alias ndu='ncdu'
alias v='vim'
alias vi='vim'
alias svim='sudo vim'
alias sz='source ~/.zshrc'
alias webserver='python3 -m http.server'
alias x="chmod +x"
alias t='~/software/timebook/t'
alias mksh='echo "#!/bin/sh" >>'
alias urldecode='python3 -c "import sys, urllib.parse as up; \
      print(up.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as up; \
      print(up.quote_plus(sys.argv[1]))"'
