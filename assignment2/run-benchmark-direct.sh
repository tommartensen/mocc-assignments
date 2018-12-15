#!/bin/bash

BENCHMARK_TYPE=$1

echo "time,value" > $BENCHMARK_TYPE-cpu.csv
echo "time,value" > $BENCHMARK_TYPE-mem.csv
echo "time,value" > $BENCHMARK_TYPE-disk-random.csv
echo "time,value" > $BENCHMARK_TYPE-fork.csv
echo "time,value" > $BENCHMARK_TYPE-nginx.csv

for i in `seq 1 48`; do
  echo "$(date +%s),$(sh measure-cpu.sh)" >> $BENCHMARK_TYPE-cpu.csv
  echo "$(date +%s),$(sh measure-mem.sh)" >> $BENCHMARK_TYPE-mem.csv
  echo "$(date +%s),$(sh measure-disk-random.sh)" >> $BENCHMARK_TYPE-disk-random.csv
  echo "$(date +%s),$(sh measure-fork.sh)" >> $BENCHMARK_TYPE-fork.csv
  echo "$(date +%s),$(sh measure-nginx.sh localhost)" >> $BENCHMARK_TYPE-nginx.csv
done
