#!/bin/bash
set -e

if [[ -n "$SWIFT" ]]
then
  export COMPILER_VERSION=$SWIFT

  COMPILER="swift-${COMPILER_VERSION}-RELEASE"
  BRANCH="swift-${COMPILER_VERSION}-release"
  URLBASE="https://swift.org/builds/${BRANCH}"

  if [[ "$TRAVIS_OS_NAME" == "linux" ]]
  then
    if [[ "$TRAVIS_DIST" == "bionic" ]]
    then
      PLATFORM="ubuntu1804"
      BASENAME="${COMPILER}-ubuntu18.04"
    elif [[ "$TRAVIS_DIST" == "xenial" ]]
    then
      PLATFORM="ubuntu1604"
      BASENAME="${COMPILER}-ubuntu16.04"
    else
      echo "Unknown linux distribution in use"
      exit 1
    fi

    # install swift
    cd ..
    echo "Getting ${URLBASE}/${PLATFORM}/${COMPILER}/${BASENAME}.tar.gz"
    curl -s -O ${URLBASE}/${PLATFORM}/${COMPILER}/${BASENAME}.tar.gz
    tar xzf ${BASENAME}.tar.gz
    export PATH="${PWD}/${BASENAME}/usr/bin:${PATH}"
    cd "${TRAVIS_BUILD_DIR}"
  fi
elif [[ -z $(which swift) ]]
then
  echo "Set SWIFT to define which compiler version to install"
  exit 1
fi

swift --version
