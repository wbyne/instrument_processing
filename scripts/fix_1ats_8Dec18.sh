#!/bin/bash

for i in 100 200 300 400 500 600 700 800 900 10000 1100 1200
do 
 for j in "ANALOG" "DEPTH" "LIGHT" "RAIN" "TEMP" "TEMP_RTC"
#DEPTH" "LIGHT" "RAIN" "TEMP" "TEMP_RTC"
  do
    echo /mnt/space/workspace/instrument_processing/data/site/$i/$j/$i"_"$j".txt"
    sed -i 's/1@/10/' /mnt/space/workspace/instrument_processing/data/site/$i/$j/$i"_"$j".txt"
  done
done
 
