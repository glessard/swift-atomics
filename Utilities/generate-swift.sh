#!/bin/sh

set -e

if [[ -z ${PROJECT_DIR} ]]
then
  SOURCES="${PWD}/Sources"
  TESTS="${PWD}/Tests"
  UTILITIES="${PWD}/Utilities"
else
  SOURCES="${PROJECT_DIR}/../Sources"
  TESTS="${PROJECT_DIR}/../Tests"
  UTILITIES="${PROJECT_DIR}/../Utilities"
fi

if [[ ! -d ${SOURCES} || ! -d ${TESTS} || ! -d ${UTILITIES} ]]
then
  echo "Missing some directories, assuming the worst and exiting"
  exit 1
fi

GYB="${UTILITIES}/gyb.py"
if [[ ! -x ${GYB} ]]
then
  GITHUB=https://raw.githubusercontent.com/apple/swift/master/utils/gyb.py
  echo "Retrieving gyb.py from ${GITHUB}"
  /usr/bin/curl ${GITHUB} -o ${GYB}
  chmod u+x ${GYB}
fi

if [[ ${1} == "-f" ]]
then
  FORCE="-f"
fi

INPUT_FILE_LIST=`find ${SOURCES} ${TESTS} -name "*.gyb"`

echo "Starting generation of boilerplate:"
for INPUT_FILE in $INPUT_FILE_LIST
do
  OUTPUT_FILE=${INPUT_FILE%.*}

  if [[ -n $FORCE || $OUTPUT_FILE -ot $INPUT_FILE ]]
  then # output file is either older or doesn't exist yet
    echo "Generating ${OUTPUT_FILE}"
    ${GYB} --line-directive="" "${INPUT_FILE}" -o "${OUTPUT_FILE}"
  fi
done
echo "Boilerplate successfully generated."
