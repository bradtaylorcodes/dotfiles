#!/bin/bash
# Claude Code status line, modeled on https://github.com/xleddyl/claude-watch
# with Catppuccin Mocha colors. Two lines:
#   [⬢ container |] model (effort) | dir • branch
#   5h N% (resets in) • 7d N% (resets in) | ctx N% (used/total)
# Usage limits come from the rate_limits field Claude Code pipes in (Pro/Max
# only, after the first response), so no token or API calls are needed.

input=$(cat)

# One jq call; fields joined with \x1f so empty values survive `read`
IFS=$'\x1f' read -r model effort dir five_h five_h_reset seven_d seven_d_reset \
  ctx_pct ctx_used ctx_total < <(echo "$input" | jq -r '[
    .model.display_name // "",
    .effort.level // "",
    .workspace.current_dir // .cwd // "",
    .rate_limits.five_hour.used_percentage // "",
    .rate_limits.five_hour.resets_at // "",
    .rate_limits.seven_day.used_percentage // "",
    .rate_limits.seven_day.resets_at // "",
    .context_window.used_percentage // "",
    .context_window.total_input_tokens // "",
    .context_window.context_window_size // ""
  ] | map(tostring) | join("\u001f")')

rgb() { printf '\033[38;2;%sm' "$1"; }
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'
PEACH=$(rgb '250;179;135')
LAVENDER=$(rgb '180;190;254')
MAUVE=$(rgb '203;166;247')
BLUE=$(rgb '137;180;250')
SUBTEXT=$(rgb '166;173;200')
OVERLAY=$(rgb '108;112;134')
GREEN=$(rgb '166;227;161')
YELLOW=$(rgb '249;226;175')
RED=$(rgb '243;139;168')

BAR="${OVERLAY} | ${RESET}"
DOT="${OVERLAY} • ${RESET}"

# Green under 50%, yellow under 80%, red from 80%
pct_color() {
  if [ "$1" -ge 80 ]; then printf '%s' "$RED"
  elif [ "$1" -ge 50 ]; then printf '%s' "$YELLOW"
  else printf '%s' "$GREEN"
  fi
}

# Epoch seconds -> time left, e.g. "2d 4h", "3h 12m", "45m"
time_until() {
  local diff=$(( ${1%.*} - $(date +%s) ))
  if [ "$diff" -le 0 ]; then echo "now"; return; fi
  local d=$(( diff / 86400 )) h=$(( diff % 86400 / 3600 )) m=$(( diff % 3600 / 60 ))
  if [ "$d" -gt 0 ]; then echo "${d}d ${h}h"
  elif [ "$h" -gt 0 ]; then echo "${h}h ${m}m"
  else echo "${m}m"
  fi
}

# "<label> N% (resets in)" for one rate limit window
limit() {
  local label=$1 pct=$2 reset=$3 n
  n=$(printf '%.0f' "$pct")
  printf "${SUBTEXT}%s $(pct_color "$n")%s%%${RESET}" "$label" "$n"
  [ -n "$reset" ] && printf " ${DIM}${SUBTEXT}(%s)${RESET}" "$(time_until "$reset")"
}

branch=""
if [ -n "$dir" ] && git -C "$dir" --no-optional-locks rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$dir" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null ||
    git -C "$dir" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
fi

# --- line 1: model | folder • branch ---
if [ -f /.dockerenv ] || [ -n "$REMOTE_CONTAINERS" ]; then
  printf "${BOLD}${BLUE}⬢ container${RESET}${BAR}"
fi
printf "${BOLD}${PEACH}%s${RESET}" "$model"
[ -n "$effort" ] && printf " ${PEACH}(%s)${RESET}" "$effort"
printf "${BAR}${BOLD}${LAVENDER}%s${RESET}" "$(basename "$dir")"
[ -n "$branch" ] && printf "${DOT}${BOLD}${MAUVE}%s${RESET}" "$branch"

# --- line 2: usage limits | context window ---
line2=""
[ -n "$five_h" ] && line2+=$(limit 5h "$five_h" "$five_h_reset")
if [ -n "$seven_d" ]; then
  [ -n "$line2" ] && line2+=$DOT
  line2+=$(limit 7d "$seven_d" "$seven_d_reset")
fi
if [ -n "$ctx_pct" ]; then
  [ -n "$line2" ] && line2+=$BAR
  n=$(printf '%.0f' "$ctx_pct")
  line2+=$(printf "${SUBTEXT}ctx $(pct_color "$n")%s%%${RESET}" "$n")
  if [ -n "$ctx_used" ] && [ -n "$ctx_total" ]; then
    line2+=$(printf " ${DIM}${SUBTEXT}(%sk/%sk)${RESET}" $(( ctx_used / 1000 )) $(( ctx_total / 1000 )))
  fi
fi
[ -n "$line2" ] && printf '\n%b' "$line2"
exit 0
