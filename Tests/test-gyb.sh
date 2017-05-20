#!/bin/bash
set -e

# This script will fail if a `gyb` file and the file it generates are out of sync.

INPUT_LIST=`find Sources -name "*.gyb"`

for INPUT_FILE in $INPUT_LIST
do
  INPUT_FILE_PATH=${INPUT_FILE%/*}
  INPUT_FILE_NAME=${INPUT_FILE##*/}
  INPUT_FILE_BASE=${INPUT_FILE_NAME%.*}

  OUTPUT_TMP="/tmp/${INPUT_FILE_BASE}"
  OUT_TARGET="${INPUT_FILE_PATH}/${INPUT_FILE_BASE}"

  ./utils/gyb --line-directive="" "${INPUT_FILE}" -o "${OUTPUT_TMP}"
  echo "Comparing ${OUT_TARGET} with ${OUTPUT_TMP}"
  /usr/bin/diff "${OUTPUT_TMP}" "${OUT_TARGET}"
  /bin/rm -f "${OUTPUT_TMP}"
done
