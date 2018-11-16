#!/bin/bash

echo "$(date +%s),$(sh measure-cpu.sh)" >> output-cpu.csv
echo "$(date +%s),$(sh measure-mem.sh)" >> output-memory.csv
