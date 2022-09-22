#!/bin/bash
#merged notes from script_runner_explained.sh on 27May20 (why not sooner???)
# diff'ed the two files on 27may20 and this comment was the only difference.
#updates: added particle lines -fwb-1June20-0505

PATH="/mnt/space/workspace/instrument_processing/scripts/:$PATH"

for file in `cat /mnt/space/workspace/instrument_processing/scripts/99_jan21_screenlogs.txt`
#${i%%pdf}jpg
#for fileparticle in `ls /mnt/space/workspace/instrument_processing/log/particle/screenlog.0`

# %% is suffix removal and replacement
# % is suffix removal
# # is prefix removal
# ## is prefix removal and replacment

do 
#filenosufx=${file%S***};
echo ${file}
cp ../log/archive/${file} tmp/${file}
cp tmp/${file} tmp/screenlog.0.gz
gunzip tmp/screenlog.0.gz
cp tmp/screenlog.0 ../log/aud/screenlog.0
0_script_runner_proc_scrlog_only.sh
echo "done with ${file}\n";
rm tmp/screenlog.0
done

