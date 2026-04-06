#!/bin/bash
set -euo pipefail

rm -rf simde
git clone https://github.com/simd-everywhere/simde
mv simde/simde simde-temp
mv simde/COPYING LICENSE
rm -rf simde
mv simde-temp simde
