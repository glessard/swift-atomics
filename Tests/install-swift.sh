#!/bin/bash
set -e

export SWVERSION=swift-3.1.1-RELEASE
export SWBRANCH=swift-3.1.1-release
export SWURLBASE="https://swift.org/builds/${SWBRANCH}/"

if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
# install swift
	DIR="$(pwd)"
	cd ..
  wget --no-verbose ${SWURLBASE}/ubuntu1404/${SWVERSION}/${SWVERSION}-ubuntu14.04.tar.gz
	tar xzf ${SWVERSION}-ubuntu14.04.tar.gz
	echo "${PWD}/${SWVERSION}"
	export PATH="${PWD}/${SWVERSION}-ubuntu14.04/usr/bin:${PATH}"
	cd "$DIR"
fi
