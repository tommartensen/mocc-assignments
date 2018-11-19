#!/bin/bash

#Number of parallel requests
IODEPTH=16
SIZE='4M'
BLOCKSIZE='4B'
RUNTIME=1

#Test read and write operations for random workload with deactivated page cache and reduced gettimeofday() calls
#For Ubuntu
#--ioengine=libaio
RWFIO=$(fio --randrepeat=1 --direct=1 --runtime=$RUNTIME --ioengine=posixaio \
--gtod_reduce=1 --name=test --filename=test --bs=$BLOCKSIZE --iodepth=$IODEPTH --size=$SIZE --readwrite=randrw)

#Extract read and write values
RESULTFIO=$(echo "$RWFIO" | grep 'iops' | cut -d ',' -f3 | sed 's/avg=//')

READS=$(echo "$RESULTFIO" | head -n 1)
WRITES=$(echo "$RESULTFIO" | tail -n 1)

echo "Read operations per second: $READS" 
echo "Write operations per second: $WRITES" 

#Add the read and write iops
RESULTSUM=$(echo "$RESULTFIO" | paste -sd+ -)

echo "scale=3; ($RESULTSUM)/2" | bc