#!/bin/bash
set -e

if [[ -n "${SWIFT_TOOLS_VERSION}" ]]
then
  swift package tools-version --set "${SWIFT_TOOLS_VERSION}"
fi

swift test
