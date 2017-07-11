#!/bin/sh

set -e

log() {
	echo "+ [entrypoint.sh] $*" >&2
}

if [ "$(id -u)" = 0 ]; then
	log "Ensuring correct ownership on ~beame-insta-ssl"
	chown -R beame-insta-ssl ~beame-insta-ssl
	log "Re-running as beame-insta-ssl user"
	exec sudo -E -H -u beame-insta-ssl "$0" "$@"
fi

log "Running $*"
exec "$@"
