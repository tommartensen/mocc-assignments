#!/bin/bash

TIMESTAMP=$(date +%s)
RESULT=$(sh measure-cpu.sh)
echo "$TIMESTAMP,$RESULT" >> output-cpu.csv
