#!/usr/bin/perl
# script designed to perform statistics on each datafile.
# should be calc'ed for all parameters:
# Station_No\RAIN, DEPTH, TEMP, TEMP_RTC, ANALOG, LIGHT
use DateTime;


($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
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
my @paramlist = qw(RAIN LIGHT TEMP DEPTH ANALOG TEMP_RTC);
my @stationlist = qw(100 200 300 400 500 600 700 800 900 10000 1100 1200);

$k=0;
for my $i (0 ..$#stationlist) {
  for my $j (0 ..$#paramlist) {
    if (-e "$savepath/$stationlist[$i]/$paramlist[$j]/$stationlist[$i]_$paramlist[$j].txt" ) {
      open (INPUT_FILE, "$savepath/$stationlist[$i]/$paramlist[$j]/$stationlist[$i]_$paramlist[$j].txt") or die "Can\'t find INPUT_FILE\n";
      $linecounter = 0;
      @linearray = (0);
      while ($_=<INPUT_FILE>) {
        if ($_ =~ /^#/) {
          next;
        }
        chomp $_;
        $linearray[$linecounter] = $_;
        $linecounter++;
      }#while input_file open and read file
      close(INPUT_FILE);
      $lastday = 0;
      $lastfourhours = 0;
      $lasthour = 0;
      $lastfifteen = 0;
      for ($k=1;$k<=4;$k++) { #set up initial conditions for max, min, total
        $param[$i][$j][$k][1] = -9999; #max reset
        $param[$i][$j][$k][2] =  9999; #min reset
        $param[$i][$j][$k][3] =    0; #total
      }
      #cycle backwards through the entries in the file looking for data within 15 minutes, 4 hours, and 24 hours.  Total them up as you find them and put them into a few variables
      for ($linecounter=$#linearray; $linecounter>0; $linecounter--) {
        #split the last entry in linearray, and determine if it's within 30 minutes of the actual time.  If not, then this station likely isn't working and set everything to -9999 (error, marked yellow, or some such).
        #Station,Date_Time,Date_Time_Adj,Rain_hundredths,Light,Temp_F,Depth_Hundredths_of_Feet,Analog,Temp_RTC_F
        #($stat, $datetimereal, $datetimefake, $rain, $light, $temp_F, $depth, $analog, $temp_rtc) = split " ",$linearray[$k];
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
        #for my $j (0 ..$#paramlist) {
        #my @paramlist = qw(RAIN, LIGHT, TEMP_F, DEPTH, ANALOG, TEMP_RTC);
        #$param[i][j][k][l]
        # i = station
        # j = parameter (rain(0), light(1), temp_f(2), depth(3), analog(4), temp_rtc(5))
        # k = time period for statistic (15min(0), hr(1), 4 hrs(2), day(3), weekly(4), bi-monthly(5), monthly(6), quarterly(7), 6-monthly(8), yearly(9))
        # l = parameter stat (0 (reserved for alerts, maybe), max(1), min(2), total(3), ave(4))
        if (($dur->seconds)>86400) {
            last;
              } #exit the loop if it's been more than a day.
        if (($dur->seconds)<= 86400) { #1day
          $k=4;
          if ($value >= $param[$i][$j][$k][1]) { $param[$i][$j][$k][1] = $value; }#max
          if ($value <= $param[$i][$j][$k][2]) { $param[$i][$j][$k][2] = $value; }#min
          $param[$i][$j][$k][3]=$param[$i][$j][$k][3] + $value; #total
          $count[$i][$j][$k]++; #for averages later
          #$lastday = $lastday+$value;
          if (($dur->seconds)<=14400) { #four hours
            $k=3;
            if ($value >= $param[$i][$j][$k][1]) { $param[$i][$j][$k][1] = $value;} #max
            if ($value <= $param[$i][$j][$k][2]) { $param[$i][$j][$k][2] = $value;} #min
            $param[$i][$j][$k][3]=$param[$i][$j][$k][3] + $value; #total
            $count[$i][$j][$k]++; #for averages later
            #$lastfourhours = $lastfourhours+$value;
            if (($dur->seconds)<= 3600) { #1 hour
              $k=2;
              if ($value >= $param[$i][$j][$k][1]) { $param[$i][$j][$k][1] = $value;} #max
              if ($value <= $param[$i][$j][$k][2]) { $param[$i][$j][$k][2] = $value;} #min
              $param[$i][$j][$k][3]=$param[$i][$j][$k][3] + $value; #total
              $count[$i][$j][$k]++; #for averages later
              #$lasthour = $lasthour+$value;
              if (($dur->seconds)< 1200) { #20 minutes, close enough to acct for a calculation cycle
                $k=1;
                if ($value >= $param[$i][$j][$k][1]) { $param[$i][$j][$k][1] = $value;} #max
                if ($value <= $param[$i][$j][$k][2]) { $param[$i][$j][$k][2] = $value;} #min
                $param[$i][$j][$k][3]=$param[$i][$j][$k][3] + $value; #total
                $count[$i][$j][$k]++; #for averages later
              #$lastfifteen = $lastfifteen+$value;
              }#15 mins
            }#1 hr
          }#4 hrs
        }#24 hrs
      }#  for ($linecounter=$#linearray; $k>0; $k--)
  }#if (-e "$savepath/$stationlist[$i]/$paramlist[$j]/$stationlist[$i]_$paramlist[$j].txt" )
      for ($k=1; $k<=4; $k++) { #calculate averages
        if ($count[$i][$j][$k]) { #make sure count is defined before trying to use it.
          if($count[$i][$j][$k]>0) {
            $param[$i][$j][$k][4] = $param[$i][$j][$k][3] / $count[$i][$j][$k];
          } #ave = total/count
        }
        else { $param[$i][$j][$k][4] = 0;} #set ave to 0
      }#k

    }#for my $j (0 ..$#paramlist)
  }#for my $i (0 ..$#stationlist)

#my @stationlist = qw(100 200 300 400 500 600 700 800 9000 10000 1100 1200 25000);

       open  (STATS_FILE, ">","$savepath/ALLDATA/ALLDATA_STATS.csv") or die "Can\'t find STATS_FILE\n";
       print STATS_FILE "Date and Time of Analysis: $datemon/$dateday/$dateyr $timehr:$timemin\n";
       for my $i (0 ..$#stationlist) {
         if ($i==0) {print STATS_FILE "STATION 1 (100)\n";}
         if ($i==1) {print STATS_FILE "STATION 2 (200)\n";}
         if ($i==2) {print STATS_FILE "STATION 3 (300)\n";}
         if ($i==3) {print STATS_FILE "STATION 4 (400)\n";}
         if ($i==4) {print STATS_FILE "STATION 5 (500)\n";}
         if ($i==5) {print STATS_FILE "STATION 6 (600)\n";}
         if ($i==6) {print STATS_FILE "STATION 7 (700)\n";}
         if ($i==7) {print STATS_FILE "STATION 8 (800)\n";}
         if ($i==8) {print STATS_FILE "STATION 9 (900)\n";}
         if ($i==9) {print STATS_FILE "STATION 10 (10000)\n";}
         if ($i==10) {print STATS_FILE "STATION 11 (1100)\n";}
         if ($i==11) {print STATS_FILE "STATION 12 (1200)\n";}
         for my $j (0 ..$#paramlist) {
           if ($j==0) {print STATS_FILE ",,,,RAIN (HUNDREDTHS OF AN INCH),,\n";}
           if ($j==1) {print STATS_FILE ",,,,LIGHT (NOT CURRENTLY ACTIVE),,\n";}
           if ($j==2) {print STATS_FILE ",,,,TEMP (DEGREES F),,\n";}
           if ($j==3) {print STATS_FILE ",,,,DEPTH (FT),,\n";}
           if ($j==4) {print STATS_FILE ",,,,ANALOG (NOT CURRENTLY ACTIVE),,\n";}
           if ($j==5) {print STATS_FILE ",,,,TEMP_RTC (DEGREES F-INSIDE BOX),,\n";}
           print STATS_FILE ",,MAX,MIN,TOTAL,AVE\n";
           for ($k=1; $k<=4; $k++) {
             if ($k==1) {print STATS_FILE ",15MIN,";}
             if ($k==2) {print STATS_FILE ",1HR,";}
             if ($k==3) {print STATS_FILE ",4HR,";}
             if ($k==4) {print STATS_FILE ",24HR,";}
             for ($l=1; $l<=4; $l++) {
               if (($param[$i][$j][$k][$l]>=9999) || ($param[$i][$j][$k][$l]<=-9999)) {$param[$i][$j][$k][$l]=0;} #no stats were calc'ed for these time periods, set them back to 0
               if (($j!=0) && ($l==3)) {$param[$i][$j][$k][$l] = 0;} #don't report totals for anything for anything other than rain
               if ($j==3) {$param[$i][$j][$k][$l] = ($param[$i][$j][$k][$l]/100.);} #depth is reported in hundredths, normalize that to ft
               print STATS_FILE $param[$i][$j][$k][$l].",";
             }
             print STATS_FILE "\n";
           }
         }
         print STATS_FILE "\n";
       }
#      print STATS_FILE "UPDATE rain_gauges_production SET rain_15m=$lastfifteen where rain_gauge like \'$stationlist[$i]\'\;\n";
#      print STATS_FILE "UPDATE rain_gauges_production SET rain_1hr=$lasthour where rain_gauge like \'$stationlist[$i]\'\;\n";
#      print STATS_FILE "UPDATE rain_gauges_production SET rain_4hr=$lastfourhours where rain_gauge like \'$stationlist[$i]\'\;\n";
#      print STATS_FILE "UPDATE rain_gauges_production SET rain_24h=$lastday where rain_gauge like \'$stationlist[$i]\'\;\n";
#      my $formatteddate = $currdate->month."/".$currdate->day."/".$currdate->year." ".$currdate->hour.":".$currdate->minute;
#      print STATS_FILE "UPDATE rain_gauges_production SET lastupdate=\'$formatteddate\' where rain_gauge like \'$stationlist[$i]\'\;\n";
                        #now the polygon raingages
#      print STATS_FILE "UPDATE raingage_production_poly SET rain_15m=$lastfifteen where rain_gauge like \'$stationlist[$i]\'\;\n";
#      print STATS_FILE "UPDATE raingage_production_poly SET rain_1hr=$lasthour where rain_gauge like \'$stationlist[$i]\'\;\n";
#      print STATS_FILE "UPDATE raingage_production_poly SET rain_4hr=$lastfourhours where rain_gauge like \'$stationlist[$i]\'\;\n";
#      print STATS_FILE "UPDATE raingage_production_poly SET rain_24h=$lastday where rain_gauge like \'$stationlist[$i]\'\;\n";
#      print STATS_FILE "UPDATE raingage_production_poly SET lastupdate=\'$formatteddate\' where rain_gauge like \'$stationlist[$i]\'\;\n";
#      close (STATS_FILE);
