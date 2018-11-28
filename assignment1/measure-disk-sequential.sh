#!/bin/bash

print_rate() {
    # Sample output: 2097152 bytes (2.1 MB, 2.0 MiB) copied, 0.014447 s, 145 MB/s
    BYTES_COPIED=$1
    TIME_ELAPSED=$(echo $8 | sed 's/,/\./')
    # Calculate rate in Bytes/second
    echo $(echo "scale=3; $BYTES_COPIED/$TIME_ELAPSED" | bc -l)
}


# Write speed, copy from /dev/zero to special file the specified amount of data (should fit into RAM completely), get last line of output (had to redirect stderr to stdout for this)
FILE_SIZE="128M"
OUTPUT=$(dd if=/dev/zero of=/tmp/test1.img bs=$FILE_SIZE count=1 oflag=dsync 2>&1 | tail -n 1)
WRITE_RATE=$(print_rate $OUTPUT)

# Test read speed
# Read file written beforehand to /tmp/test2.img with block size 8k
OUTPUT=$(dd if=/tmp/test1.img of=/dev/null iflag=direct bs=$FILE_SIZE 2>&1 | tail -n 1)
READ_RATE=$(print_rate $OUTPUT)

echo "scale=3; ($WRITE_RATE+$READ_RATE)/2" | bc -l