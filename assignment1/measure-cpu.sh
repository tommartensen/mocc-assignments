#!/bin/bash 
EXECUTABLE="linpack"
if [ ! -e $EXECUTABLE ] ; then
	cc -O -o linpack linpack.c -lm
fi

echo $(./${EXECUTABLE} | tail -1 | sed "s/[[:blank:]]\+/ /g" | cut -d " " -f 7)
