#!/bin/bash

echo "$(date +%s),$(sh /home/tom/mocc-assignments/assignment1/measure-cpu.sh)" >> output-cpu.csv
echo "$(date +%s),$(sh /home/tom/mocc-assignments/assignment1/measure-mem.sh)" >> output-memory.csv
echo "$(date +%s),$(sh /home/tom/mocc-assignments/assignment1/measure-disk-sequential.sh)" >> output-disk-sequential.csv
echo "$(date +%s),$(sh /home/tom/mocc-assignments/assignment1/measure-disk-random.sh)" >> output-disk-random.csv
