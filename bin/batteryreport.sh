#!/usr/bin/env bash
#
# MAC ONLY
#
# batteryreport.sh - report device battery levels with custom names + emoji.
#
#   ./batteryreport.sh                normal run: power source + "<emoji> <pct%> <name>"
#   ./batteryreport.sh -s|--status    one line, for a tmux/shell status bar
#   ./batteryreport.sh -c|--config    build/refresh the name -> emoji/displayname map
#   ./batteryreport.sh -h|--help      help
#
# Data source is `pmset -g accps`.
# Expected device line format:  -name (id=####)<tab/space>###%; extra info
# First line ("Now drawing from '...'") reports how the Mac is powered.
#
# Config is keyed on the device NAME, not the id: Bluetooth ids drift on every
# reconnect/re-pair, so the reported name is the only stable identifier.
# Config line format:  reported-name|emoji|display-name
# Config located at ~/.batterydevices.conf
#
#
# TMUX add to .tmux.conf and re-source it
#
# # battery levels (macOS only): emoji + % to the left of the clock
# set-option -g status-interval 30
# if-shell 'uname | grep -q Darwin' \
#   'set-option -g status-right "#(~/bin/batteryreport.sh --status)  %a %m/%d/%Y %I:%M%p" ; \
#   set-option -g status-right-length 120'
#
# Command from https://apple.stackexchange.com/questions/215256/check-the-battery-level-of-connected-bluetooth-headphones-from-the-command-line
# Hidden option visible with pmset -g everything
# ---------------------------------------------------------------------------

set -euo pipefail

SOURCE_CMD="pmset -g accps"

CONFIG="$HOME/.batterydevices.conf"

# Basic, widely-supported emoji offered as quick picks during setup.
EMOJI_CHOICES=( "🎧" "🖱️" "⌨️" "🔊" "🎮" "⌚" "📱" "🔋" "🔌" )
EMOJI_LABELS=( "headphones" "mouse" "keyboard" "speaker" "controller" "watch" "phone" "battery" "plug" )

usage() {
    cat <<EOF
MAC ONLY

Usage: ${0##*/} [-s|--status] [-c|--config] [-h|--help]

  (no flags)     Print the power source, then "<emoji> <pct%> <displayname>"
                 for each device, one per line.
  -s, --status   Print all devices on a single line (for a status bar).
  -c, --config   Map device names to display names (default = reported name)
                 and an emoji. Re-running keeps prior choices as defaults.
  -h, --help     Show this help.

Config file: $CONFIG
EOF
}

raw_output() { eval "$SOURCE_CMD"; }

# Power-source string from a block of raw output on stdin, e.g. "AC Power".
power_source_from() { sed -n "s/^Now drawing from '\(.*\)'.*/\1/p" | head -n1; }

# Print a friendly power-source line, e.g. "🔌 AC Power" / "🔋 Battery Power".
power_source_line() {
    local src="$1"
    [[ -n "$src" ]] || return 0
    case "$src" in
        *AC*)      printf '🔌 %s\n' "$src" ;;
        *Battery*) printf '🔋 %s\n' "$src" ;;
        *)         printf '⚡ %s\n' "$src" ;;
    esac
}

# Read raw output on stdin; emit "name<TAB>pct" for each device line.
parse_lines() {
    while IFS= read -r line; do
        if [[ "$line" =~ ^[[:space:]]*-(.*)\ \(id=[0-9]+\)[[:space:]]+([0-9]+)% ]]; then
            printf '%s\t%s\n' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
        fi
    done
}

# prompt_emoji <default>  -> echoes chosen emoji (number, typed glyph, or default)
prompt_emoji() {
    local def="$1" i reply
    # Menu goes to stderr so it shows even though we're called via $(...).
    echo "  Emoji options:" >&2
    for i in "${!EMOJI_CHOICES[@]}"; do
        printf '    %d) %s %s\n' "$((i + 1))" "${EMOJI_CHOICES[$i]}" "${EMOJI_LABELS[$i]}" >&2
    done
    if [[ -n "$def" ]]; then
        read -r -p "  Pick a number, type your own, or Enter for [$def]: " reply </dev/tty || reply=""
    else
        read -r -p "  Pick a number, type your own, or Enter for none: " reply </dev/tty || reply=""
    fi
    if [[ -z "$reply" ]]; then
        printf '%s' "$def"
    elif [[ "$reply" =~ ^[0-9]+$ ]] && (( reply >= 1 && reply <= ${#EMOJI_CHOICES[@]} )); then
        printf '%s' "${EMOJI_CHOICES[$((reply - 1))]}"
    else
        printf '%s' "$reply"
    fi
}

# lookup_field <name> <field-number>  -> value from config (2=emoji, 3=display)
# Exact match on the name field, so spaces/punctuation in names are safe.
lookup_field() {
    [[ -f "$CONFIG" ]] || return 1
    local key="$1" fnum="$2" k e n
    while IFS='|' read -r k e n; do
        [[ "$k" == "$key" ]] || continue
        case "$fnum" in 2) printf '%s' "$e" ;; 3) printf '%s' "$n" ;; esac
        return 0
    done < "$CONFIG"
    return 1
}

# Copy <file> to stdout, dropping any line whose name field equals <name>.
filter_out_name() {
    local key="$1" file="$2" line
    while IFS= read -r line; do
        [[ "${line%%|*}" == "$key" ]] || printf '%s\n' "$line"
    done < "$file"
}

# format_device <name> <pct> <power-source> [compact]
#   default:        "<emoji> <pct>% <display>"
#   compact (4th):  "<emoji> <pct>%"   (icon + percent only, for status bar)
format_device() {
    local name="$1" pct="$2" src="$3" compact="${4:-}" emoji display
    emoji="$(lookup_field "$name" 2 || true)"
    display="$(lookup_field "$name" 3 || true)"
    [[ -n "$display" ]] || display="$name"
    # Any InternalBattery-N: emoji reflects live power state, not the config.
    if [[ "$name" == *InternalBattery* ]]; then
        if [[ "$src" == *AC* ]]; then emoji='🔌'; else emoji='🔋'; fi
    fi
    if [[ -n "$compact" ]]; then
        if [[ -n "$emoji" ]]; then printf '%s %s%%' "$emoji" "$pct"
        else printf '%s%%' "$pct"; fi
    else
        if [[ -n "$emoji" ]]; then printf '%s %s%% %s' "$emoji" "$pct" "$display"
        else printf '%s%% %s' "$pct" "$display"; fi
    fi
}

do_setup() {
    local tmp; tmp="$(mktemp)"
    local out; out="$(raw_output)"

    # Seed with the existing config so devices that aren't connected right now
    # are preserved. Each prompted device updates its own line in place.
    [[ -f "$CONFIG" ]] && cat "$CONFIG" >"$tmp"

    local found=0
    while IFS=$'\t' read -r name pct; do
        found=1

        local def_name def_emoji
        def_name="$(lookup_field "$name" 3 || true)"; [[ -n "$def_name" ]] || def_name="$name"
        def_emoji="$(lookup_field "$name" 2 || true)"

        printf '\nDevice: %s  (currently %s%%)\n' "$name" "$pct"

        local in_name in_emoji
        read -r -p "  Display name [$def_name]: " in_name </dev/tty || in_name=""
        [[ -n "$in_name" ]] || in_name="$def_name"

        if [[ "$name" == *InternalBattery* ]]; then
            in_emoji=""
            echo "  Emoji: auto (🔌 on AC / 🔋 on battery)"
        else
            in_emoji="$(prompt_emoji "$def_emoji")"
        fi

        # Replace this name's existing line (if any), then append the new one.
        local tmp2; tmp2="$(mktemp)"
        filter_out_name "$name" "$tmp" >"$tmp2"
        printf '%s|%s|%s\n' "$name" "$in_emoji" "$in_name" >>"$tmp2"
        mv "$tmp2" "$tmp"
    done < <(printf '%s\n' "$out" | parse_lines)

    if [[ "$found" -eq 0 ]]; then
        echo "No devices parsed from '$SOURCE_CMD'. Nothing connected? Existing config left untouched." >&2
        rm -f "$tmp"; exit 0
    fi

    mv "$tmp" "$CONFIG"
    printf '\nSaved. %s device(s) now in %s\n' "$(wc -l <"$CONFIG" | tr -d ' ')" "$CONFIG"
}

do_report() {
    if [[ ! -f "$CONFIG" ]]; then
        echo "No config found. Run '${0##*/} --config' first." >&2
        exit 1
    fi
    local out; out="$(raw_output)"
    local src; src="$(printf '%s\n' "$out" | power_source_from)"
    power_source_line "$src"
    while IFS=$'\t' read -r name pct; do
        format_device "$name" "$pct" "$src"; printf '\n'
    done < <(printf '%s\n' "$out" | parse_lines)
}

# Single line for a status bar. Silent (empty) if not set up yet.
do_status() {
    [[ -f "$CONFIG" ]] || exit 0
    local out; out="$(raw_output)"
    local src; src="$(printf '%s\n' "$out" | power_source_from)"
    local sep="${BATT_SEP:-  }" line="" piece
    while IFS=$'\t' read -r name pct; do
        piece="$(format_device "$name" "$pct" "$src" compact)"
        if [[ -z "$line" ]]; then line="$piece"; else line="$line$sep$piece"; fi
    done < <(printf '%s\n' "$out" | parse_lines)
    printf '%s\n' "$line"
}

case "${1:-}" in
    -s|--status) do_status ;;
    -c|--config) do_setup ;;
    -h|--help)   usage ;;
    "")          do_report ;;
    *)           echo "Unknown option: $1" >&2; usage; exit 1 ;;
esac
