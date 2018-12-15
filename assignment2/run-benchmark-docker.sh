#!/bin/bash

echo "time,value" > docker-cpu.csv
echo "time,value" > docker-mem.csv
echo "time,value" > docker-disk-random.csv
echo "time,value" > docker-fork.csv
echo "time,value" > docker-nginx.csv

for i in `seq 1 48`; do
  echo "$(date +%s),$(docker run --rm measure-cpu)" >> docker-cpu.csv
  echo "$(date +%s),$(docker run --rm measure-mem)" >> docker-mem.csv
  echo "$(date +%s),$(docker run --rm measure-disk-random)" >> docker-disk-random.csv
  echo "$(date +%s),$(docker run --rm measure-fork)" >> docker-fork.csv
  echo "$(date +%s),$(sh measure-nginx.sh localhost)" >> docker-nginx.csv
done
