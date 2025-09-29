# macOS notification feedback for long-running or failed commands.
#
# This replaces the legacy speaker beep implementation, which is not
# available on modern macOS systems. When running on macOS with the built-in
# `osascript` utility, the shell will surface notifications for
# long-running commands as well as failures.

# Guard early if notifications are not available (e.g. non-macOS systems).
if [[ "$(uname -s)" != "Darwin" ]] || ! command -v osascript &>/dev/null; then
  return
fi

# Defaults mirror the historical configuration: notify for commands in this
# list when they exceed LONG_TIME seconds.
: "${LONG_TIME:=20}"
: "${ALERT_LONG_RUN:=./configure make amake cp rsync scp wget transmission aria2c}"

# Track command state between hooks.
typeset -gA _command_feedback_state
_command_feedback_state=(
  start_time -1
  last_command ""
  last_command_name ""
)

# Convert the historic space-separated string into an array for matching.
typeset -ga _command_feedback_monitored
_command_feedback_monitored=(${=ALERT_LONG_RUN})

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

function _command_feedback_notify() {
  emulate -L zsh
  local title message
  title="$(_command_feedback_escape_applescript "$1")"
  message="$(_command_feedback_escape_applescript "$2")"
  osascript -e "display notification \"$message\" with title \"$title\""
}

function _command_feedback_preexec() {
  emulate -L zsh
  _command_feedback_state[start_time]=$SECONDS
  _command_feedback_state[last_command]="$1"
  _command_feedback_state[last_command_name]="${1%%[[:space:]]*}"
  if [[ -z ${_command_feedback_state[last_command_name]} ]]; then
    _command_feedback_state[last_command_name]="$1"
  fi
}

function _command_feedback_command_tracked() {
  emulate -L zsh
  local candidate
  for candidate in "${_command_feedback_monitored[@]}"; do
    if [[ $candidate == ${_command_feedback_state[last_command_name]} ]]; then
      return 0
    fi
  done
  return 1
}

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

  if (( duration >= LONG_TIME )) && _command_feedback_command_tracked; then
    _command_feedback_notify "Command finished" \
      "${_command_feedback_state[last_command_name]} completed in ${duration}s"
  fi
}

add-zsh-hook preexec _command_feedback_preexec
add-zsh-hook precmd _command_feedback_precmd
