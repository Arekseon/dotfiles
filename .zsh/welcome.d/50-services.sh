#!/usr/bin/env bash
# Systemd services block (custom services only)

if ! command -v systemctl &>/dev/null; then
    return 0
fi

# Add your custom services here
CUSTOM_SERVICES=(
    "docker"
    "plex"
)

section "Services"
for svc in "${CUSTOM_SERVICES[@]}"; do
    if systemctl is-active --quiet "$svc" 2>/dev/null; then
        kv "$svc" "active"
    elif systemctl is-enabled --quiet "$svc" 2>/dev/null; then
        kv "$svc" "enabled (inactive)"
    fi
done
