#!/bin/bash

set -uo pipefail

rm -f ERROR ERROR? abin.out
if [[ $1 = "clean" ]];then
  exit 0
fi

ABINEXE=$1
GEOM=mini.xyz

$ABINEXE -i input.in -x $GEOM > abin.out 2>&1
mv ERROR ERROR1
$ABINEXE -i input.in2 -x $GEOM >> abin.out 2>&1
mv ERROR ERROR2
