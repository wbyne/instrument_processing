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
use DateTime;

$reporting_period = $ARGV[0];
# k = time period for statistic (15min(0), hr(1), 4 hrs(2), day(3), weekly(4), bi-monthly(5), monthly(6), quarterly(7), 6-monthly(8), yearly(9)) 1200,3600,14400,86400,604800 (week), 1209600 (biweekly), 2419200 (monthly), 7257600 (quarterly (12 weeks)), 14515200 (6-months (24 weeks)), 29030400 (yearly (48 weeks))
if (! defined $reporting_period) { #if no period is requested, then run a daily report
    $reporting_period = 3;
}
if ($reporting_period>7) {
    print "ERROR, REPORTING PERIOD IS TOO LONG\n";
    exit 99;
}
if ($reporting_period == 0) {
    $seconds_of_report = 1200;
    $kkmax = 1;
}
if ($reporting_period == 1) {
    $seconds_of_report = 3600;
    $kkmax = 2;
}
if ($reporting_period == 2) {
    $seconds_of_report = 14400;
    $kkmax = 3;
}
if ($reporting_period == 3) {
    $seconds_of_report = 86400;
    $kkmax = 4;
}
if ($reporting_period == 4) {
    $seconds_of_report = 604800;
    $kkmax = 5;
}
if ($reporting_period == 5) {
    $seconds_of_report = 1209600;
    $kkmax = 6;
}
if ($reporting_period == 6) {
    $mon_for_ave = $ARGV[1];
    if (! defined $mon_for_ave) {
	$seconds_of_report = 2419200;
    }
    if ($mon_for_ave == 1) { #31 days
	$seconds_of_report = 2678400;
    }
    if ($mon_for_ave == 2) {#28 days
	$seconds_of_report = 2419200;
    }
    if ($mon_for_ave == 3) { #31 days
	$seconds_of_report = 2678400;
    }
    if ($mon_for_ave == 4) { #30 days
	$seconds_of_report = 2592000;
    }
    if ($mon_for_ave == 5) { #31 days
	$seconds_of_report = 2678400;
    }
    if ($mon_for_ave == 6) { #30 days
	$seconds_of_report = 2592000;
    }
    if ($mon_for_ave == 7) { #31 days
	$seconds_of_report = 2678400;
    }
    if ($mon_for_ave == 8) { #31 days
	$seconds_of_report = 2678400;
    }
    if ($mon_for_ave == 9) { #30 days
	$seconds_of_report = 2592000;
    }
    if ($mon_for_ave == 10) { #31 days
	$seconds_of_report = 2678400;
    }
    if ($mon_for_ave == 11) { #30 days
	$seconds_of_report = 2592000;
    }
    if ($mon_for_ave == 12) { #31 days
	$seconds_of_report = 2678400;
    }
    
    $kkmax = 7;
}
if ($reporting_period == 7) {
    $seconds_of_report = 7257600;
    $kkmax = 8;
}


($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$iisdst) = localtime(time);
my @abbr = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
print "$abbr[$mon] $mday\n";
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
my @paramlist = qw(RAIN LIGHT TEMP DEPTH ANALOG TEMP_RTC);
my @stationlist = qw(100 200 300 400 500 600 700 800 900 10000 1100 1200);


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
      for ($kk=1;$kk<=$kkmax;$kk++) { #set up initial conditions for max, min, total
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
	  if ($jj==5) { #we're reading TEMP_RTC, which apparently has a problem with negative values, and ends up overflowing the int
	      if ($value > 150) {
		  $value = 0;
	      }
	  }
        #($datedate, $timetime) = split " ",$datetimefake;
        ($datemon, $dateday, $dateyr) = split "\/",$datedate;
        $dateyr=2000+$dateyr; #correct for 4 year type.  This script will be good until the year 3000.
        ($timehr, $timemin) = split ":",$timetime;
        #convert to datetime object:
	  #try {
	      $evaldate = DateTime->new(
		  year      => $dateyr,
		  month     => $datemon,
		  day       => $dateday,
		  hour      => $timehr,
		  minute    => $timemin,
		  time_zone => "America/New_York",
		  );
	  #}
	  #catch {
	  #    print STDOUT "Error occurred at $stationlist[$jj] $paramlist[$jj] $dateyr $datemon $dateday $timehr $timemin\n";
	  #    exit;
	  #}
        #my $dur = $currdate->subtract_datetime($evaldate); if you access the methods from this one, it will return minutes in "less than one hour" format...gets strange, just use the absolute version.
        my $dur = $currdate->subtract_datetime_absolute( $evaldate );
        #for my $jj (0 ..$#paramlist) {
        #my @paramlist = qw(RAIN, LIGHT, TEMP_F, DEPTH, ANALOG, TEMP_RTC);
        #$param[i][j][k][l]
        # i = station
        # j = parameter (rain(0), light(1), temp_f(2), depth(3), analog(4), temp_rtc(5))
        # k = time period for statistic (15min(0), hr(1), 4 hrs(2), day(3), weekly(4), bi-monthly(5), monthly(6), quarterly(7), 6-monthly(8), yearly(9))
        # l = parameter stat (0 (reserved for alerts, maybe), max(1), min(2), total(3), ave(4))
	#k>604800 (week), 1209600 (biweekly), 2419200 (monthly), 7257600 (quarterly (12 weeks)), 14515200 (6-months (24 weeks)), 29030400 (yearly (48 weeks))
	if (($dur->seconds)>$seconds_of_report) {
	    last;
	}
	  #YOU CANNOT CHANGE THIS STRUCTURE, IT IS NOT REDUNDANT.  EACH LARGER TIME COUNTS EACH TIME BELOW IT.
	  if (($dur->seconds)<= 7257600) { #quarterly
	      $kk=8;
	      if ($value >= $param[$ii][$jj][$kk][1]) { $param[$ii][$jj][$kk][1] = $value;} #max
	      if ($value <= $param[$ii][$jj][$kk][2]) { $param[$ii][$jj][$kk][2] = $value;} #min
	      $param[$ii][$jj][$kk][3]=$param[$ii][$jj][$kk][3] + $value; #total
	      $count[$ii][$jj][$kk]++; #for averages later

	      if (($dur->seconds)<= 2419200) { #4 weeks
		  $kk=7;
		  if ($value >= $param[$ii][$jj][$kk][1]) { $param[$ii][$jj][$kk][1] = $value;} #max
		  if ($value <= $param[$ii][$jj][$kk][2]) { $param[$ii][$jj][$kk][2] = $value;} #min
		  $param[$ii][$jj][$kk][3]=$param[$ii][$jj][$kk][3] + $value; #total
		  $count[$ii][$jj][$kk]++; #for averages later

		  if (($dur->seconds)<= 1209600) { #2 weeks
		      $kk=6;
		      if ($value >= $param[$ii][$jj][$kk][1]) { $param[$ii][$jj][$kk][1] = $value;} #max
		      if ($value <= $param[$ii][$jj][$kk][2]) { $param[$ii][$jj][$kk][2] = $value;} #min
		      $param[$ii][$jj][$kk][3]=$param[$ii][$jj][$kk][3] + $value; #total
		      $count[$ii][$jj][$kk]++; #for averages later

		      if (($dur->seconds)<= 604800) { #7days
			  $kk=5;
			  if ($value >= $param[$ii][$jj][$kk][1]) { $param[$ii][$jj][$kk][1] = $value;} #max
			  if ($value <= $param[$ii][$jj][$kk][2]) { $param[$ii][$jj][$kk][2] = $value;} #min
			  $param[$ii][$jj][$kk][3]=$param[$ii][$jj][$kk][3] + $value; #total
			  $count[$ii][$jj][$kk]++; #for averages later

			  if (($dur->seconds)<= 86400) { #1day
			      $kk=4;
			      if ($value >= $param[$ii][$jj][$kk][1]) { $param[$ii][$jj][$kk][1] = $value;} #max
			      if ($value <= $param[$ii][$jj][$kk][2]) { $param[$ii][$jj][$kk][2] = $value;} #min
			      $param[$ii][$jj][$kk][3]=$param[$ii][$jj][$kk][3] + $value; #total
			      $count[$ii][$jj][$kk]++; #for averages later

			      if (($dur->seconds)<=14400) { #four hours
				  $kk=3;
				  if ($value >= $param[$ii][$jj][$kk][1]) { $param[$ii][$jj][$kk][1] = $value;} #max
				  if ($value <= $param[$ii][$jj][$kk][2]) { $param[$ii][$jj][$kk][2] = $value;} #min
				  $param[$ii][$jj][$kk][3]=$param[$ii][$jj][$kk][3] + $value; #total
				  $count[$ii][$jj][$kk]++; #for averages later

				  if (($dur->seconds)<= 3600) { #1 hour
				      $kk=2;
				      if ($value >= $param[$ii][$jj][$kk][1]) { $param[$ii][$jj][$kk][1] = $value;} #max
				      if ($value <= $param[$ii][$jj][$kk][2]) { $param[$ii][$jj][$kk][2] = $value;} #min
				      $param[$ii][$jj][$kk][3]=$param[$ii][$jj][$kk][3] + $value; #total
				      $count[$ii][$jj][$kk]++; #for averages later

				      if (($dur->seconds)< 1200) { #20 minutes, close enough to acct for a calculation cycle
					  $kk=1;
					  if ($value >= $param[$ii][$jj][$kk][1]) { $param[$ii][$jj][$kk][1] = $value;} #max
					  if ($value <= $param[$ii][$jj][$kk][2]) { $param[$ii][$jj][$kk][2] = $value;} #min
					  $param[$ii][$jj][$kk][3]=$param[$ii][$jj][$kk][3] + $value; #total
					  $count[$ii][$jj][$kk]++; #for averages later

				      }#15 mins
				  }#1 hr
			      }#4 hrs
			  }#24 hrs
		      }#week
		  }#2 weeks
	      }#4 weeks
	  }#quarterly
      }#  for ($linecounter=$#linearray; $kk>0; $kk--)
  }#if (-e "$savepath/$stationlist[$ii]/$paramlist[$jj]/$stationlist[$ii]_$paramlist[$jj].txt" )
      for ($kk=1; $kk<=$kkmax; $kk++) { #calculate averages
        if ($count[$ii][$jj][$kk]) { #make sure count is defined before trying to use it.
          if($count[$ii][$jj][$kk]>0) {
            $param[$ii][$jj][$kk][4] = $param[$ii][$jj][$kk][3] / $count[$ii][$jj][$kk];
          } #ave = total/count
        }
        else { $param[$ii][$jj][$kk][4] = 0;} #set ave to 0
      }#k

    }#for my $jj (0 ..$#paramlist)
  }#for my $ii (0 ..$#stationlist)

#my @stationlist = qw(100 200 300 400 500 600 700 800 9000 10000 1100 1200 25000);

       open  (STATS_FILE, ">","$savepath/ALLDATA/ALLDATA_STATS_long_term.csv") or die "Can\'t find STATS_FILE\n";
my $tmpmon = $mon+1;
       print STATS_FILE "Date and Time of Analysis: $tmpmon/$mday/$year $hour:$min\n";
       for $ii (0 ..$#stationlist) {
         if ($ii==0) {print STATS_FILE "STATION 1 (100)\n";}
         if ($ii==1) {print STATS_FILE "STATION 2 (200)\n";}
         if ($ii==2) {print STATS_FILE "STATION 3 (300)\n";}
         if ($ii==3) {print STATS_FILE "STATION 4 (400)\n";}
         if ($ii==4) {print STATS_FILE "STATION 5 (500)\n";}
         if ($ii==5) {print STATS_FILE "STATION 6 (600)\n";}
         if ($ii==6) {print STATS_FILE "STATION 7 (700)\n";}
         if ($ii==7) {print STATS_FILE "STATION 8 (800)\n";}
         if ($ii==8) {print STATS_FILE "STATION 9 (900)\n";}
         if ($ii==9) {print STATS_FILE "STATION 10 (10000)\n";}
         if ($ii==10) {print STATS_FILE "STATION 11 (1100)\n";}
         if ($ii==11) {print STATS_FILE "STATION 12 (1200)\n";}
         for $jj (0 ..$#paramlist) {
           if ($jj==0) {print STATS_FILE ",,,,RAIN (HUNDREDTHS OF AN INCH),,\n";}
           if ($jj==1) {print STATS_FILE ",,,,LIGHT (NOT CURRENTLY ACTIVE),,\n";}
           if ($jj==2) {print STATS_FILE ",,,,TEMP (DEGREES F),,\n";}
           if ($jj==3) {print STATS_FILE ",,,,DEPTH (FT),,\n";}
           if ($jj==4) {print STATS_FILE ",,,,ANALOG (NOT CURRENTLY ACTIVE),,\n";}
           if ($jj==5) {print STATS_FILE ",,,,TEMP_RTC (DEGREES F-INSIDE BOX),,\n";}
           print STATS_FILE ",,MAX,MIN,TOTAL,AVE\n";
           for ($kk=1; $kk<=$kkmax; $kk++) {
             if ($kk==1) {print STATS_FILE ",15MIN,";}
             if ($kk==2) {print STATS_FILE ",1HR,";}
             if ($kk==3) {print STATS_FILE ",4HR,";}
             if ($kk==4) {print STATS_FILE ",24HR,";}
             if ($kk==5) {print STATS_FILE ",7DY,";}
             if ($kk==6) {print STATS_FILE ",14DY,";}
             if ($kk==7) {
	     if (! defined $mon_for_ave) {
		 print STATS_FILE ",28DY,";
	     }
	     else {
		 print STATS_FILE ",MON,";}
	     }
             if ($kk==8) {print STATS_FILE ",QTR(84DY),";}
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


######################
#  Build HTML file
######################

#my @orderedstationlist = qw(10000 200 100 900 300 1200 700 500 600 1100 400 800);
#my @stationlist = qw(100 200 300 400 500 600 700 800 900 10000 1100 1200);
my @orderedstationlist = qw(9 1 0 8 2 11 6 4 5 10 3 7);
#my @orderedstationlist = qw(10000 200 100 900 300 1200 700 500 600 1100 400 800);
my @shortparamlist =qw(RAIN LIGHT TEMP DEPTH ANALOG TEMP_RTC);
my @dateheaderarray = qw(15MIN 1HR 4HR 24HR 7DY 14DY MON QTR);
       open  (TABLE_FILE, ">","$savepath/ALLDATA/ALLDATA_TABLE_long_term.html") or die "Can\'t find TABLE_FILE\n";
       print TABLE_FILE "Date and Time of Analysis: $tmpmon/$mday/$year $hour:$min\n";
print TABLE_FILE "<!DOCTYPE html>\n<html>\n<head>\n<style>\ntable {\n    font-family: arial, sans-serif;\n    border-collapse: collapse;\n    width: 100%;\n}\n\ntd, th {\n     border: 1px solid #dddddd;\n    text-align: center;\n    padding: 8px;\n}\n\ntr:nth-child(even) {\n    background-color: #dddddd;\n\n}</style>\n</head>\n<body>\n";
print TABLE_FILE "<table style=\"width:100%\">\n";
$mycolspan = ($kkmax*4)+2;
       foreach $ii (@orderedstationlist) {
	   if ($ii==9) {
	       $headerstring = "<tr><th colspan=\"$mycolspan\">ROCK CREEK</tr>\n";
	       print TABLE_FILE $headerstring;
	       $mystatno = "10 (10000)";
	   }			
         if ($ii==1) {
	     $mystatno = " 2 (200)";
	 }
         if ($ii==0) {
	     $headerstring = "<tr><th colspan=\"$mycolspan\">RAE'S and CRANE CREEK</tr>\n";
	     print TABLE_FILE $headerstring;
	     $mystatno = " 1 (100)";
	 }
         if ($ii==8) {
	     $mystatno = " 9 (900)";
	 }
         if ($ii==2) {
	     $mystatno = " 3 (300)";
	 }
         if ($ii==11) {
	     $mystatno = "12 (1200)";
	 }
         if ($ii==6) {
	     $headerstring = "<tr><th colspan=\"$mycolspan\">DOWNTOWN and EAST AUGUSTA</tr>\n";
	     print TABLE_FILE $headerstring;
	     $mystatno = " 7 (700)";
	 }
         if ($ii==4) {
	     $mystatno = " 5 (500)";
	 }
         if ($ii==5) {
	     $headerstring = "<tr><th colspan=\"$mycolspan\">OATES CREEK</tr>\n";
	     print TABLE_FILE $headerstring;
	     $mystatno = " 6 (600)";
	 }
         if ($ii==10) {
	     $headerstring = "<tr><th colspan=\"$mycolspan\">BUTLER CREEK</tr>\n";
	     print TABLE_FILE $headerstring;
	     $mystatno = "11 (1100)";
	 }
         if ($ii==3) {
	     $headerstring = "<tr>\n<th colspan=\"$mycolspan\">SPIRIT CREEK</tr>\n";
	     print TABLE_FILE $headerstring;
	     $mystatno = " 4 (400)";
	 }
         if ($ii==7) {
	     $mystatno = " 8 (800)";
	 }
	   for ($jk=0;$jk<$kkmax;$jk++) {#from 0 to < b/c we're using a index that starts from 1...i know I need to be consistent.
	       if ($jk == 0) {
		   $tmpstring = '<tr><th colspan="2">';
		   $tmpstring2 = '<tr><th>STATION<th>';
	       }
	       $tmpstring = $tmpstring.'<th colspan="4">'.$dateheaderarray[$jk];
	       $tmpstring2 = $tmpstring2.'<th>MAX<th>MIN<th>TOTAL<th>AVE';
	       if ($jk == ($kkmax-1)) {
		   $tmpstring = $tmpstring.'</tr>'."\n";
		   $tmpstring2 = $tmpstring2.'</tr>'."\n";
	       }
#	   print TABLE_FILE "<tr><th colspan=\"2\"><th colspan=\"4\">15 MIN<th colspan=\"4\">1 HR<th colspan=\"4\">4 HR<th colspan=\"4\">24 HR</tr>\n";
#	   print TABLE_FILE "<tr><th>STATION<th><th>MAX<th>MIN<th>TOTAL<th>AVE<th>MAX<th>MIN<th>TOTAL<th>AVE<th>MAX<th>MIN<th>TOTAL<th>AVE<th>MAX<th>MIN<th>TOTAL<th>AVE</tr>\n";
	   }
	   print TABLE_FILE $tmpstring;
	   print TABLE_FILE $tmpstring2;
	   print TABLE_FILE "<th rowspan=\"7\">$mystatno"; #i dont know why its 7 instead of 6...
   
         for $jj (0 ..$#shortparamlist) {
           if ($jj==0) {print TABLE_FILE "<tr><td>RAIN</td>";}
           if ($jj==1) {print TABLE_FILE "<td>LIGHT</td>";}
           if ($jj==2) {print TABLE_FILE "<td>TEMP(F)</td>";}
           if ($jj==3) {print TABLE_FILE "<td>DEPTH(FT)</td>";}
           if ($jj==4) {print TABLE_FILE "<td>ANALOG</td>";}
           if ($jj==5) {print TABLE_FILE "<td>TEMP_RTC(F)</td>";}
           for ($kk=1; $kk<=$kkmax; $kk++) { #time period: 15min/1hr/4hr/24hr/7DY/14DY/28DY(MON)/84DY(QTR)
             for ($l=1; $l<=4; $l++) { #stat: max/min/total/ave
               printf TABLE_FILE "%s %0.2f %s", "<td>",$param[$ii][$jj][$kk][$l],"</td>";
             }
           }
           print TABLE_FILE "</tr>\n";
         }
         print TABLE_FILE "\n";
       }
print TABLE_FILE "</table>\n</body>\n</html>\n";
close (TABLE_FILE);

#short summary table
#my @orderedstationlist = qw(10000 200 100 900 300 1200 700 500 600 1100 400 800);
my @shortparamlist =qw(RAIN LIGHT TEMP DEPTH ANALOG TEMP_RTC);
       open  (TABLE_FILE, ">","$savepath/ALLDATA/ALLDATA_TABLE_SHORT_SUMMARY_long_term.html") or die "Can\'t find TABLE_FILE\n";
       print TABLE_FILE "Date and Time of Analysis: $tmpmon/$mday/$year $hour:$min\n";
print TABLE_FILE "<!DOCTYPE html>\n<html>\n<head>\n<style>\ntable {\n    font-family: arial, sans-serif;\n    border-collapse: collapse;\n    width: 100%;\n}\n\ntd, th {\n     border: 1px solid #dddddd;\n    text-align: center;\n    padding: 8px;\n}\n\ntr:nth-child(even) {\n    background-color: #dddddd;\n\n}</style>\n</head>\n<body>\n";
       print TABLE_FILE "<table style=\"width:100%\">\n";
#       for my $ii (0 ..$#orderedstationlist) {
       foreach $ii (@orderedstationlist) {
	   if ($ii==9) {
	       $headerstring = "<tr><th colspan=\"$mycolspan\">ROCK CREEK</tr>\n";
	       print TABLE_FILE $headerstring;
	       $mystatno = "10 (10000)";
	   }			
         if ($ii==1) {
	     $mystatno = " 2 (200)";
	 }
         if ($ii==0) {
	     $headerstring = "<tr><th colspan=\"$mycolspan\">RAE'S and CRANE CREEK</tr>\n";
	     print TABLE_FILE $headerstring;
	     $mystatno = " 1 (100)";
	 }
         if ($ii==8) {
	     $mystatno = " 9 (900)";
	 }
         if ($ii==2) {
	     $mystatno = " 3 (300)";
	 }
         if ($ii==11) {
	     $mystatno = "12 (1200)";
	 }
         if ($ii==6) {
	     $headerstring = "<tr><th colspan=\"$mycolspan\">DOWNTOWN and EAST AUGUSTA</tr>\n";
	     print TABLE_FILE $headerstring;
	     $mystatno = " 7 (700)";
	 }
         if ($ii==4) {
	     $mystatno = " 5 (500)";
	 }
         if ($ii==5) {
	     $headerstring = "<tr><th colspan=\"$mycolspan\">OATES CREEK</tr>\n";
	     print TABLE_FILE $headerstring;
	     $mystatno = " 6 (600)";
	 }
         if ($ii==10) {
	     $headerstring = "<tr><th colspan=\"$mycolspan\">BUTLER CREEK</tr>\n";
	     print TABLE_FILE $headerstring;
	     $mystatno = "11 (1100)";
	 }
         if ($ii==3) {
	     $headerstring = "<tr><th colspan=\"$mycolspan\">SPIRIT CREEK</tr>\n";
	     print TABLE_FILE $headerstring;
	     $mystatno = " 4 (400)";
	 }
         if ($ii==7) {
	     $mystatno = " 8 (800)";
	 }
	   for ($jk=0;$jk<$kkmax;$jk++) {#from 0 to < b/c we're using a index that starts from 1...i know I need to be consistent.
	       if ($jk == 0) {
		   $tmpstring = '<tr><th colspan="2">';
		   $tmpstring2 = '<tr><th>STATION<th>';
	       }
	       $tmpstring = $tmpstring.'<th colspan="4">'.$dateheaderarray[$jk];
	       $tmpstring2 = $tmpstring2.'<th>MAX<th>MIN<th>TOTAL<th>AVE';
	       if ($jk == ($kkmax-1)) {
		   $tmpstring = $tmpstring.'</tr>'."\n";
		   $tmpstring2 = $tmpstring2.'</tr>'."\n";
	       }
#	   print TABLE_FILE "<tr><th colspan=\"2\"><th colspan=\"4\">15 MIN<th colspan=\"4\">1 HR<th colspan=\"4\">4 HR<th colspan=\"4\">24 HR</tr>\n";
#	   print TABLE_FILE "<tr><th>STATION<th><th>MAX<th>MIN<th>TOTAL<th>AVE<th>MAX<th>MIN<th>TOTAL<th>AVE<th>MAX<th>MIN<th>TOTAL<th>AVE<th>MAX<th>MIN<th>TOTAL<th>AVE</tr>\n";
	   }
	   print TABLE_FILE $tmpstring;
	   print TABLE_FILE $tmpstring2;
	   print TABLE_FILE "<th rowspan=\"3\">$mystatno"; #i dunno????
   
         for $jj (0 ..$#shortparamlist) {
           if ($jj==0) {print TABLE_FILE "<tr><td>RAIN</td>";}
           if ($jj==1) {next;}
           if ($jj==2) {next;}
           if ($jj==3) {print TABLE_FILE "<td>DEPTH(FT)</td>";}
           if ($jj==4) {next;}
           if ($jj==5) {next;}
           for ($kk=1; $kk<=$kkmax; $kk++) { #time period: 15min/1hr/4hr/24hr
             for ($l=1; $l<=4; $l++) { #stat: max/min/total/ave
               printf TABLE_FILE "%s %0.2f %s","<td>",$param[$ii][$jj][$kk][$l],"</td>";
             }
           }
           print TABLE_FILE "</tr>\n";
         }
         print TABLE_FILE "\n";
}
print TABLE_FILE "</table>\n</body>\n</html>\n";
close (TABLE_FILE);

