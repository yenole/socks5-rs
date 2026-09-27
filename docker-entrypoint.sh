#!/bin/sh
set -eu

if [ -n "${SOCKS5_USERNAME:-}" ] && [ -n "${SOCKS5_PASSWORD:-}" ]; then
  set -- "$@" --username "$SOCKS5_USERNAME" --password "$SOCKS5_PASSWORD"
elif [ -n "${SOCKS5_USERNAME:-}" ] || [ -n "${SOCKS5_PASSWORD:-}" ]; then
  echo "SOCKS5_USERNAME and SOCKS5_PASSWORD must be set together" >&2
  exit 1
fi

exec /usr/local/bin/socks5-rs "$@"
