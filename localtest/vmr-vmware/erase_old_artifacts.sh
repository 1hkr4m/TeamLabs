#!/bin/bash

# Script erase all folders in selectec path, and keep only 4 newer folder

DIR_PATH=/tmp/artifacts/
DIR_COUNT=$(ls $DIR_PATH | wc -l) 

for i in `seq 5 $(($DIR_COUNT+1))`
do
    cd $DIR_PATH
    rm -rf $(ls -tl | cut -d' ' -f9 | sed -n 5p)
done

