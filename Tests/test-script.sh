#!/bin/bash
set -e

if [[ "${TRAVIS_OS_NAME}" == "osx" && -n "${SWIFT_VERSION}" ]]
then
  swift package tools-version --set "${SWIFT_VERSION}"
fi

VERSION=`swift Tests/swiftpm-version`
if [ $VERSION == "4" ]
then
  FILTER="--filter"
else
# We have Swift 3
  FILTER="--specifier"
fi

swift test $FILTER ClangAtomicsTests.ClangAtomicsTests
swift test $FILTER ClangAtomicsTests.MemoryOrderTests
swift test $FILTER AtomicsTests.AtomicsTests
swift test $FILTER AtomicsTests.AtomicsRaceTests
