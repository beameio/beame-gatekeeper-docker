#!/bin/bash -eu

: ${NODEJS_VER:=6.11.0}
: ${NODEJS_SHA256:=2b0e1b06bf8658ce02c16239eb6a74b55ad92d4fb7888608af1d52b383642c3c}

NODEJS_URL="https://nodejs.org/dist/v${NODEJS_VER}/node-v${NODEJS_VER}-linux-x64.tar.gz"

curl "$NODEJS_URL" >/tmp/node.tar.gz

sha256sum -c <<E
$NODEJS_SHA256  /tmp/node.tar.gz
E

cd /opt
tar xzf /tmp/node.tar.gz
rm /tmp/node.tar.gz

ln -sf node-v${NODEJS_VER}-linux-x64 nodejs
ln -sf /opt/nodejs/bin/node /usr/bin/node
ln -sf /opt/nodejs/bin/node /usr/bin/nodejs
ln -sf /opt/nodejs/bin/npm /usr/bin/npm
