#!/bin/bash
set -e

if [[ "${TRAVIS_OS_NAME}" == "osx" && -n "${SWIFT_VERSION}" ]]
then
  swift package tools-version --set "${SWIFT_VERSION}"
fi

swift test
