#!/bin/bash
set -e

if [[ -n "$SWIFT_VERSION" ]]
then
  if [[ -n "$SNAPSHOT" ]]
  then
    ID="DEVELOPMENT-SNAPSHOT-${SNAPSHOT}"
    VERSION="swift-${SWIFT_VERSION}-${ID}"
    BRANCH="swift-${SWIFT_VERSION}-branch"
  else
    VERSION="swift-${SWIFT_VERSION}-RELEASE"
    BRANCH="swift-${SWIFT_VERSION}-release"
  fi
  URLBASE="https://swift.org/builds/${BRANCH}"

  if [[ "$TRAVIS_OS_NAME" == "linux" ]]
  then
    PLATFORM="ubuntu1404"
    BASENAME="${VERSION}-ubuntu14.04"

    # install swift
    cd ..
    wget --no-verbose ${URLBASE}/${PLATFORM}/${VERSION}/${BASENAME}.tar.gz
    tar xzf ${BASENAME}.tar.gz
    export PATH="${PWD}/${BASENAME}/usr/bin:${PATH}"
    cd "${TRAVIS_BUILD_DIR}"

    echo ""
  elif [[ "$TRAVIS_OS_NAME" == "osx" && -n "$SNAPSHOT" ]]
  then
    PLATFORM="xcode"
    BASENAME="${VERSION}-osx"

    # install swift
    curl -s -O ${URLBASE}/${PLATFORM}/${VERSION}/${BASENAME}.pkg
    sudo installer -pkg ${BASENAME}.pkg -target /
    export TOOLCHAINS=swift
  fi
else
  if [[ -z $(which swift) ]]
  then
    echo "Set SWIFT_VERSION to define which version to install"
    exit 1
  fi
fi

swift --version
