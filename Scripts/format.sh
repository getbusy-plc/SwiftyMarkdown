#!/bin/sh

set -e

./BuildTools/swiftformat.sh . --report reports/swiftformat.json
./BuildTools/swiftlint.sh --fix --strict --quiet --reporter html --output reports/swiftlint.html
