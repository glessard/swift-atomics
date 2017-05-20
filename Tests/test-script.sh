#!/bin/bash
set -e

swift test -s ClangAtomicsTests.ClangAtomicsTests
swift test -s AtomicsTests.MemoryOrderTests
swift test -s AtomicsTests.AtomicsTests
swift test -s AtomicsTests.AtomicsRaceTests
