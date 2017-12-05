#!/bin/bash
set -e

if [[ -n "$SWIFT_VERSION" ]]
then
  export SWIFT_TOOLS_VERSION=`echo $SWIFT_VERSION | awk -F . '{print $1"."$2}'`
  if [[ "$SWIFT_TOOLS_VERSION" == "3.2" ]]
  then
    SWIFT_PACKAGE_VERSION=`echo $SWIFT_VERSION | awk -F . -v ver=4.0 '{if(NF==2) print ver; else print ver"."$3}'`
  else
    SWIFT_PACKAGE_VERSION=$SWIFT_VERSION
  fi

  if [[ -n "$SNAPSHOT" ]]
  then
    ID="DEVELOPMENT-SNAPSHOT-${SNAPSHOT}"
    VERSION="swift-${SWIFT_PACKAGE_VERSION}-${ID}"
    BRANCH="swift-${SWIFT_PACKAGE_VERSION}-branch"
  else
    VERSION="swift-${SWIFT_PACKAGE_VERSION}-RELEASE"
    BRANCH="swift-${SWIFT_PACKAGE_VERSION}-release"
  fi
  URLBASE="https://swift.org/builds/${BRANCH}"

  if [[ "$TRAVIS_OS_NAME" == "linux" ]]
  then
    PLATFORM="ubuntu1404"
    BASENAME="${VERSION}-ubuntu14.04"

    # install swift
    cd ..
    curl -s -O ${URLBASE}/${PLATFORM}/${VERSION}/${BASENAME}.tar.gz
    tar xzf ${BASENAME}.tar.gz
    export PATH="${PWD}/${BASENAME}/usr/bin:${PATH}"
    cd "${TRAVIS_BUILD_DIR}"
  elif [[ "$TRAVIS_OS_NAME" == "osx" && -n "$SNAPSHOT" ]]
  then
    PLATFORM="xcode"
    BASENAME="${VERSION}-osx"

    # install swift
    curl -s -O ${URLBASE}/${PLATFORM}/${VERSION}/${BASENAME}.pkg
    sudo installer -pkg ${BASENAME}.pkg -target /
    export TOOLCHAINS=swift
  fi
elif [[ -z $(which swift) ]]
then
  echo "Set SWIFT_VERSION to define which version to install"
  exit 1
fi

swift --version
