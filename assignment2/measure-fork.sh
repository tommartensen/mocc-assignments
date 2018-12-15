#!/bin/bash
EXECUTABLE="forksum"
if [ ! -e $EXECUTABLE ] ; then
	cc -O -o forksum forksum.c -lm
fi

echo $(./${EXECUTABLE} 0 30000 2>&1)