#!/bin/bash
EXECUTABLE="memsweep"
if [ ! -e $EXECUTABLE ] ; then
  cc -O -o memsweep memsweep.c -lm
fi

SUM="0.0"
NUM="0"

# Get score from executable, grep only score, not the noisy output!
SCORE=$(./$EXECUTABLE  | grep -o -P '\d+\.\d{3}')
NUM=$(($NUM + 1))
SUM=`echo $SUM+$SCORE | bc`
# Calculate average, three decimal places should be enough
echo $(echo "scale=3; $SUM/$NUM" | bc -l)
