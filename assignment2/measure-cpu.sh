#!/bin/bash
EXECUTABLE="linpack"
if [ ! -e $EXECUTABLE ] ; then
	#cc -O -o $(dirname $0)/linpack $(dirname $0)/linpack.c -lm -> used during cronjob, due to absolute paths
	cc -O -o linpack linpack.c -lm
fi

#echo $(/$(dirname $0)/${EXECUTABLE} | tail -1 | sed "s/[[:blank:]]\+/ /g" | cut -d " " -f 7) -> used during cronjob, due to absolute paths
echo $(./${EXECUTABLE} | tail -1 | sed "s/[[:blank:]]\+/ /g" | cut -d " " -f 7)