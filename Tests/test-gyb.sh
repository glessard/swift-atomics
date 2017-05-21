#!/bin/bash
set -e

# This script will fail if a `gyb` file and the file it generates are out of sync.

INPUT_LIST=`find Sources -name "*.gyb"`
[[ -z $INPUT_LIST ]] && exit 0

GYB="${TRAVIS_BUILD_DIR}/Utilities/gyb.py"
if [[ ! -x ${GYB} ]]
then
  GITHUB=https://raw.githubusercontent.com/apple/swift/master/utils/gyb.py
  echo "Retrieving gyb.py from ${GITHUB}"
  /usr/bin/curl ${GITHUB} -o ${GYB}
  chmod u+x ${GYB}
fi

for INPUT_FILE in $INPUT_LIST
do
  INPUT_FILE_PATH=${INPUT_FILE%/*}
  INPUT_FILE_NAME=${INPUT_FILE##*/}
  INPUT_FILE_BASE=${INPUT_FILE_NAME%.*}

  OUTPUT_TMP="/tmp/${INPUT_FILE_BASE}"
  OUT_TARGET="${INPUT_FILE_PATH}/${INPUT_FILE_BASE}"

  echo "Generating ${OUTPUT_TMP}"
  ${GYB} --line-directive="" "${INPUT_FILE}" -o "${OUTPUT_TMP}"
  echo "Comparing ${OUT_TARGET} with ${OUTPUT_TMP}"
  /usr/bin/diff "${OUTPUT_TMP}" "${OUT_TARGET}"
  /bin/rm -f "${OUTPUT_TMP}"
done
