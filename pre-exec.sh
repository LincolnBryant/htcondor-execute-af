#!/bin/bash
set -eo pipefail
# This script does not do significant (any) error checking.

# Calculate the CPUs to give to HTCondor
if [ -z ${K8S_CPU+x} ]; then
  echo "No Kubernetes CPU information received from downward API"
else
  CPU=$(echo $K8S_CPU | awk '{print int($1/1000)}')
  if [[ $CPU -lt 1 ]]; then
    echo "WARNING: Less than a whole CPU allocated, Will set CPU = 1, but K8S may evict this pod!"
    CPU=1
  fi
  echo "NUM_CPUS=$CPU" >> /etc/condor/config.d/02-slot.conf
fi

# Calculate the memory to give to HTCondor
if [ -z ${K8S_MEM+x} ]; then
  echo "No Kubernetes memory information received from downward API"
else
  # From the docs: 
  # Limits and requests for memory are measured in bytes. You can express
  # memory as a plain integer or as a fixed-point number using one of these
  # suffixes: E, P, T, G, M, K. You can also use the power-of-two equivalents:
  # Ei, Pi, Ti, Gi, Mi, Ki. 
  
  # Use numfmt to read in from the API and convert it to MB for HTCondor
  MEM=$(($(echo ${K8S_MEM} | numfmt --from auto)/1024/1024))
  #if [[ $MEM -gt 128 ]]; then 
  #  echo "Reserve 128MB of RAM for HTCondor daemons"
  #  echo "RESERVED_MEMORY=128" >> /etc/condor/config.d/02-slot.conf
  #fi 
  echo "MEMORY=$MEM" >> /etc/condor/config.d/02-slot.conf
fi
