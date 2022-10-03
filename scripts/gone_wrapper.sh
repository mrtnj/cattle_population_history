#!/bin/bash

## Create a working directory for GONE and run it

set -eu

GONE_DIR=~/tools/GONE/

INPUT_FILE_PREFIX=${1:-}
OUTPUT_DIR=${2:-}

if [ "$#" -ne 2 ]; then
  echo "Wrong number of arguments"
  exit 1
fi

if [ -d $OUTPUT_DIR ]; then
  echo "Output dir exists"
  exit 1
fi

mkdir $OUTPUT_DIR

## Copy GONE files

cp -r ${GONE_DIR}/Linux/PROGRAMMES $OUTPUT_DIR/
cp ${GONE_DIR}/Linux/INPUT_PARAMETERS_FILE $OUTPUT_DIR/
cp ${GONE_DIR}/Linux/script_GONE.sh $OUTPUT_DIR/

## Softlink data

ln -s "$(pwd)"/$INPUT_FILE_PREFIX.ped $OUTPUT_DIR/data.ped
ln -s "$(pwd)"/$INPUT_FILE_PREFIX.map $OUTPUT_DIR/data.map

cd $OUTPUT_DIR

chmod u+x PROGRAMMES/*

bash script_GONE.sh data \
  > log.txt 2>&1

echo "Done"