#!/usr/bin/env bash
# Generic Docker block

if ! command -v docker &>/dev/null; then
    return 0
fi

RUNNING=$(docker ps --format '{{.Names}}' 2>/dev/null | wc -l | tr -d ' ')
if [[ "$RUNNING" -eq 0 ]]; then
    return 0
fi

section "Docker"
docker ps --format '  {{.Names}}: {{.Status}}' 2>/dev/null | head -10
