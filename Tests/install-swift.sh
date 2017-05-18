#!/bin/bash
set -e

if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
  if [[ -n "$SWIFT_VERSION" ]]; then
    VERSION=swift-${SWIFT_VERSION}-RELEASE
    BRANCH=swift-${SWIFT_VERSION}-release
    URLBASE="https://swift.org/builds/${BRANCH}/"
    PLATFORM="ubuntu1404"
    BASENAME="${VERSION}-ubuntu14.04"

    # install swift
    cd ..
    wget --no-verbose ${URLBASE}/${PLATFORM}/${VERSION}/${BASENAME}.tar.gz
    tar xzf ${BASENAME}.tar.gz
    export PATH="${PWD}/${BASENAME}/usr/bin:${PATH}"
    cd "${TRAVIS_BUILD_DIR}"

    echo ""
  fi
fi

swift --version
