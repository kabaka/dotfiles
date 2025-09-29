# Notifications for long-running or failed commands on macOS.
#
# When `osascript` is available (i.e. on macOS), this script dispatches a
# native notification any time a command fails or runs longer than LONG_TIME
# seconds (default: 20s). In development environments that lack `osascript`
# the same information is echoed to the terminal, which keeps the hooks
# observable for testing without breaking interactive shells.

# Track command state between the preexec and precmd hooks.
typeset -gA _command_feedback_state
_command_feedback_state=(
  start_time -1
  last_command ""
  last_command_name ""
)

# Delay notifications until commands run longer than LONG_TIME seconds.
: "${LONG_TIME:=20}"

# Detect the notification mechanism once so that the hook functions stay fast.
typeset -g _command_feedback_notifier="osascript"
if [[ "$(uname -s)" != "Darwin" ]] || ! command -v osascript &>/dev/null; then
  _command_feedback_notifier="debug-log"
fi

autoload -Uz add-zsh-hook
add-zsh-hook -d preexec _command_feedback_preexec 2>/dev/null || true
add-zsh-hook -d precmd _command_feedback_precmd 2>/dev/null || true

# Escape strings for AppleScript.
function _command_feedback_escape_applescript() {
  emulate -L zsh
  local input="$1"
  # Escape backslashes and double quotes, and normalise newlines to spaces.
  printf '%s' "$input" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/\n/ /g'
}

# Dispatch a notification using either AppleScript or a debug logger.
function _command_feedback_notify() {
  emulate -L zsh
  local title message
  title="$1"
  message="$2"

  case "$_command_feedback_notifier" in
    osascript)
      local escaped_title escaped_message
      escaped_title="$(_command_feedback_escape_applescript "$title")"
      escaped_message="$(_command_feedback_escape_applescript "$message")"
      osascript -e "display notification \"$escaped_message\" with title \"$escaped_title\""
      ;;
    debug-log)
      print -r -- "[command-notifications] $title — $message"
      ;;
  esac
}

# Capture the command text just before the shell executes it.
function _command_feedback_preexec() {
  emulate -L zsh
  _command_feedback_state[start_time]=$SECONDS
  _command_feedback_state[last_command]="$1"
  _command_feedback_state[last_command_name]="${1%%[[:space:]]*}"
  if [[ -z ${_command_feedback_state[last_command_name]} ]]; then
    _command_feedback_state[last_command_name]="$1"
  fi
}

# Report on the command once the prompt is about to be shown again.
function _command_feedback_precmd() {
  local exit_code=$?
  emulate -L zsh
  local duration=0

  if (( _command_feedback_state[start_time] >= 0 )); then
    duration=$(( SECONDS - _command_feedback_state[start_time] ))
  fi
  _command_feedback_state[start_time]=-1

  if (( exit_code != 0 )); then
    _command_feedback_notify "Command failed (exit $exit_code)" \
      "${_command_feedback_state[last_command]}"
    return
  fi

  if (( duration >= LONG_TIME )); then
    _command_feedback_notify "Command finished" \
      "${_command_feedback_state[last_command_name]} completed in ${duration}s"
  fi
}

add-zsh-hook preexec _command_feedback_preexec
add-zsh-hook precmd _command_feedback_precmd
