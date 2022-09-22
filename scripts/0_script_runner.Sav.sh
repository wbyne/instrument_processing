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
cp ${file}.particle ${file}.particle.tmp

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
### this section is done on beagle for 2G and sync'ed to AWS-wb-26June17_2217; particle done on-machine
#taken from the bash & date man pages and http://www.cyberciti.biz/faq/how-to-read-time-in-shell-script/
nowhr=$(date +"%H") #get current hour
nowmin=$(date +"%M") #get current minutes
nowmonth=$(date +"%b")
nowdy=$(date +"%d")
nowyr=$(date +"%y")
andthen=$(date +"%T")
if [ "$nowhr" == "13" ]&&[ "$nowmin" -ge "45" ]&&[ "$nowmin" -lt "60" ] 
#its 1PM and before the 15 minute mark.  Should only run once per day. 
then
#stop screen: SIGTSTP is stop typed at terminal vs SIGSTOP which is stop process
  echo "running screenlog cleanup process"
  #/bin/kill -s SIGTSTP `pidof screen` #don't think this works anymore.  Trying it on ubuntu 16 gives a return value of 1 (error)
  /bin/kill -s SIGTSTP `pgrep screen`
#  cp ${file} ${file}.tmp
  cp ${file}.particle ${file}.particle.tmp
#  echo "#restart" $andthen > ${file}
  echo "#restart" $andthen > ${file}.particle
  # restart screen 
  /bin/kill -s SIGCONT `pgrep screen` # see above; pidof removed in favor of pgrep
  filedir=/mnt/space/workspace/instrument_processing/log
  file2=screenlog.0
#  mv ${filedir}/${file2}.tmp ${filedir}/archive/${file2}.bkup_$nowdy$nowmonth$nowyr\_$nowhr$nowmin
  mv ${filedir}/${file2}.particle.tmp ${filedir}/archive/${file2}.particle.bkup_$nowdy$nowmonth$nowyr\_$nowhr$nowmin
#  gzip ${filedir}/archive/${file2}.bkup_$nowdy$nowmonth$nowyr\_$nowhr$nowmin
  gzip ${filedir}/archive/${file2}.particle.bkup_$nowdy$nowmonth$nowyr\_$nowhr$nowmin
#  if [ -e "../log/screenlog.0.processed" ]
#      then
#      rm ../log/screenlog.0.processed
#  fi
  if [ -e "../log/screenlog.0.particle.processed" ]
      then
      rm ../log/screenlog.0.particle.processed
  fi
#move both to bkup directory with the date in the name
# need to handle startup notation in the screenlog.0 file,
# and setup screen to start automatically, plus match
# phone numbers to station numbers.
fi 

echo "checking for email alerts"
echo "nowhr" $nowhr
echo "nowmin" $nowmin
if ([ "$nowhr" == "02" ]||[ "$nowhr" == "04" ]||[ "$nowhr" == "06" ]||[ "$nowhr" == "08" ]||[ "$nowhr" == "10" ]||[ "$nowhr" == "12" ]||[ "$nowhr" == "14" ]||[ "$nowhr" == "16" ]||[ "$nowhr" == "18" ]||[ "$nowhr" == "20" ]||[ "$nowhr" == "22" ])&&[ "$nowmin" -ge "45" ]&&[ "$nowmin" -lt "60" ]
then
echo "yes on alerts being triggered by script_runner"
4_alerts_not_reporting_2hrs.pl
#creates a file in data/site/ALLDATA/ALLDATA_ALERTS.txt to use to email if a
#    station hasn't reported in two hours
fi
echo "done checking for email alerts"

echo "done cleaning up screenlog, heading to plot data"
#/mnt/space/workspace/instrument_processing/scripts/gnuplot/batch_plot_interactive_commands.sh
# a bash file that calls different gnuplot scripts for plotting different lengths of data
#    the plot files are the same except for the duration listed to plot in each file
#    and yes, they probably could be consolidated
#echo "data plots completed"

#echo "Plotting Savannah data"
/mnt/space/workspace/instrument_processing/scripts/gnuplot/batch_plot_interactive_commands.Savannah.sh
# a bash file that calls different gnuplot scripts for plotting different lengths of data
#    the plot files are the same except for the duration listed to plot in each file
#    and yes, they probably could be consolidated
echo "Savannah data plots completed"

echo "calculating stats for sql update"
5_calc_stats.pl
# creates a data/station/parameter/station_parameter.sql file containing 
#     stats.  the sql update is done by gis_edit from a cron job
#     The file was supposed to be used to calculate stats for all parameters,
#     but was only used to calculate rainfall stats.
echo "calculating stats for sql update complete"

echo "calculating stats for summary table"
#6_calc_stats_alldata.pl
# creates:
#    1. data/site/ALLDATA/ALLDATA_STATS.csv, which contains 15 min, 1hr, 4hr, 24hr statistics for all sites
#    2. data/site/ALLDATA/ALLDATA_TABLE.html, which contains the data in a nice tabular format for all sites and all parameters
#    3. data/site/ALLDATA/ALLDATA_TABLE_SHORT_SUMMARY.html, which contains the data for just rain and depth for each site
#echo "calculating stats for summary table complete"

#echo "calculating stats for Savannah summary table"
6_calc_stats_alldata.Sav.pl
# creates:
#    1. data/site/ALLDATA/ALLDATA_STATS.Sav.csv, which contains 15 min, 1hr, 4hr, 24hr statistics for all sites
#    2. data/site/ALLDATA/ALLDATA_TABLE.Sav.html, which contains the data in a nice tabular format for all sites and all parameters
#    3. data/site/ALLDATA/ALLDATA_TABLE_SHORT_SUMMARY.Sav.html, which contains the data for just rain and depth for each site
echo "calculating stats for Savannah summary table complete"

##echo "calculating stats for CC summary table"
##calc_stats_alldata.CC.pl
# updates:
#    1. data/site/ALLDATA/ALLDATA_STATS.csv, which contains 15 min, 1hr, 4hr, 24hr statistics for all sites.  opens 
#        this file in append mode, so that alerts_all_parameters.pl can check that file for missing stats.
# creates:
#    1. data/site/ALLDATA/ALLDATA_STATS.CC.csv, which contains 15 min, 1hr, 4hr, 24hr statistics for all sites
#    2. data/site/ALLDATA/ALLDATA_TABLE.CC.html, which contains the data in a nice tabular format for all sites and all parameters
#    3. data/site/ALLDATA/ALLDATA_TABLE_SHORT_SUMMARY.CC.html, which contains the data for just rain and depth for each site
##echo "calculating stats for CC summary table complete"

##this section has to follow the calc_stats_alldata.pl because it uses the files
##  generated by that program.
echo "checking for advanced alarms"
# reads a configuration file titled ALLDATA_ALARM_LEVELS.csv, which includes alarm
#    levels for all parameters, along with a list of text numbers and email addresses by group for notification alerts.
#    writes files titled data/site/ALLDATA/ALERTS/ALLDATA_ALERTS_notification_list and uses
#    that file to send alerts.  then it copies those files to a backup file so that you
#    know when an alert was sent.
#
#check the daily total at 6 am so you can act on it if needed.
if ([ "$nowhr" == "06" ])&&[ "$nowmin" -ge "0" ]&&[ "$nowmin" -lt "16" ]
then
echo "yes on 24HR alarms being triggered by script_runner"
#7_alerts_all_parameters.pl 24HR

#check every 4 hours
elif ([ "$nowhr" == "00" ]||[ "$nowhr" == "04" ]||[ "$nowhr" == "08" ]||[ "$nowhr" == "12" ]||[ "$nowhr" == "16" ]||[ "$nowhr" == "20" ])&&[ "$nowmin" -ge "0" ]&&[ "$nowmin" -lt "16" ]
then
echo "yes on 4HR alarms being triggered by script_runner"
#7_alerts_all_parameters.pl 4HR

#check every hour
elif [ "$nowmin" -ge "00" ]&&[ "$nowmin" -lt "16" ]
then
echo "yes on 1HR alarms being triggered by script_runner"
#7_alerts_all_parameters.pl 1HR
	    
#check every 15 minutes
else
echo "yes on 15MIN alarms being triggered by script_runner"
#7_alerts_all_parameters.pl 15MIN
fi

	 
echo "synching data to webserver"
/usr/bin/rsync --exclude "*ALLDATA.csv" --exclude "*RESET.csv" -rv /mnt/space/workspace/instrument_processing/data/ /var/lib/tomcat9/webapps/ROOT/data/
echo "rsync to tomcat directory complete\n"
echo "removing screenlog.0.processed\n"
rm ${file}.processed
echo "complete\n"
echo "removing screenlog.0.particle.processed\n"
rm ${file}.particle.processed
echo "complete\n"


## other relevant files:
# calc_stats_alldata_long_term.pl: a rewrite of calc_stats_alldata with
#   a flexible structure which takes arguments for the length of time to
#   perform calculations.  Creates a few files:
#    1. data/site/ALLDATA/ALLDATA_TABLE_long_term.html
#    2. data/site/ALLDATA/ALLDATA_TABLE_SHORT_SUMMARY_long_term.html
#   this file should eventually replace calc_stats_alldata.pl

# update_sql.pl
#    this is a script that reads the data/site/station/parameter/station_parameter.sql file and loads it into the geoserver database by gis_edit through a cron job
