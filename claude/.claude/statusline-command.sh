#!/bin/bash
# Claude Code status line, modeled on https://github.com/xleddyl/claude-watch
# with Catppuccin Mocha colors. One line:
#   model (effort) | dir • branch | ctx N% (used/total)

input=$(cat)

# One jq call; fields joined with \x1f so empty values survive `read`
IFS=$'\x1f' read -r model effort dir ctx_pct ctx_used ctx_total < <(echo "$input" | jq -r '[
    .model.display_name // "",
    .effort.level // "",
    .workspace.current_dir // .cwd // "",
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

branch=""
if [ -n "$dir" ] && git -C "$dir" --no-optional-locks rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$dir" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null ||
    git -C "$dir" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
fi

printf "${BOLD}${PEACH}%s${RESET}" "$model"
[ -n "$effort" ] && printf " ${PEACH}(%s)${RESET}" "$effort"
printf "${BAR}${BOLD}${LAVENDER}%s${RESET}" "$(basename "$dir")"
[ -n "$branch" ] && printf "${DOT}${BOLD}${MAUVE}%s${RESET}" "$branch"

if [ -n "$ctx_pct" ]; then
  n=$(printf '%.0f' "$ctx_pct")
  printf "${BAR}${SUBTEXT}ctx $(pct_color "$n")%s%%${RESET}" "$n"
  if [ -n "$ctx_used" ] && [ -n "$ctx_total" ]; then
    printf " ${DIM}${SUBTEXT}(%sk/%sk)${RESET}" $(( ctx_used / 1000 )) $(( ctx_total / 1000 ))
  fi
fi
exit 0
