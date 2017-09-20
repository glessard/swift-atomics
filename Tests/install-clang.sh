#!/bin/bash
set -e

if [[ "$TRAVIS_OS_NAME" == "linux" ]]
then
  if [[ -z "$CLANG_VERSION" ]]
  then
    CLANG_VERSION=3.9
  fi
  # install desired clang
  apt-get update -qq
  apt-get install -qq -y clang-${CLANG_VERSION}
  update-alternatives --quiet --install /usr/bin/clang clang /usr/bin/clang-${CLANG_VERSION} 100
  update-alternatives --quiet --install /usr/bin/clang++ clang++ /usr/bin/clang++-${CLANG_VERSION} 100

  echo ""
fi

clang --version
