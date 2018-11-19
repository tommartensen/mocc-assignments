#!/bin/bash

echo "$(date +%s),$(sh measure-cpu.sh)" >> output-cpu.csv
echo "$(date +%s),$(sh measure-mem.sh)" >> output-memory.csv
echo "$(date +%s),$(sh measure-disk-sequential.sh)" >> output-disk-sequential.csv
echo "$(date +%s),$(sh measure-disk-random.sh)" >> output-disk-random.csv