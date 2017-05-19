#!/bin/sh

set -e

if [[ -z ${PROJECT_DIR} ]]
then
  SOURCE_DIR="${PWD}/Sources"
  GYB="${PWD}/utils/gyb"
else
  SOURCE_DIR="${PROJECT_DIR}/../Sources"
  GYB="${PROJECT_DIR}/../utils/gyb"
fi

INPUT_FILE_LIST=`find ${SOURCE_DIR} -name "*.gyb"`

echo "Starting generation of boilerplate:"
for INPUT_FILE in $INPUT_FILE_LIST
do
  INPUT_FILE_PATH=${INPUT_FILE%/*}
  INPUT_FILE_NAME=${INPUT_FILE##*/}
  INPUT_FILE_BASE=${INPUT_FILE_NAME%.*}

  OUTPUT_FILE="${INPUT_FILE_PATH}/${INPUT_FILE_BASE}"

  if [[ $OUTPUT_FILE -ot $INPUT_FILE ]]
  then # output file is either older or doesn't exist yet
    echo "Generating ${OUTPUT_FILE}"
    ${GYB} --line-directive="" "${INPUT_FILE}" -o "${OUTPUT_FILE}"
  fi
done
echo "Boilerplate successfully generated."
