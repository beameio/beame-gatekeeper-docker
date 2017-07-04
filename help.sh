#!/bin/bash

set -e

myecho() {
	echo "+ [help.sh] $*" >&2
}

v=$(jq -r .version "${NPM_CONFIG_PREFIX}/lib/node_modules/beame-gatekeeper/package.json")
myecho "Beame-Gatekeeper version: $v"

myecho "=== Beame-Gatekeeper container help - start ==="
myecho ""
myecho "/YOUR/CREDS/DIR - full path to directory where credentials will be kept"
myecho ""
pfx="docker run --rm -it -v /YOUR/CREDS/DIR:/home/beame-gatekeeper beame/gatekeeper beame-gatekeeper"

beame-gatekeeper | sed -e "s#^\(\s*\)beame-gatekeeper#\1$pfx#"
myecho "=== Beame-Gatekeeper container help - end ==="
