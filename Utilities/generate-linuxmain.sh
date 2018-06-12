#!/bin/sh

manifest="XCTestManifests.swift"
testspath="${PROJECT_DIR}/../Tests"

testdirs="AtomicsTests CAtomicsTests"

for testdir in ${testdirs}
do
  manifestpath="${testspath}/${testdir}/${manifest}"
  if /bin/test ! -s "${manifestpath}"
  then
    # echo "$manifestpath does not exist"
    generate="yes"
  elif /bin/test `/usr/bin/find "${testspath}/${testdir}" -newer "${manifestpath}"`
  then
    # echo "newer files than $manifestpath"
    generate="yes"
  fi
done

if /bin/test ${generate}
then
  /usr/bin/find "${testspath}" -name ${manifest} -exec rm -f {} \;
  echo "Regenerating test manifests"
  /usr/bin/swift test --generate-linuxmain
fi
