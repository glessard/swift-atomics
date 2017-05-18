#!/bin/bash
set -e

clang --version
swift --version

cd "$(dirname $0)/../"

swift test -s ClangAtomicsTests.ClangAtomicsTests
swift test -s AtomicsTests.MemoryOrderTests
swift test -s AtomicsTests.AtomicsTests
swift test -s AtomicsTests.AtomicsRaceTests
