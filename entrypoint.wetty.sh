#!/bin/sh

set -e

log() {
	echo "+ [entrypoint.sh] $*" >&2
}

if [ "$(id -u)" = 0 ]; then
	log "Ensuring correct ownership on ~wetty"
	chown -R wetty ~wetty
	log "Re-running as wetty user"
	exec sudo -E -H -u wetty "$0" "$@"
fi

log "Running $*"
exec "$@"

