#!/bin/bash
mkdir out
../../scan-code.sh in > out/scanme.out
diff out/scanme.out base/scanme.base

