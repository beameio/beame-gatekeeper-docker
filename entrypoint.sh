#!/bin/sh

set -e

log() {
	echo "+ [entrypoint.sh] $*" >&2
}

if [ "$(id -u)" = 0 ]; then
	log "Ensuring correct ownership on ~beame-gatekeeper"
	chown -R beame-gatekeeper ~beame-gatekeeper
	log "Re-running as beame-gatekeeper user"
	exec sudo -E -H -u beame-gatekeeper "$0" "$@"
fi

log "Running $*"
exec "$@"
