#!/bin/bash

# This script will fail if a `gyb` file and the file it generates are out of sync.

INPUT_LIST=`find Sources Tests -name "*.gyb"`
[[ -z $INPUT_LIST ]] && exit 0

GYB="Utilities/gyb.py"
if [ -n "${TRAVIS_BUILD_DIR}" ];
then
  GYB="${TRAVIS_BUILD_DIR}/${GYB}"
fi

if [[ ! -x ${GYB} ]]
then
  GITHUB=https://raw.githubusercontent.com/apple/swift/main/utils/gyb.py
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

  # echo "Generating ${OUTPUT_TMP}"
  ${GYB} --line-directive="" "${INPUT_FILE}" -o "${OUTPUT_TMP}"
  # echo "Comparing ${OUT_TARGET} with ${OUTPUT_TMP}"
  DIFF=`/usr/bin/diff -q "${OUTPUT_TMP}" "${OUT_TARGET}"`
  if [ $? -ne 0 ]
  then
    echo "${INPUT_FILE_BASE} differs from generated output of ${INPUT_FILE_NAME} in ${INPUT_FILE_PATH}"
    exit 1
  fi
  /bin/rm -f "${OUTPUT_TMP}"
done
