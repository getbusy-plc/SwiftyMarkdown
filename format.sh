#!/bin/sh

set -e

./BuildTools/swiftlint.sh --fix --strict --reporter html --output reports/swiftlint.html
./BuildTools/swiftformat.sh . --report reports/swiftformat.json
