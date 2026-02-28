#!/usr/bin/env bash
# Tailscale status block

if ! command -v tailscale &>/dev/null; then
    return 0
fi

TAILSCALE_STATUS=$(tailscale status --json 2>/dev/null | grep -o '"BackendState":"[^"]*"' | cut -d'"' -f4)

if [[ -z "$TAILSCALE_STATUS" ]]; then
    return 0
fi

section "Tailscale"
kv "Status" "$TAILSCALE_STATUS"

TAILSCALE_IP=$(tailscale ip -4 2>/dev/null)
[[ -n "$TAILSCALE_IP" ]] && kv "IP" "$TAILSCALE_IP"

TAILSCALE_HOSTNAME=$(tailscale status --json 2>/dev/null | grep -o '"HostName":"[^"]*"' | head -1 | cut -d'"' -f4)
[[ -n "$TAILSCALE_HOSTNAME" ]] && kv "Hostname" "$TAILSCALE_HOSTNAME"
