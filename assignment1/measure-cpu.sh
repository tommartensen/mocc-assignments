#!/bin/bash
EXECUTABLE="linpack"
if [ ! -e $EXECUTABLE ] ; then
	cc -O -o $(dirname $0)/linpack $(dirname $0)/linpack.c -lm
fi

echo $(/$(dirname $0)/${EXECUTABLE} | tail -1 | sed "s/[[:blank:]]\+/ /g" | cut -d " " -f 7)
