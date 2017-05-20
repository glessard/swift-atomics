#!/bin/bash
set -e

if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
  if [[ -n "$CLANG_VERSION" ]]; then
  # remove outdated clang
    /bin/rm -rf /usr/local/clang-3.5.0
    /bin/rm -f  /usr/local/clang

  # install desired clang
    apt-get update -qq
    apt-get install -qq -y clang-${CLANG_VERSION}
    update-alternatives --quiet --install /usr/bin/clang clang /usr/bin/clang-${CLANG_VERSION} 100
    update-alternatives --quiet --install /usr/bin/clang++ clang++ /usr/bin/clang++-${CLANG_VERSION} 100

    echo ""
  fi
fi

clang --version
