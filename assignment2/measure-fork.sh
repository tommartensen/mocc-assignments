#!/bin/bash
EXECUTABLE="forksum"
if [ ! -e $EXECUTABLE ] ; then
	#cc -O -o $(dirname $0)/forksum $(dirname $0)/forksum.c -lm -> used during cronjob, due to absolute paths
	cc -O -o forksum forksum.c -lm
fi

if [[ $# != 2 ]]; then
	echo "You must enter 2 arguments"
	exit
fi

#echo $(/$(dirname $0)/${EXECUTABLE}) -> used during cronjob, due to absolute paths
echo $(./${EXECUTABLE} $1 $2 2>&1)