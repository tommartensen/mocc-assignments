#!/bin/bash

echo "Get information on kernel, architecture, hardware platform and operating system"
uname -a

echo "Get hardware information with lshw"
sudo lshw

echo "Get cpu information with lscpu"
lscpu

echo "Get block device information with lsblk"
lsblk -a

