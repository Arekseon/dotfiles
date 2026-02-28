#!/usr/bin/env bash
# Plex Media Server block

if ! command -v docker &>/dev/null; then
    return 0
fi

PLEX_PORT=32400
plex_printed=0

PLEX_CNAME=$(docker ps --format '{{.Names}}|{{.Image}}' 2>/dev/null | awk -F'|' 'tolower($0) ~ /plex/ {print $1; exit}')

if [[ -z "$PLEX_CNAME" ]]; then
    if ss -ltnp 2>/dev/null | grep -qE ':(32400)\b'; then
        section "Plex"
        kv "Status" "running (port 32400 listening)"
        plex_printed=1
    fi
    return 0
fi

section "Plex"
kv "Status" "running (docker: $PLEX_CNAME)"

PLEX_IMAGE=$(docker ps --format '{{.Names}}|{{.Image}}' 2>/dev/null | awk -F'|' -v n="$PLEX_CNAME" '$1==n {print $2}')
[[ -n "$PLEX_IMAGE" ]] && kv "Image" "$PLEX_IMAGE"

PLEX_PORTS=$(docker port "$PLEX_CNAME" 32400/tcp 2>/dev/null | xargs)
if [[ -n "$PLEX_PORTS" ]]; then
    kv "Ports" "$PLEX_PORTS"
else
    ss -ltn 2>/dev/null | grep -q ':\<32400\>' && kv "Ports" "32400/tcp (listening)"
fi

PLEX_ENV=$(docker inspect -f '{{range .Config.Env}}{{println .}}{{end}}' "$PLEX_CNAME" 2>/dev/null)
PLEX_VERSION=$(printf "%s\n" "$PLEX_ENV" | awk -F= '$1=="VERSION" {print $2; exit}')
[[ -n "$PLEX_VERSION" ]] && kv "Version" "$PLEX_VERSION"

PLEX_TZ=$(printf "%s\n" "$PLEX_ENV" | awk -F= '$1=="TZ" {print $2; exit}')
[[ -n "$PLEX_TZ" ]] && kv "TZ" "$PLEX_TZ"

PLEX_PUID=$(printf "%s\n" "$PLEX_ENV" | awk -F= '$1=="PUID" {print $2; exit}')
PLEX_PGID=$(printf "%s\n" "$PLEX_ENV" | awk -F= '$1=="PGID" {print $2; exit}')
[[ -n "$PLEX_PUID" || -n "$PLEX_PGID" ]] && kv "User" "${PLEX_PUID:-?}:${PLEX_PGID:-?}"

PLEX_CONFIG=$(docker inspect -f '{{range .Mounts}}{{println .Destination " <- " .Source}}{{end}}' "$PLEX_CNAME" 2>/dev/null | awk 'tolower($0) ~ /config/ {print; exit}')
[[ -n "$PLEX_CONFIG" ]] && kv "Config" "$PLEX_CONFIG"

kv "Port" "$PLEX_PORT"
IPS=$(hostname -I 2>/dev/null | xargs)
if [[ -n "$IPS" ]]; then
    kv "Web" "http://${IPS%% *}:${PLEX_PORT}/web"
fi
