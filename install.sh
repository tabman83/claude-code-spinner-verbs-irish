#!/usr/bin/env bash
#
# install.sh — Install Dublin spinner verbs into Claude Code.
# macOS / Linux. Requires: bash, curl, jq.
#
set -euo pipefail

# --- config ---
REPO_RAW_URL="https://raw.githubusercontent.com/tabman83/spinner-verbs-dublin/main/spinner-verbs.json"
SETTINGS_DIR="${HOME}/.claude"
SETTINGS_FILE="${SETTINGS_DIR}/settings.json"

# --- pretty output ---
say()  { printf "\033[1;32m==>\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m==>\033[0m %s\n" "$*"; }
err()  { printf "\033[1;31m==>\033[0m %s\n" "$*" >&2; }

# --- prerequisites ---
for cmd in curl jq; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    err "'$cmd' is required but not installed."
    case "$cmd" in
      jq)
        err "  macOS:  brew install jq"
        err "  Debian: sudo apt-get install jq"
        ;;
    esac
    exit 1
  fi
done

# --- fetch the verbs ---
say "Fetchin' the latest verbs from GitHub..."
TMP_VERBS="$(mktemp)"
trap 'rm -f "$TMP_VERBS"' EXIT

if ! curl -fsSL "$REPO_RAW_URL" -o "$TMP_VERBS"; then
  err "Couldn't fetch the verbs file. Check your internet, or the URL:"
  err "  $REPO_RAW_URL"
  exit 1
fi

if ! jq empty "$TMP_VERBS" 2>/dev/null; then
  err "Downloaded file isn't valid JSON. Aborting before we banjax anything."
  exit 1
fi

# --- ensure settings dir exists ---
mkdir -p "$SETTINGS_DIR"

# --- decide what to do with existing settings ---
ACTION="install"
if [[ -f "$SETTINGS_FILE" ]]; then
  warn "Found existing settings at: $SETTINGS_FILE"
  echo
  echo "  [m] Merge   — keep your other settings, replace only spinnerVerbs"
  echo "  [o] Overwrite — replace the whole file with just the spinner verbs"
  echo "  [c] Cancel"
  echo
  read -rp "What'll it be? [m/o/c]: " CHOICE
  case "${CHOICE,,}" in
    m) ACTION="merge" ;;
    o) ACTION="overwrite" ;;
    c|*) say "Right so, nothin' done. Off ye go."; exit 0 ;;
  esac
fi

# --- back up if a file exists ---
if [[ -f "$SETTINGS_FILE" ]]; then
  BACKUP="${SETTINGS_FILE}.bak.$(date +%Y%m%d-%H%M%S)"
  cp "$SETTINGS_FILE" "$BACKUP"
  say "Backed up existing settings to: $BACKUP"
fi

# --- write the new file ---
case "$ACTION" in
  install|overwrite)
    cp "$TMP_VERBS" "$SETTINGS_FILE"
    ;;
  merge)
    MERGED="$(mktemp)"
    jq -s '.[0] * .[1]' "$SETTINGS_FILE" "$TMP_VERBS" > "$MERGED"
    if ! jq empty "$MERGED" 2>/dev/null; then
      err "Merge produced invalid JSON. Your original settings are untouched."
      rm -f "$MERGED"
      exit 1
    fi
    mv "$MERGED" "$SETTINGS_FILE"
    ;;
esac

say "Sorted. Restart Claude Code to see the new spinner."
say "If you change your mind, your old settings are in the .bak file."
