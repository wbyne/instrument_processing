#!/bin/bash
#merged notes from script_runner_explained.sh on 27May20 (why not sooner???)
# diff'ed the two files on 27may20 and this comment was the only difference.
#updates: added particle lines -fwb-1June20-0505

PATH="/mnt/space/workspace/instrument_processing/scripts/:$PATH"

for station in 1050 1060 1070 1090 1130 1140 6080 6100 6170 
#5100 5200
do
  for param in COND DEPTH GEN_INT RAIN TEMP TEMP_RTC VELO VOLT WTR_TMP
#${i%%pdf}jpg
#for fileparticle in `ls /mnt/space/workspace/instrument_processing/log/particle/screenlog.0`

# %% is suffix removal and replacement
# % is suffix removal
# # is prefix removal
# ## is prefix removal and replacment

  do 
  #filenosufx=${file%S***};
  echo ${station}
  echo "/mnt/space/workspace/instrument_processing/data/site/${station}/${param}/${station}_${param}.txt"
  cp "/mnt/space/workspace/instrument_processing/data/site/${station}/${param}/${station}_${param}.txt" "/mnt/space/workspace/instrument_processing/data/site/${station}/${param}/${station}_${param}_bkup_8Aug22.txt"
  sed -i '/\/99/d' "/mnt/space/workspace/instrument_processing/data/site/${station}/${param}/${station}_${param}.txt"
  sed -i '/\/69/d' "/mnt/space/workspace/instrument_processing/data/site/${station}/${param}/${station}_${param}.txt"
  echo "done with ${station}\n";
  done

echo "working on station Summary files"
cp "/mnt/space/workspace/instrument_processing/data/site/${station}/ALLDATA/${station}_ALLDATA_Summary.csv" "/mnt/space/workspace/instrument_processing/data/site/${station}/ALLDATA/${station}_ALLDATA_Summary_bkup_8Aug22.csv"
sed -i '/\/99/d' "/mnt/space/workspace/instrument_processing/data/site/${station}/ALLDATA/${station}_ALLDATA_Summary.csv"
sed -i '/\/69/d' "/mnt/space/workspace/instrument_processing/data/site/${station}/ALLDATA/${station}_ALLDATA_Summary.csv"
echo "done working on station Summary files"
  
done
