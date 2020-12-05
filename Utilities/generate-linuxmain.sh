#!/bin/sh

manifest="XCTestManifests.swift"

if [[ -z ${PROJECT_DIR} ]]
then
  testspath="${PWD}/Tests"
else
  testspath="${PROJECT_DIR}/../Tests"
fi

testdirs="SwiftAtomicsTests"

for testdir in ${testdirs}
do
  manifestpath="${testspath}/${testdir}/${manifest}"
  if /bin/test ! -s "${manifestpath}"
  then
    # echo "$manifestpath does not exist"
    generate="yes"
  else
    newer=`/usr/bin/find "${testspath}/${testdir}" -newer "${manifestpath}"`
    if /bin/test "${newer}"
    then
      # echo "newer files than $manifestpath"
      generate="yes"
    fi
  fi
done

if /bin/test "${generate}"
then
  /usr/bin/find "${testspath}" -name "${manifest}" -exec rm -f {} \;
  echo "Regenerating test manifests"
  /usr/bin/swift test --generate-linuxmain
  prev="${PWD}"
  cd "${testspath}/../"
  /usr/bin/git apply "Utilities/test-compatibility.diff"
  cd "${prev}"
else
  echo "No need to regenerate test manifests"
fi
