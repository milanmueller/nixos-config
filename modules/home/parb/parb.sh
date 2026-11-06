# parb – pull and rebuild: git pull + nixos-rebuild switch, while Tux hammers
# away at the NixOS logo. Only the last 3 lines of build output are shown.

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
IFS= read -r -d '' F1 <<'ART' || true
  \\  \\ //            ___
 ==\\__\\/ //         |___|
   //   \\//           \\    .--.
==//     //==           \\  |o_o |
 //\\___//               \\ |:_/ |
// /\\  \\==               //   \ \
  // \\  \\               (|     | )
                         /'\_   _/`\
                         \___)=(___/
ART
IFS= read -r -d '' F2 <<'ART' || true
  \\  \\ //
 ==\\__\\/ //
   //   \\//  .   *          .--.
==//     //== ' |=|         |o_o |
 //\\___//   -  | |=========|:_/ |
// /\\  \\== ,  |=|        //   \ \
  // \\  \\     *  '      (|     | )
                         /'\_   _/`\
                         \___)=(___/
ART
FRAMES=("$F1" "$F1" "$F2" "$F2")
ART_LINES=9
TAIL_LINES=3
TOTAL=$((ART_LINES + 1 + TAIL_LINES))

COLOR_LOGO=$'\033[34m'   # blue snowflake
COLOR_LOG=$'\033[2m'     # dim build output
RESET=$'\033[0m'

# shellcheck disable=SC2329  # invoked via trap
cleanup() {
  printf '\033[?25h'                  # show cursor
}
# shellcheck disable=SC2329  # invoked via trap
abort() {
  kill "$PID" 2>/dev/null
  cleanup
  printf '\nparb: aborted (log: %s)\n' "$LOG"
  exit 130
}
trap abort INT TERM
trap cleanup EXIT

printf '\033[?25l'                    # hide cursor
for ((i = 0; i < TOTAL; i++)); do echo; done

frame=0
while kill -0 "$PID" 2>/dev/null; do
  cols=$(tput cols 2>/dev/null || echo 80)
  printf '\033[%dA' "$TOTAL"          # back to top of drawing area
  while IFS= read -r line; do
    printf '\r\033[K%s%s%s\n' "$COLOR_LOGO" "${line:0:cols}" "$RESET"
  done <<<"${FRAMES[frame]}"
  printf '\r\033[K\n'
  mapfile -t tail_lines < <(tail -n "$TAIL_LINES" "$LOG" | tr -d '\r' | sed 's/\x1b\[[0-9;]*[A-Za-z]//g')
  for ((i = 0; i < TAIL_LINES; i++)); do
    l="${tail_lines[i]:-}"
    printf '\r\033[K%s%s%s\n' "$COLOR_LOG" "${l:0:cols}" "$RESET"
  done
  frame=$(((frame + 1) % ${#FRAMES[@]}))
  sleep 0.15
done

status=0
wait "$PID" || status=$?

# Clear the animation area.
printf '\033[%dA' "$TOTAL"
for ((i = 0; i < TOTAL; i++)); do printf '\r\033[K\n'; done
printf '\033[%dA' "$TOTAL"

if ((status == 0)); then
  tail -n "$TAIL_LINES" "$LOG"
  printf '\033[32m✔ parb: system rebuilt successfully\033[0m\n'
  rm -f "$LOG"
else
  tail -n 30 "$LOG"
  printf '\033[31m✘ parb: failed (exit %d), full log: %s\033[0m\n' "$status" "$LOG"
fi
exit "$status"
