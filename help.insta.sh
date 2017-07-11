#!/bin/sh

set -e

myecho() {
	echo "+ [help.sh] $*" >&2
}

v=$(jq -r .version "${NPM_CONFIG_PREFIX}/lib/node_modules/beame-insta-ssl/package.json")
myecho "beame-insta-ssl version: $v"

myecho "=== beame-insta-ssl container help - start ==="
myecho ""
myecho "/YOUR/CREDS/DIR - full path to directory where credentials will be kept"
myecho ""
pfx="docker run --rm -it -v /YOUR/CREDS/DIR:/home/beame-insta-ssl beame/insta-ssl beame-insta-ssl"

beame-insta-ssl | sed -e "s#^\(\s*\)beame-insta-ssl#\1$pfx#"
myecho "=== beame-insta-ssl container help - end ==="
