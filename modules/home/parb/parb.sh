# parb – pull and rebuild: git pull + nixos-rebuild switch, while the NixOS
# snowflake spins. Only the last 5 lines of build output are shown.

REPO="$HOME/nixos-config"
LOG=$(mktemp -t parb.XXXXXX.log)

cd "$REPO" || { echo "parb: $REPO not found" >&2; exit 1; }

# Ask for the sudo password up front, before the animation takes the screen.
sudo -v || exit 1

# Keep the currently active light/dark specialisation (see modules/theme-mode.nix).
SPEC=()
if [[ -r /etc/theme-mode ]]; then
  SPEC=(--specialisation "$(cat /etc/theme-mode)")
fi

(git pull && sudo nixos-rebuild switch "${SPEC[@]}" "$@") >"$LOG" 2>&1 &
PID=$!

# --- frames -------------------------------------------------------------------
# SNOW_FILE: NixOS snowflake rotating, pre-rendered with parb/gen-frames.sh
# (chafa). TUX_FILE: hand-drawn dancing Tux. Both set by parb.nix; frames are
# separated by "---" lines.
load_frames() { # load_frames <file> <array name>
  local -n out=$2
  local cur="" line
  out=()
  while IFS= read -r line; do
    if [[ $line == "---" ]]; then
      out+=("$cur")
      cur=""
    else
      cur+="${cur:+$'\n'}$line"
    fi
  done <"$1"
  out+=("$cur")
}
load_frames "$SNOW_FILE" SNOW
load_frames "$TUX_FILE" TUX
SNOW_W=42                                # snowflake column width incl. gap
ART_LINES=$(wc -l <<<"${SNOW[0]}")
TUX_LINES=$(wc -l <<<"${TUX[0]}")
TUX_TOP=$((ART_LINES - TUX_LINES))       # Tux stands on the bottom line
TAIL_LINES=5
TOTAL=$((ART_LINES + 1 + TAIL_LINES))

COLOR_LOGO=$'\033[34m'   # blue snowflake
COLOR_TUX=$'\033[33m'    # yellow Tux
COLOR_LOG=$'\033[2m'     # dim build output
RESET=$'\033[0m'

# The animation runs on the alternate screen, so it never scrolls the terminal
# and leaves no residue; the result is printed on the normal screen afterwards.
# shellcheck disable=SC2329  # invoked via trap
cleanup() {
  printf '\033[?25h\033[?1049l'       # show cursor, leave alternate screen
}
# shellcheck disable=SC2329  # invoked via trap
abort() {
  kill "$PID" 2>/dev/null
  cleanup
  printf 'parb: aborted (log: %s)\n' "$LOG"
  exit 130
}
trap abort INT TERM
trap cleanup EXIT

printf '\033[?1049h\033[?25l'         # enter alternate screen, hide cursor

frame=0
while kill -0 "$PID" 2>/dev/null; do
  cols=$(tput cols 2>/dev/null || echo 80)
  rows=$(tput lines 2>/dev/null || echo 24)
  # Drop the art on terminals too small to hold it, keep what fits of the tail.
  art=$ART_LINES
  tail_n=$TAIL_LINES
  if ((rows < TOTAL)); then
    art=0
    tail_n=$((rows < TAIL_LINES ? rows : TAIL_LINES))
  fi
  buf=$'\033[H'                       # home the cursor; no scrolling
  if ((art > 0)); then
    mapfile -t snow_lines <<<"${SNOW[frame % ${#SNOW[@]}]}"
    mapfile -t tux_lines <<<"${TUX[frame / 3 % ${#TUX[@]}]}"   # Tux changes pose every 3rd tick
    for ((i = 0; i < art; i++)); do
      printf -v row '%-*s' "$SNOW_W" "${snow_lines[i]:-}"
      ((i >= TUX_TOP)) && row+="${tux_lines[i - TUX_TOP]:-}"
      row=${row:0:cols}
      buf+="${COLOR_LOGO}${row:0:SNOW_W}${COLOR_TUX}${row:SNOW_W}${RESET}"$'\033[K\n'
    done
    buf+=$'\033[K\n'
  fi
  mapfile -t tail_lines < <(tail -n "$tail_n" "$LOG" | tr -d '\r' | sed 's/\x1b\[[0-9;]*[A-Za-z]//g')
  for ((i = 0; i < tail_n; i++)); do
    l="${tail_lines[i]:-}"
    buf+="${COLOR_LOG}${l:0:cols}${RESET}"$'\033[K'
    ((i < tail_n - 1)) && buf+=$'\n'
  done
  buf+=$'\033[J'                      # clear anything left below
  printf '%s' "$buf"
  frame=$(((frame + 1) % 12))
  sleep 0.08
done

status=0
wait "$PID" || status=$?
cleanup
trap - EXIT

if ((status == 0)); then
  tail -n "$TAIL_LINES" "$LOG"
  printf '\033[32m✔ parb: system rebuilt successfully\033[0m\n'
  rm -f "$LOG"
else
  tail -n 30 "$LOG"
  printf '\033[31m✘ parb: failed (exit %d), full log: %s\033[0m\n' "$status" "$LOG"
fi
exit "$status"
