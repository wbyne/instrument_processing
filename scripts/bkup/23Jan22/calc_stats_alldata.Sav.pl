#!/usr/bin/perl
# script designed to perform statistics on each datafile.
# should be calc'ed for all parameters:
# Station_No\RAIN, DEPTH, TEMP, TEMP_RTC, ANALOG, LIGHT
# This file inherits structure from calc_stats.pl, which generates
#  sql file updates.  This file creates a statistics.csv file,
#  along with a summary.html and short_summary.html
#  This file doesn't create the individual station ALLDATA
#  or ALLDATA_Summary files, as those are created by process_texts.pl
#  and process_all_data.pl

##################################
#### This file is the same as calc_stats_alldata, except the station numbers have been changed
####  to reflect those in Savannah.  Yes, some of the numbers were re-used from the mobile 
####  stations in CC.
####  -fwb-19Sept21
##################################

####
#50: Harmon Creek at Harmon Bluff
#51: Vernon River at Vernonburg
#52: Casey Canal at Bacon Golf 
#55: Mobile Station
####

use DateTime;


($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$iisdst) = localtime(time);
my @abbr = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
print "$abbr[$mon] $mday";
$year += 1900; #year is an offset from 1900
#$year = sprintf("%02d", $year % 100); #calculate 2-digit year

$currdate = DateTime->new(
     	year      => $year,
	month     => $mon+1, #month goes from 0..11....
	day       => $mday,
	hour      => $hour,
	minute 	  => $min,
	time_zone => "America/New_York",
	);

$savepath = "/mnt/space/workspace/instrument_processing/data/site";
#STATION, DateTimelong, Tip_Count_Copy, velocity, air_temp, depth, voltage, rtc_temp, wtr_temp,Gen_Int_Copy,conductivity
#my @paramlist = qw(RAIN LIGHT TEMP DEPTH ANALOG TEMP_RTC VELO VOLT WTR_TMP GEN_INT COND);
# LIGHT became VELOcity, Swapped ANALOG for VOLT
my @paramlist = qw(RAIN VELO TEMP DEPTH VOLT TEMP_RTC WTR_TMP GEN_INT COND);
my @stationlist = qw(5000 5100 5200); # 3300 3400 3500 3600 5100 5200 5300 5500 5900);
#my @stationlist = qw(400);

$kk=0;
my $ii = 0;
my $jj = 0;
for $ii (0 ..$#stationlist) {
    for $jj (0 ..$#paramlist) {
      $lastday = 0;
      $lastfourhours = 0;
      $lasthour = 0;
      $lastfifteen = 0;
    if (-e "$savepath/$stationlist[$ii]/$paramlist[$jj]/$stationlist[$ii]_$paramlist[$jj].txt" ) {
      open (INPUT_FILE, "$savepath/$stationlist[$ii]/$paramlist[$jj]/$stationlist[$ii]_$paramlist[$jj].txt") or die "Can\'t find INPUT_FILE\n";
     $linecounter = 0;
     @linearray = ();
      while ($_=<INPUT_FILE>) {
        if ($_ =~ /^#/) {
          next;
        }
        chomp $_;
        $linearray[$linecounter] = $_;
        $linecounter++;
      }#while input_file open and read file
      close(INPUT_FILE);
      for ($kk=1;$kk<=4;$kk++) { #set up initial conditions for max, min, total
        $param[$ii][$jj][$kk][1] = -9999; #max reset
        $param[$ii][$jj][$kk][2] =  9999; #min reset
        $param[$ii][$jj][$kk][3] =    0; #total
      }
      #cycle backwards through the entries in the file looking for data within 15 minutes, 4 hours, and 24 hours.  Total them up as you find them and put them into a few variables
      for ($linecounter=$#linearray; $linecounter>0; $linecounter--) {
        #split the last entry in linearray, and determine if it's within 30 minutes of the actual time.  If not, then this station likely isn't working and set everything to -9999 (error, marked yellow, or some such).
        #Station,Date_Time,Date_Time_Adj,Rain_hundredths,Light,Temp_F,Depth_Hundredths_of_Feet,Analog,Temp_RTC_F
        #($stat, $datetimereal, $datetimefake, $rain, $light, $temp_F, $depth, $analog, $temp_rtc) = split " ",$linearray[$kk];
        ($stat, $param, $datedate, $timetime, $value) = split " ",$linearray[$linecounter];
        #($datedate, $timetime) = split " ",$datetimefake;
        ($datemon, $dateday, $dateyr) = split "\/",$datedate;
        $dateyr=2000+$dateyr; #correct for 4 year type.  This script will be good until the year 3000.
        ($timehr, $timemin) = split ":",$timetime;
        #convert to datetime object:
        $evaldate = DateTime->new(
          year      => $dateyr,
          month     => $datemon,
          day       => $dateday,
          hour      => $timehr,
          minute    => $timemin,
          time_zone => "America/New_York",
        );
        #my $dur = $currdate->subtract_datetime($evaldate); if you access the methods from this one, it will return minutes in "less than one hour" format...gets strange, just use the absolute version.
        my $dur = $currdate->subtract_datetime_absolute( $evaldate );
        #for my $jj (0 ..$#paramlist) {
        #my @paramlist = qw(RAIN, LIGHT, TEMP_F, DEPTH, ANALOG, TEMP_RTC);
        #$param[i][j][k][l]
        # i = station
        # j = parameter (rain(0), light(1), temp_f(2), depth(3), analog(4), temp_rtc(5))
        # k = time period for statistic (15min(1), hr(2), 4 hrs(3), day(4), weekly(5), bi-monthly(####), monthly(####), quarterly(####), 6-monthly(####), yearly(####))
        # l = parameter stat (0 (reserved for alerts, maybe), max(1), min(2), total(3), ave(4))
        if (($dur->seconds)>86400) {
            last;
              } #exit the loop if it's been more than a day.
        if (($dur->seconds)<= 86400) { #1day
          $kk=4;
          if ($value >= $param[$ii][$jj][$kk][1]) { $param[$ii][$jj][$kk][1] = $value; }#max
          if ($value <= $param[$ii][$jj][$kk][2]) { $param[$ii][$jj][$kk][2] = $value; }#min
          $param[$ii][$jj][$kk][3]=$param[$ii][$jj][$kk][3] + $value; #total
          $count[$ii][$jj][$kk]++; #for averages later
          #$lastday = $lastday+$value;
          if (($dur->seconds)<=14400) { #four hours
            $kk=3;
            if ($value >= $param[$ii][$jj][$kk][1]) { $param[$ii][$jj][$kk][1] = $value;} #max
            if ($value <= $param[$ii][$jj][$kk][2]) { $param[$ii][$jj][$kk][2] = $value;} #min
            $param[$ii][$jj][$kk][3]=$param[$ii][$jj][$kk][3] + $value; #total
            $count[$ii][$jj][$kk]++; #for averages later
            #$lastfourhours = $lastfourhours+$value;
            if (($dur->seconds)<= 3600) { #1 hour
              $kk=2;
              if ($value >= $param[$ii][$jj][$kk][1]) { $param[$ii][$jj][$kk][1] = $value;} #max
              if ($value <= $param[$ii][$jj][$kk][2]) { $param[$ii][$jj][$kk][2] = $value;} #min
              $param[$ii][$jj][$kk][3]=$param[$ii][$jj][$kk][3] + $value; #total
              $count[$ii][$jj][$kk]++; #for averages later
              #$lasthour = $lasthour+$value;
              if (($dur->seconds)< 1200) { #20 minutes, close enough to acct for a calculation cycle
                $kk=1;
                if ($value >= $param[$ii][$jj][$kk][1]) { $param[$ii][$jj][$kk][1] = $value;} #max
                if ($value <= $param[$ii][$jj][$kk][2]) { $param[$ii][$jj][$kk][2] = $value;} #min
                $param[$ii][$jj][$kk][3]=$param[$ii][$jj][$kk][3] + $value; #total
                $count[$ii][$jj][$kk]++; #for averages later
              #$lastfifteen = $lastfifteen+$value;
              }#15 mins
            }#1 hr
          }#4 hrs
        }#24 hrs
      }#  for ($linecounter=$#linearray; $kk>0; $kk--)
  }#if (-e "$savepath/$stationlist[$ii]/$paramlist[$jj]/$stationlist[$ii]_$paramlist[$jj].txt" )
      for ($kk=1; $kk<=4; $kk++) { #calculate averages
        if ($count[$ii][$jj][$kk]) { #make sure count is defined before trying to use it.
          if($count[$ii][$jj][$kk]>0) {
            $param[$ii][$jj][$kk][4] = $param[$ii][$jj][$kk][3] / $count[$ii][$jj][$kk];
          } #ave = total/count
        }
        else { $param[$ii][$jj][$kk][4] = 0;} #set ave to 0
      }#k

    }#for my $jj (0 ..$#paramlist)
  }#for my $ii (0 ..$#stationlist)

#my @stationlist = qw(3000 3100 3200 3300 3400 3500 3600);
# changed to reflect Savannah -fwb-19Sept21
       open  (STATS_FILE, ">","$savepath/ALLDATA/ALLDATA_STATS.Sav.csv") or die "Can\'t find STATS_FILE\n";
my $tmpmon = $mon+1;
       print STATS_FILE "Date and Time of Analysis: $tmpmon/$mday/$year $hour:$min\n";
       for $ii (0 ..$#stationlist) {
         if ($ii==0) {print STATS_FILE "STATION 50 (5000) Harmon Creek\n";}
         if ($ii==1) {print STATS_FILE "STATION 51 (5100) Vernon River\n";}
         if ($ii==2) {print STATS_FILE "STATION 52 (5200) Casey Canal\n";}
         #if ($ii==5) {print STATS_FILE "STATION 55 (5500) The Pass\n";}
         for $jj (0 ..$#paramlist) { #my @paramlist = qw(RAIN VELO TEMP DEPTH VOLT TEMP_RTC WTR_TMP GEN_INT COND);
	     if ($jj==0) {print STATS_FILE ",,,,RAIN (HUNDREDTHS OF AN INCH),,\n";}
	     if ($jj==1) {print STATS_FILE ",,,,VELO (VELOCITY),,\n";}
	     if ($jj==2) {print STATS_FILE ",,,,TEMP (DEGREES F),,\n";}
	     if ($jj==3) {print STATS_FILE ",,,,DEPTH (FT),,\n";}
	     if ($jj==4) {print STATS_FILE ",,,,VOLT (VOLTS),,\n";}
	     if ($jj==5) {print STATS_FILE ",,,,TEMP_RTC (DEGREES F-INSIDE BOX),,\n";}
	     if ($jj==6) {print STATS_FILE ",,,,WTR_TMP (WATER TEMP DEG-F),,\n";}
             if ($jj==7) {print STATS_FILE ",,,,GEN_INT (GENERAL INTERRUPT),,\n";}
	     if ($jj==8) {print STATS_FILE ",,,,COND (SAL IN THOUSANDS),,\n";}
	     print STATS_FILE ",,MAX,MIN,TOTAL,AVE\n";
	     for ($kk=1; $kk<=4; $kk++) {
		 if ($kk==1) {print STATS_FILE ",15MIN,";}
		 if ($kk==2) {print STATS_FILE ",1HR,";}
		 if ($kk==3) {print STATS_FILE ",4HR,";}
		 if ($kk==4) {print STATS_FILE ",24HR,";}
		 for ($l=1; $l<=4; $l++) {
		     if (($param[$ii][$jj][$kk][$l]>=9999) || ($param[$ii][$jj][$kk][$l]<=-9999)) {
			 $param[$ii][$jj][$kk][$l]=0;
		     } #no stats were calc'ed for these time periods, set them back to 0
		     if (($jj!=0) && ($l==3)) {
			 $param[$ii][$jj][$kk][$l] = 0;
		     } #don't report totals for anything for anything other than rain
		     if (($jj==0) || ($jj==3)) {
			 $param[$ii][$jj][$kk][$l] = ($param[$ii][$jj][$kk][$l]/100.);
		     } #rain and depth are reported in hundredths, normalize that to inches and ft
		     #               if ($jj==3) {$param[$ii][$jj][$kk][$l] = ($param[$ii][$jj][$kk][$l]/100.);} #depth is reported in hundredths, normalize that to ft
		     print STATS_FILE $param[$ii][$jj][$kk][$l].",";
		 }
		 print STATS_FILE "\n";
           }
         }
         print STATS_FILE "\n";
}
close (STATS_FILE);

####Re-open ALLDATA_STATS.csv in append mode so that alerts_all_parameters will work.
######  Note that I commented out the section where I divide the parameter by 100 to normalize the value to inches or feet
######    because I already did that in the section above, and I reuse that code here to write to the new file. This prevents
######    all values being low by a factor of 100.  -fwb-6Jul19
open  (STATS_FILE, ">>","$savepath/ALLDATA/ALLDATA_STATS.csv") or die "Can\'t find STATS_FILE\n";
my $tmpmon = $mon+1;
       print STATS_FILE "Date and Time of Analysis: $tmpmon/$mday/$year $hour:$min\n";
       for $ii (0 ..$#stationlist) {
         if ($ii==0) {print STATS_FILE "STATION 50 (5000) Harmon Creek\n";}
         if ($ii==1) {print STATS_FILE "STATION 51 (5100) Vernon River\n";}
         if ($ii==2) {print STATS_FILE "STATION 52 (5200) Casey Canal\n";}
         for $jj (0 ..$#paramlist) { #my @paramlist = qw(COND DEPTH GEN_INT RAIN TEMP TEMP_RTC VELO VOLT WTR_TMP  );
	     if ($jj==0) {print STATS_FILE ",,,,RAIN (HUNDREDTHS OF AN INCH),,\n";}
	     if ($jj==1) {print STATS_FILE ",,,,VELO (VELOCITY),,\n";}
	     if ($jj==2) {print STATS_FILE ",,,,TEMP (DEGREES F),,\n";}
	     if ($jj==3) {print STATS_FILE ",,,,DEPTH (FT),,\n";}
	     if ($jj==4) {print STATS_FILE ",,,,VOLT (VOLTS),,\n";}
	     if ($jj==5) {print STATS_FILE ",,,,TEMP_RTC (DEGREES F-INSIDE BOX),,\n";}
	     if ($jj==6) {print STATS_FILE ",,,,WTR_TMP (WATER TEMP DEG-F),,\n";}
             if ($jj==7) {print STATS_FILE ",,,,GEN_INT (GENERAL INTERRUPT),,\n";}
	     if ($jj==8) {print STATS_FILE ",,,,COND (SAL IN THOUSANDS),,\n";}
	     print STATS_FILE ",,MAX,MIN,TOTAL,AVE\n";
	     for ($kk=1; $kk<=4; $kk++) {
		 if ($kk==1) {print STATS_FILE ",15MIN,";}
		 if ($kk==2) {print STATS_FILE ",1HR,";}
		 if ($kk==3) {print STATS_FILE ",4HR,";}
		 if ($kk==4) {print STATS_FILE ",24HR,";}
		 for ($l=1; $l<=4; $l++) {
		     if (($param[$ii][$jj][$kk][$l]>=9999) || ($param[$ii][$jj][$kk][$l]<=-9999)) {
			 $param[$ii][$jj][$kk][$l]=0;
		     } #no stats were calc'ed for these time periods, set them back to 0
		     if (($jj!=0) && ($l==3)) {
			 $param[$ii][$jj][$kk][$l] = 0;
		     } #don't report totals for anything for anything other than rain
		     if (($jj==0) || ($jj==3)) {
			 ###$param[$ii][$jj][$kk][$l] = ($param[$ii][$jj][$kk][$l]/100.);
		     } #rain and depth are reported in hundredths, normalize that to inches and ft
		     # you already divide this param by 100 above, doing it again will render the normal file wrong -fwb-6Jul19              if ($jj==3) {$param[$ii][$jj][$kk][$l] = ($param[$ii][$jj][$kk][$l]/100.);} #depth is reported in hundredths, normalize that to ft
		     print STATS_FILE $param[$ii][$jj][$kk][$l].",";
		 }
		 print STATS_FILE "\n";
	     }
         }
         print STATS_FILE "\n";
}
close (STATS_FILE);
#### done recopy to ALLDATA_STATS.csv file

####
#50: Harmon Creek at Harmon Bluff
#51: Vernon River at Vernonburg
#52: Casey Canal at Bacon Golf 
#55: Mobile Station
####
my @orderedstationlist = qw(50 51 52);
#my @shortparamlist =qw(RAIN LIGHT TEMP DEPTH ANALOG TEMP_RTC);
my @paramlist = qw(RAIN VELO TEMP DEPTH VOLT TEMP_RTC WTR_TMP GEN_INT COND);
       open  (TABLE_FILE, ">","$savepath/ALLDATA/ALLDATA_TABLE.Sav.html") or die "Can\'t find TABLE_FILE\n";
       print TABLE_FILE "Date and Time of Analysis: $tmpmon/$mday/$year $hour:$min\n";
print TABLE_FILE "<!DOCTYPE html>\n<html>\n<head>\n<style>\ntable {\n    font-family: arial, sans-serif;\n    border-collapse: collapse;\n    width: 100%;\n}\n\ntd, th {\n     border: 1px solid #dddddd;\n    text-align: center;\n    padding: 8px;\n}\n\ntr:nth-child(even) {\n    background-color: #dddddd;\n\n}</style>\n</head>\n<body>\n";
       print TABLE_FILE "<table style=\"width:100%\">\n";
       foreach $ii (@orderedstationlist) {
	 if ($ii==50) {
	   $headerstring = "<tr><th colspan=\"18\">VERNON RIVER</tr>\n";
	     print TABLE_FILE $headerstring;
	     $mystatno = "50: Harmon Creek";
	 }			
         if ($ii==51) {
	     $mystatno = "51: Vernon River";
	 }
         if ($ii==52) {
	     $mystatno = "52: Casey Canal";
	 }
	   print TABLE_FILE "<tr><th colspan=\"2\"><th colspan=\"4\">15 MIN<th colspan=\"4\">1 HR<th colspan=\"4\">4 HR<th colspan=\"4\">24 HR</tr>\n";
	   print TABLE_FILE "<tr><th>STATION<th><th>MAX<th>MIN<th>TOTAL<th>AVE<th>MAX<th>MIN<th>TOTAL<th>AVE<th>MAX<th>MIN<th>TOTAL<th>AVE<th>MAX<th>MIN<th>TOTAL<th>AVE</tr>\n";
	   print TABLE_FILE "<th rowspan=\"10\">$mystatno"; #i dont know why its 7 instead of 6...
   
         for $jj (0 ..$#paramlist) {
           if ($jj==0) {print TABLE_FILE "<tr><td>RAIN</td>";}
           if ($jj==1) {print TABLE_FILE "<td>VELO</td>";}
           if ($jj==2) {print TABLE_FILE "<td>TEMP(F)</td>";}
           if ($jj==3) {print TABLE_FILE "<td>DEPTH(FT)</td>";}
           if ($jj==4) {print TABLE_FILE "<td>VOLTS</td>";}
           if ($jj==5) {print TABLE_FILE "<td>TEMP_RTC(F)</td>";}
           if ($jj==6) {print TABLE_FILE "<td>WTR_TMP(F)</td>";}
           if ($jj==7) {print TABLE_FILE "<td>GEN_INT</td>";}
           if ($jj==8) {print TABLE_FILE "<td>COND(SAL)</td>";}
           for ($kk=1; $kk<=4; $kk++) { #time period: 15min/1hr/4hr/24hr
             for ($l=1; $l<=4; $l++) { #stat: max/min/total/ave
#already did all of this above in the stats section, don't double-divide, etc
# and mess up the numbers		 
#               if (($param[$ii][$jj][$kk][$l]>=9999) || ($param[$ii][$jj][$kk][$l]<=-9999)) {
#		   $param[$ii][$jj][$kk][$l]=0;
#	       } #no stats were calc'ed for these time periods, set them back to 0
#               if (($jj!=0) && ($l==3)) {
#		   $param[$ii][$jj][$kk][$l] = 0;
#	       } #don't report totals for anything for anything other than rain
#     NO DONT DIVIDE AGAIN          if (($jj==0) || ($jj==3)) {
#		   $param[$ii][$jj][$kk][$l] = ($param[$ii][$jj][$kk][$l]/100.);
		 #	       } #rain and depth are reported in hundredths, normalize that to inches and ft
## in the augusta original, the stations are numbered 1..12, and so I match on station_number-1 above and then use
##  the original ii position (0..11) to print the data.  Since this is a little different, but I can use the 
##  station number-30 to get the original ii position.  Love one-offs.  -fwb-5Jul19 (watching Braves play, Millie
##  and Mom in Ohio for Patrick's wedding...)
	       if ($ii==50) {$iii=0;}
	       if ($ii==51) {$iii=1;}
	       if ($ii==52) {$iii=2;}
               printf TABLE_FILE "%s %0.2f %s", "<td>",$param[$iii][$jj][$kk][$l],"</td>"; #note this is $iii, not $ii
             }
           }
           print TABLE_FILE "</tr>\n";
         }
         print TABLE_FILE "\n";
       }
close (TABLE_FILE);

#short summary table
#my @shortparamlist =qw(RAIN LIGHT TEMP DEPTH ANALOG TEMP_RTC);
# changed to reflect Columbia County file (CC) -fwb-5Jul19
       open  (TABLE_FILE, ">","$savepath/ALLDATA/ALLDATA_TABLE_SHORT_SUMMARY.Sav.html") or die "Can\'t find TABLE_FILE\n";
       print TABLE_FILE "Date and Time of Analysis: $tmpmon/$mday/$year $hour:$min\n";
print TABLE_FILE "<!DOCTYPE html>\n<html>\n<head>\n<style>\ntable {\n    font-family: arial, sans-serif;\n    border-collapse: collapse;\n    width: 100%;\n}\n\ntd, th {\n     border: 1px solid #dddddd;\n    text-align: center;\n    padding: 8px;\n}\n\ntr:nth-child(even) {\n    background-color: #dddddd;\n\n}</style>\n</head>\n<body>\n";
       print TABLE_FILE "<table style=\"width:100%\">\n";
#       for my $ii (0 ..$#orderedstationlist) {
       foreach $ii (@orderedstationlist) {
	 if ($ii==50) {
	   $headerstring = "<tr><th colspan=\"18\">VERNON RIVER</tr>\n";
	     print TABLE_FILE $headerstring;
	     $mystatno = "50: Harmon Creek";
	 }			
         if ($ii==51) {
	     $mystatno = "51: Vernon River";
	 }
         if ($ii==52) {
	     $mystatno = "52: Casey Canal";
	 }
	   print TABLE_FILE "<tr><th colspan=\"2\"><th colspan=\"4\">15 MIN<th colspan=\"4\">1 HR<th colspan=\"4\">4 HR<th colspan=\"4\">24 HR</tr>\n";
	   print TABLE_FILE "<tr><th>STATION<th><th>MAX<th>MIN<th>TOTAL<th>AVE<th>MAX<th>MIN<th>TOTAL<th>AVE<th>MAX<th>MIN<th>TOTAL<th>AVE<th>MAX<th>MIN<th>TOTAL<th>AVE</tr>\n";
	   print TABLE_FILE "<th rowspan=\"3\">$mystatno"; #i dunno????
	 for $jj (0 ..$#paramlist) {
	     if ($jj==0) {print TABLE_FILE "<tr><td>RAIN</td>";}
	     if ($jj==1) {next; }#print TABLE_FILE "<td>VELO</td>";}
	     if ($jj==2) {next; }#print TABLE_FILE "<td>TEMP(F)</td>";}
	     if ($jj==3) {print TABLE_FILE "<td>DEPTH(FT)</td>";}
	     if ($jj==4) {next; }#print TABLE_FILE "<td>VOLTS</td>";}
	     if ($jj==5) {next; }#print TABLE_FILE "<td>TEMP_RTC(F)</td>";}
	     if ($jj==6) {next; }#print TABLE_FILE "<td>WTR_TMP(F)</td>";}
	     if ($jj==7) {next; }#print TABLE_FILE "<td>GEN_INT</td>";}
	     if ($jj==8) {next; }#print TABLE_FILE "<td>COND(SAL)</td>";}
         #for $jj (0 ..$#shortparamlist) {
         #  if ($jj==0) {print TABLE_FILE "<tr><td>RAIN</td>";}
         #  if ($jj==1) {next;}
         #  if ($jj==2) {next;}
         #  if ($jj==3) {print TABLE_FILE "<td>DEPTH(FT)</td>";}
         #  if ($jj==4) {next;}
         #  if ($jj==5) {next;}
           for ($kk=1; $kk<=4; $kk++) { #time period: 15min/1hr/4hr/24hr
             for ($l=1; $l<=4; $l++) { #stat: max/min/total/ave
#Already did the math in the stats section above
# don't double-do the math and screw up your numbers!
#               if (($param[$ii][$jj][$kk][$l]>=9999) || ($param[$ii][$jj][$kk][$l]<=-9999)) {$param[$ii][$jj][$kk][$l]=0;} #no stats were calc'ed for these time periods, set them back to 0
#               if (($jj!=0) && ($l==3)) {$param[$ii][$jj][$kk][$l] = 0;} #don't report totals for anything for anything other than rain
              # already divided...this divides again..# if (($jj==0) || ($jj==3)) {$param[$ii][$jj][$kk][$l] = ($param[$ii][$jj][$kk][$l]/100.);} #rainfall and depth are reported in hundredths, normalize that to inches and ft
## in the augusta original, the stations are numbered 1..12, and so I match on station_number-1 above and then use
#### see note above about station numbers and $ii in the original vs $iii in this version
	       if ($ii==50) {$iii=0;}
	       if ($ii==51) {$iii=1;}
	       if ($ii==52) {$iii=2;}
               printf TABLE_FILE "%s %0.2f %s","<td>",$param[$iii][$jj][$kk][$l],"</td>"; #again, this is $iii, and not $ii
             }
           }
           print TABLE_FILE "</tr>\n";
         }
         print TABLE_FILE "\n";
       }
close (TABLE_FILE);

#      print STATS_FILE "UPDATE rain_gauges_production SET rain_15m=$lastfifteen where rain_gauge like \'$stationlist[$ii]\'\;\n";
#      print STATS_FILE "UPDATE rain_gauges_production SET rain_1hr=$lasthour where rain_gauge like \'$stationlist[$ii]\'\;\n";
#      print STATS_FILE "UPDATE rain_gauges_production SET rain_4hr=$lastfourhours where rain_gauge like \'$stationlist[$ii]\'\;\n";
#      print STATS_FILE "UPDATE rain_gauges_production SET rain_24h=$lastday where rain_gauge like \'$stationlist[$ii]\'\;\n";
#      my $formatteddate = $currdate->month."/".$currdate->day."/".$currdate->year." ".$currdate->hour.":".$currdate->minute;
#      print STATS_FILE "UPDATE rain_gauges_production SET lastupdate=\'$formatteddate\' where rain_gauge like \'$stationlist[$ii]\'\;\n";
                        #now the polygon raingages
#      print STATS_FILE "UPDATE raingage_production_poly SET rain_15m=$lastfifteen where rain_gauge like \'$stationlist[$ii]\'\;\n";
#      print STATS_FILE "UPDATE raingage_production_poly SET rain_1hr=$lasthour where rain_gauge like \'$stationlist[$ii]\'\;\n";
#      print STATS_FILE "UPDATE raingage_production_poly SET rain_4hr=$lastfourhours where rain_gauge like \'$stationlist[$ii]\'\;\n";
#      print STATS_FILE "UPDATE raingage_production_poly SET rain_24h=$lastday where rain_gauge like \'$stationlist[$ii]\'\;\n";
#      print STATS_FILE "UPDATE raingage_production_poly SET lastupdate=\'$formatteddate\' where rain_gauge like \'$stationlist[$ii]\'\;\n";
#      close (STATS_FILE);
