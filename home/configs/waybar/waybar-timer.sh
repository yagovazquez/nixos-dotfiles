#!/usr/bin/env bash
# Waybar chronometer: stopwatch (count up) + timer (countdown) modes.
# State file
STATE="${XDG_CACHE_HOME:-$HOME/.cache}/waybar-timer.state"

TIMER_PRESETS_MIN=(5 10 15 20 30 45 60)

init_state() {
  mkdir -p "$(dirname "$STATE")"
  {
    echo "mode=stopwatch"
    echo "running=0"
    echo "start_ts=0"
    echo "elapsed=0"
    echo "duration=0"
    echo "remaining=0"
    echo "notified=0"
  } > "$STATE"
}

read_state() {
  [[ -f "$STATE" ]] || init_state
  # shellcheck disable=SC1090
  . "$STATE"
  : "${mode:=stopwatch}"
  : "${running:=0}"
  : "${start_ts:=0}"
  : "${elapsed:=0}"
  : "${duration:=0}"
  : "${remaining:=0}"
  : "${notified:=0}"
}

write_state() {
  {
    echo "mode=$mode"
    echo "running=$running"
    echo "start_ts=$start_ts"
    echo "elapsed=$elapsed"
    echo "duration=$duration"
    echo "remaining=$remaining"
    echo "notified=$notified"
  } > "$STATE"
}

fmt() {
  local s=$1
  local h=$(( s / 3600 ))
  local m=$(( (s % 3600) / 60 ))
  local sec=$(( s % 60 ))
  printf "%02d:%02d:%02d" "$h" "$m" "$sec"
}

notify_finished() {
  local msg="Timer finished - $(fmt "$duration") elapsed"
  hyprctl dispatch "hl.dsp.exec_cmd([[ [float; size 420 160; center] kitty \
    --title waybar-timer-done \
    bash -lc $(printf '%q' "echo; echo '$msg'; echo; read -rp 'Press Enter to close...'") ]])" >/dev/null 2>&1 &
}

cmd="$1"
read_state
now=$(date +%s)

case "$cmd" in
  start)
    if [[ "$mode" == "stopwatch" && "$running" -eq 0 ]]; then
      running=1
      start_ts=$now
      write_state
    fi
    ;;

  pause|stop|toggle)
    if [[ "$mode" == "timer" && "$running" -eq 0 && "$remaining" -le 0 ]]; then
      # Restart a finished timer with the same duration
      remaining=$duration
      running=1
      start_ts=$now
      notified=0
      write_state
    elif [[ "$running" -eq 1 ]]; then
      if [[ "$mode" == "stopwatch" ]]; then
        elapsed=$(( elapsed + (now - start_ts) ))
      else
        remaining=$(( remaining - (now - start_ts) ))
        (( remaining < 0 )) && remaining=0
      fi
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
    mode=stopwatch
    running=0
    start_ts=0
    elapsed=0
    duration=0
    remaining=0
    notified=0
    write_state
    ;;

  timer-start)
    choice=$(printf '%s\n' "${TIMER_PRESETS_MIN[@]/%/ min}" "Custom..." | rofi -dmenu -i -p "Timer" -selected-row 0 2>/dev/null || true)
    [[ -z "$choice" ]] && exit 0

    if [[ "$choice" == "Custom..." ]]; then
      mins=$(rofi -dmenu -i -p "Minutes" <<< "" 2>/dev/null || true)
    else
      mins=${choice%% *}
    fi
    [[ -z "$mins" ]] && exit 0

    if ! [[ "$mins" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
      exit 0
    fi
    secs=$(awk "BEGIN { printf \"%d\", $mins * 60 }")
    (( secs <= 0 )) && exit 0

    mode=timer
    duration=$secs
    remaining=$secs
    running=1
    start_ts=$now
    notified=0
    write_state
    ;;

  print|"")
    ;;

  *)
    echo "Usage: $0 [start|toggle|reset|timer-start|print]" >&2
    exit 1
    ;;
esac

# Recompute live values for display (re-read in case the case block changed state)
read_state
now=$(date +%s)

if [[ "$mode" == "timer" ]]; then
  live_remaining=$remaining
  if [[ "$running" -eq 1 ]]; then
    live_remaining=$(( remaining - (now - start_ts) ))
  fi
  if (( live_remaining <= 0 )); then
    live_remaining=0
    if [[ "$running" -eq 1 && "$notified" -eq 0 ]]; then
      notified=1
      running=0
      remaining=0
      write_state
      notify_finished
    fi
    class="timer-finished"
  else
    class="timer-running"
  fi
  text=$(fmt "$live_remaining")
else
  total=$elapsed
  if [[ "$running" -eq 1 ]]; then
    total=$(( elapsed + (now - start_ts) ))
  fi
  text=$(fmt "$total")
  class="stopwatch"
fi

# Output for Waybar (JSON: text + class drive the color changes)
printf '{"text":"%s","class":"%s"}\n' "$text" "$class"
