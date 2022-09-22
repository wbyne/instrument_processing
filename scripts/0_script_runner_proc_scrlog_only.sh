#!/bin/bash
#merged notes from script_runner_explained.sh on 27May20 (why not sooner???)
# diff'ed the two files on 27may20 and this comment was the only difference.
#updates: added particle lines -fwb-1June20-0505

PATH="/mnt/space/workspace/instrument_processing/scripts/:$PATH"

for file in `ls /mnt/space/workspace/instrument_processing/log/screenlog.0`
#${i%%pdf}jpg
#for fileparticle in `ls /mnt/space/workspace/instrument_processing/log/particle/screenlog.0`

# %% is suffix removal and replacement
# % is suffix removal
# # is prefix removal
# ## is prefix removal and replacment

do 
#filenosufx=${file%S***};
echo ${file}
#sleep 5s
#cp ${file} ${file}.tmp
cp /mnt/space/workspace/instrument_processing/log/aud/screenlog.0 /mnt/space/workspace/instrument_processing/log/screenlog.0.particle.tmp
#echo "copy of screenlog.0 to tmp complete\n";
echo "copy of screenlog.0.particle to tmp complete\n";
#sleep 5s
## changed from append to file to overwrite file 10jul20 due to problem with deleting file after processing
## This file got a major overhaul in 4feb22 and now it takes the stations in the screenlog.0 file
##  and writes this to two files: one for all of the perl scripts for processing and one for the 
##  gnuplot files.  Then we don't have to type in all of the stations that need to be processed and the
##  system automatically handles which ones to process.  By further updating the parameter files, it 
##  would be possible to only process those with parameters greater than 0 in the last day as well.  
##  Might be worth looking into. -fwb-4feb22_2130
#quick_extracton.short_version.pl ${file}.tmp > ${file}.processed
1_quick_extraction.short_version_particle.pl ${file}.particle.tmp > ${file}.particle.processed
# extracts records from screenlog.0 to a one station, one record format:
#    10000,RAIN,02,09,18,13,40,0000
#    10000,LIGHT,02,09,18,13,40,0000
#    10000,TEMP,02,09,18,13,40,0059
#echo "quick_extraction.short_version complete\n"
echo "quick_extraction.short_version_particle complete\n"
#process_texts.pl 
2_process_texts_particle.pl
# uses the screenlog.0.processed file, sorts all data in that file, removes duplicates
#    then opens the station_parameter file (10000/RAIN/10000_RAIN.txt) and adds the new data in, then sorts and removes duplicates from that file
#    script also creates IMEI records and creates folder structures for new
#    station_number/parameter combinations
#    years are added to a special sorting routine to allow the files to pass over the new year in the proper order
#echo "process_texts.pl complete\n"
echo "process_texts_particle.pl complete\n"
#process_all_data.pl 
#echo "process_all_data.pl complete\n"
3_process_all_data_particle.pl
# this was a fork of process_texts.pl.  It reads screenlog.0.tmp and creates three files:
#    1. data/site/station/ALLDATA/station_reset.csv, which shows all resets in the screenlog file
#    2. data/site/station/ALLDATA/ALLDATA.csv, a summary of all data in a csv file
#    3. data/site/station/ALLDATA/ALLDATA_Summary.csv, for only a select few parameters
echo "process_all_data_particle.pl complete\n"
#rm ${file}.tmp
rm ${file}.particle.tmp
#echo "removed tmp file"
echo "removed particle tmp file"
done

  if [ -e "../log/screenlog.0.particle.processed" ]
      then
      rm ../log/screenlog.0.particle.processed
  fi
#move both to bkup directory with the date in the name
# need to handle startup notation in the screenlog.0 file,
# and setup screen to start automatically, plus match
# phone numbers to station numbers.


