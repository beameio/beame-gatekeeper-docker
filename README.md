# Running Beame-Gatekeeper in docker

## Raspberry Pi

	docker run --name wetty -p 3000:3000 --rm -it beame/wetty-armhf wetty -p 3000 --sshhost 172.17.42.1
	docker run --name gatekeeper --link wetty --rm -it -v /tmp/d1:/home/beame-gatekeeper beame/gatekeeper-armhf beame-gatekeeper creds getCreds --regToken TOKEN_FROM_EMAIL
	docker run --name gatekeeper --link wetty --rm -it -v /tmp/d1:/home/beame-gatekeeper beame/gatekeeper-armhf beame-gatekeeper server start

## Linux/MacOS

	docker run --name wetty -p 3000:3000 --rm -it beame/wetty wetty -p 3000 --sshhost 172.17.42.1
	docker run --name gatekeeper --link wetty --rm -it -v /tmp/d1:/home/beame-gatekeeper beame/gatekeeper beame-gatekeeper creds getCreds --regToken TOKEN_FROM_EMAIL
	docker run --name gatekeeper --link wetty --rm -it -v /tmp/d1:/home/beame-gatekeeper beame/gatekeeper beame-gatekeeper server start

## Configure Wetty

In Admin web console go to "Services". Push "Add a new record" button above services list. Add record with the following fields:

* CODE - WETTY
* NAME - Wetty
* URL - http://wetty:3000

Click save button at the end of the row.

![Sceenshot of configured Wetty service](images/wetty-service-configuration.png?raw=true "Configured Wetty service")

# Beame team internal building instructions

Till automated we are using following instructions to build the docker images. Run on Debian Stretch. Typically that will be the VM with `role=docker-builder`.

	# Cleaning all images might be needed:
	docker rm $(docker ps -a -q)
	docker rmi $(docker images -q)

	# Docker for arm (Raspberry)
	apt-get install -y multistrap qemu-user-static

	cat >configscript.sh <<E
	#!/bin/sh

	set -e

	export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
	export LC_ALL=C LANGUAGE=C LANG=C
	/var/lib/dpkg/info/dash.preinst install
	dpkg --configure -a
	mount proc -t proc /proc
	dpkg --configure -a
	umount /proc
	E
	chmod +x configscript.sh

	cat >stretch-arm.conf <<E
	[General]
	arch=armhf
	directory=stretch-arm
	# same as --tidy-up option if set to true
	cleanup=true
	# same as --no-auth option if set to true
	# keyring packages listed in each bootstrap will
	# still be installed.
	noauth=false
	# whether to add the /suite to be explicit about where apt
	# needs to look for packages. Default is false.
	explicitsuite=false
	# extract all downloaded archives (default is true)
	unpack=true
	# the order of sections is not important.
	# the bootstrap option determines which repository
	# is used to calculate the list of Priority: required packages.
	bootstrap=Debian
	aptsources=Debian
	configscript=configscript.sh

	[Debian]
	packages=apt
	source=http://http.debian.net/debian
	keyring=debian-archive-keyring
	suite=stretch
	E

	multistrap -f stretch-arm.conf
	cp -a /usr/bin/qemu-arm-static stretch-arm/usr/bin/
	chroot stretch-arm ./configscript.sh

	tar -C stretch-arm -c . | docker import - stretch-arm

	# Docker - nodejs 6

	docker build -f Dockerfile.node6 -t node6 .

	# Docker - nodejs 6 arm
	sed 's/debian:stretch/stretch-arm/' <Dockerfile.node6 >Dockerfile.node6.arm
	docker build -f Dockerfile.node6.arm -t node6-arm .

	# Docker - beame stuff prep

	git clone https://github.com/beameio/beame-gatekeeper-docker.git
	cd beame-gatekeeper-docker

	# Docker wetty

	TAG=beame/wetty
	docker build -f Dockerfile.wetty -t "$TAG" .

	docker run --name wetty -p 3000:3000 --rm -it "$TAG" wetty -p 3000 --sshhost 172.17.42.1
	docker push "$TAG"

	# Docker wetty - arm

	sed 's/^FROM node6/FROM node6-arm/' <Dockerfile.wetty >Dockerfile.wetty.arm

	TAG=beame/wetty-armhf
	docker build -f Dockerfile.wetty.arm wetty -t "$TAG" .

	docker run --name wetty -p 3000:3000 --rm -it "$TAG" wetty -p 3000 --sshhost 172.17.42.1
	docker push "$TAG"

	# Docker gatekeeper

	TAG=beame/gatekeeper

	docker build -t "$TAG" .

	docker run --name gatekeeper --link wetty --rm -it -v /tmp/d1:/home/beame-gatekeeper "$TAG" beame-gatekeeper server start
	docker push "$TAG"

	# Docker gatekeeper - arm

	sed 's/^FROM node6/FROM node6-arm/' <Dockerfile >Dockerfile.arm

	TAG=beame/gatekeeper-armhf
	docker build -f Dockerfile.arm -t "$TAG" .

	docker run --name gatekeeper --link wetty --rm -it -v /tmp/d1:/home/beame-gatekeeper "$TAG" beame-gatekeeper server start
	docker push "$TAG"

	# Docker insta-ssl

	TAG=beame/instassl

	docker build -f Dockerfile.insta -t "$TAG" .

	docker run --name instassl --rm -it -v /tmp/d1:/home/beame-insta-ssl "$TAG" beame-insta-ssl
	docker push "$TAG"

	# Docker insta-ssl - arm

	sed 's/^FROM node6/FROM node6-arm/' <Dockerfile.insta >Dockerfile.insta.arm

	TAG=beame/insta-ssl-armhf
	docker build -f Dockerfile.insta.arm -t "$TAG" .

	docker run --name instassl --rm -it -v /tmp/d1:/home/beame-insta-ssl "$TAG" beame-insta-ssl server start
	docker push "$TAG"
