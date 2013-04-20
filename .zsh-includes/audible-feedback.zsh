LONG_TIME=20
ALERT_LONG_RUN='./configure make amake cp rsync scp wget transmission aria2c'

#alias alert_helper='history|tail -n1|sed -e "s/^\s*[0-9]\+\s*//" -e "s/;\s*alert$//" | sed -e "s/&/+/g" | sed -e "s/++ alert//g"'
#alias alert='notify-send "Finished Job" "[$?] $(alert_helper)" && beep'

# For measuring command duration so that long-running commands can be handled
# differently later on (alerts, beeps, etc.)
function preexec {
  (( $#_elapsed > 1000 )) && set -A _elapsed $_elapsed[-100,-1]
  typeset -ig _start=SECONDS
}

# Audible feedback on commands and long-running command handler.
function precmd {
  (( _start >= 0 )) && set -A _elapsed $_elapsed $(( SECONDS-_start ))
  _start=-1

  PREVIOUS_FULL=`history | tail -n1 | sed 's/ \+/\t/g'`
  PREVIOUS=`echo $PREVIOUS_FULL | cut -f2`
  PREVIOUS_FULL=`echo $PREVIOUS_FULL | cut -f2-`

  if [[ $ALERT_LONG_RUN = *$PREVIOUS* ]]; then
    if [ $_elapsed[-1] -ge $LONG_TIME ]; then
      beep -f 880 -l 100 -d 30 -r 3
    fi
  fi

  exit_code=${?}
  if [ $exit_code = 0 ]; then
    beep -f 440 -l 10
     
  fi

  if [ $exit_code != 0 ]; then
    beep -f 110 -l 100
  fi
}

