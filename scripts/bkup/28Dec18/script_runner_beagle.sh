#!/bin/bash
#for use on beagle.  rotates the screenlog.0 file every day at noon,
# and then copies the file up to
# and then to hydrologicdata.org -wb-26June17
# added testing.hydrologicdata.org -wb-20Jul17

PATH="/mnt/space/workspace/instrument_processing/scripts/:$PATH"

file=`ls /mnt/space/workspace/instrument_processing/log/screenlog.0`
echo ${file}
sleep 1s
#cp ${file} ${file}.tmp
#echo "copy of screenlog.0 to tmp complete\n";
#sleep 1s

# %% is suffix removal and replacement
# % is suffix removal
# # is prefix removal
# ## is prefix removal and replacment

#taken from the bash & date man pages and http://www.cyberciti.biz/faq/how-to-read-time-in-shell-script/
nowhr=$(date +"%H") #get current hour
nowmin=$(date +"%M") #get current minutes
nowmonth=$(date +"%b")
nowdy=$(date +"%d")
nowyr=$(date +"%y")
andthen=$(date +"%T")
if [ "$nowhr" == "13" ]&&[ "$nowmin" -ge "45" ]&&[ "$nowmin" -lt "60" ] 
#its midnight and before the 15 minute mark.  Should only run once per day. 
then
#stop screen: SIGTSTP is stop typed at terminal vs SIGSTOP which is stop process
  echo "running screenlog cleanup process"
  /bin/kill -s SIGTSTP `pidof screen`
  cp ${file} ${file}.tmp
  echo "#restart" $andthen > ${file}
  # restart screen 
  /bin/kill -s SIGCONT `pidof screen`
  filedir=/mnt/space/workspace/instrument_processing/log
  file2=screenlog.0
  mv ${filedir}/${file2}.tmp ${filedir}/archive/${file2}.bkup_$nowdy$nowmonth$nowyr\_$nowhr$nowmin
  gzip ${filedir}/archive/${file2}.bkup_$nowdy$nowmonth$nowyr\_$nowhr$nowmin
  if [ -e "../log/screenlog.0.processed" ]
      then
      rm ../log/screenlog.0.processed
  fi
  /usr/bin/rsync -e 'ssh' /mnt/space/workspace/instrument_processing/log/archive/${file2}.bkup_$nowdy$nowmonth$nowyr\_$nowhr$nowmin.gz gpoz@hydrologicdata.org:/mnt/space/workspace/instrument_processing/log/archive/
#testing.hydrologicdata.org
  /usr/bin/rsync -e 'ssh' /mnt/space/workspace/instrument_processing/log/archive/${file2}.bkup_$nowdy$nowmonth$nowyr\_$nowhr$nowmin.gz gpoz@testing.hydrologicdata.org:/mnt/space/workspace/instrument_processing/log/archive/

  echo "done rotating screenlog.0"
#move both to bkup directory with the date in the name
# need to handle startup notation in the screenlog.0 file,
# and setup screen to start automatically, plus match
# phone numbers to station numbers.
fi 

/usr/bin/rsync -e 'ssh' /mnt/space/workspace/instrument_processing/log/screenlog.0 gpoz@hydrologicdata.org:/mnt/space/workspace/instrument_processing/log/
#testing.hydrologicdata.org
/usr/bin/rsync -e 'ssh' /mnt/space/workspace/instrument_processing/log/screenlog.0 gpoz@testing.hydrologicdata.org:/mnt/space/workspace/instrument_processing/log/

echo "complete\n"
