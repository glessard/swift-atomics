#!/bin/bash
set -e

if [[ -n "${SWIFT_TOOLS_VERSION}" ]]
then
  echo "Setting Swift tools version to ${SWIFT_TOOLS_VERSION}"
  swift package tools-version --set "${SWIFT_TOOLS_VERSION}"
fi

swift --version
swift test -Xcc -mcx16
