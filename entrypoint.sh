#!/bin/sh

set -eu
_USER=$USER_IN_DOCKER
_HOME=$(getent passwd "$_USER" | cut -f6 -d:)

log() {
	echo "+ [entrypoint.sh] $*" >&2
}

if [ "$(id -u)" = 0 ]; then
	log "Ensuring correct ownership on ${_HOME}"
	chown -R "${_USER}" "${_HOME}"
	log "Re-running as ${_USER} user"
	exec sudo -E -H -u "${_USER}" "$0" "$@"
fi

sed 's/^/+ [entrypoint.sh] issue: /' /etc/entrypoint.issue >&2

log "Running $*"
exec "$@"
