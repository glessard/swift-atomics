#!/bin/bash
set -e

COMPILER_MAJOR_VERSION=`echo ${COMPILER_VERSION} | awk -F . '{print $1}'`
TEST_OPTIONS="-c release -Xcc -mcx16"

swift --version
swift test ${TEST_OPTIONS}

if [[ "${COMPILER_MAJOR_VERSION}" = "4" ]]
then
  MINOR_VERSION=`echo ${COMPILER_VERSION} | awk -F . '{print $2}'`
  if [[ "${MINOR_VERSION}" = "2" ]]
  then
    VERSIONS="4 3"
  else
    VERSIONS="3"
  fi
elif [[ "${COMPILER_MAJOR_VERSION}" = "5" ]]
then
  VERSIONS="4.2 4"
fi

for LANGUAGE_VERSION in $VERSIONS
do
  echo "" # add a small visual separation
  echo "Testing in compatibility mode for Swift ${LANGUAGE_VERSION}"
  if [[ "${LANGUAGE_VERSION}" = "3" ]]
  then
    TEST_OPTIONS="-Xcc -mcx16"
  fi
  swift package reset
  rm -f Package.resolved
  swift test ${TEST_OPTIONS} -Xswiftc -swift-version -Xswiftc ${LANGUAGE_VERSION}
done
