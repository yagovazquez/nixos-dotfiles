#!/usr/bin/env bash
# Simple stopwatch for Waybar: start/pause/reset/print
# State file
STATE="${XDG_CACHE_HOME:-$HOME/.cache}/waybar-timer.state"

init_state() {
  mkdir -p "$(dirname "$STATE")"
  echo "running=0" > "$STATE"
  echo "start_ts=0" >> "$STATE"
  echo "elapsed=0" >> "$STATE"
}

read_state() {
  [[ -f "$STATE" ]] || init_state
  # shellcheck disable=SC1090
  . "$STATE"
}

write_state() {
  {
    echo "running=$running"
    echo "start_ts=$start_ts"
    echo "elapsed=$elapsed"
  } > "$STATE"
}

fmt() {
  local s=$1
  local h=$(( s / 3600 ))
  local m=$(( (s % 3600) / 60 ))
  local sec=$(( s % 60 ))
  printf "%02d:%02d:%02d" "$h" "$m" "$sec"
}

cmd="$1"
read_state
now=$(date +%s)

case "$cmd" in
  start)
    if [[ "$running" -eq 0 ]]; then
      running=1
      start_ts=$now
      write_state
    fi
    ;;
  pause|stop|toggle)
    if [[ "$running" -eq 1 ]]; then
      elapsed=$(( elapsed + (now - start_ts) ))
      running=0
      start_ts=0
      write_state
    else
      running=1
      start_ts=$now
      write_state
    fi
    ;;
  reset)
    running=0
    start_ts=0
    elapsed=0
    write_state
    ;;
  print|"" )
    # no state changes
    ;;
  *)
    echo "Usage: $0 [start|pause|stop|toggle|reset|print]" >&2
    exit 1
    ;;
esac

# Always print current value for Waybar
read_state
total=$elapsed
if [[ "$running" -eq 1 && "$start_ts" -gt 0 ]]; then
  total=$(( elapsed + (now - start_ts) ))
fi

# Output for Waybar (plain text; you can switch to JSON if you prefer)
echo "$(fmt "$total")"

