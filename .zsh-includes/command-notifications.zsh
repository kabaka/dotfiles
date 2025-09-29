# Notifications for long-running or failed commands on macOS.
#
# When `osascript` is available (typically on macOS), this script dispatches a
# native notification any time a command fails or runs longer than LONG_TIME
# seconds (default: 20s). If AppleScript is unavailable the hooks quietly
# disable themselves.

# Track command state between the preexec and precmd hooks.
typeset -gA _command_feedback_state
_command_feedback_state=(
  start_time -1
  last_command ""
  last_command_name ""
)

# Delay notifications until commands run longer than LONG_TIME seconds.
: "${LONG_TIME:=20}"

# Detect whether AppleScript is available once so that the hook functions stay
# fast. If it is missing we skip sending notifications altogether because the
# target environment cannot display them anyway.
typeset -g _command_feedback_notifier="osascript"
if ! command -v osascript &>/dev/null; then
  _command_feedback_notifier=""
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

# Dispatch a notification with AppleScript when available.
function _command_feedback_notify() {
  emulate -L zsh
  local title message
  title="$1"
  message="$2"

  if [[ -z $_command_feedback_notifier ]]; then
    return
  fi

  local escaped_title escaped_message
  escaped_title="$(_command_feedback_escape_applescript "$title")"
  escaped_message="$(_command_feedback_escape_applescript "$message")"
  osascript -e "display notification \"$escaped_message\" with title \"$escaped_title\""
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
