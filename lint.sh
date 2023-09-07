#!/bin/sh

set -e

./BuildTools/swiftformat.sh . --lint --report reports/swiftformat.json
./BuildTools/swiftlint.sh --strict --reporter html --output reports/swiftlint.html