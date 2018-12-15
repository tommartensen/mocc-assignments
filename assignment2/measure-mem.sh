#!/bin/bash
EXECUTABLE="memsweep"
if [ ! -e $EXECUTABLE ] ; then
  cc -O -o memsweep memsweep.c -lm
  #cc -O -o $(dirname $0)/memsweep $(dirname $0)/memsweep.c -lm -> used during cronjob, because of absolute path
fi

SUM="0.0"
NUM="0"

while [ $NUM -lt 2 ]; do
  # Get score from executable, grep only score, not the noisy output!
  SCORE=$(./$EXECUTABLE  | grep -o -P '\d+\.\d{3}')
  # SCORE=$(/$(dirname $0)/$EXECUTABLE  | grep -o -P '\d+\.\d{3}') -> used during cronjob, because of absolute path
  NUM=$(($NUM + 1))
  SUM=`echo $SUM + $SCORE | bc`
done

# Calculate average, three decimal places should be enough
echo "scale=3; $SUM/$NUM" | bc -l
