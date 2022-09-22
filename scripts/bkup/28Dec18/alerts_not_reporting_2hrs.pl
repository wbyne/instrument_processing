#!/usr/bin/perl
# script designed to perform statistics on each datafile.
# should be calc'ed for all parameters:
# Station_No\RAIN, DEPTH, TEMP, TEMP_RTC, ANALOG, LIGHT
# This file inherits structure from calc_stats.pl, which is used to
#  generate sql updates.  This file only alerts when raingages
#  haven't reported in two hours.
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
my @paramlist = qw(RAIN);
my @stationlist = qw(100 200 300 400 500 600 700 800 900 10000 1100 1200);

$k=0;
for my $i (0 ..$#stationlist) {
  for my $j (0 ..$#paramlist) {
    if (-e "$savepath/$stationlist[$i]/$paramlist[$j]/$stationlist[$i]_$paramlist[$j].txt" ) {
      open (INPUT_FILE, "$savepath/$stationlist[$i]/$paramlist[$j]/$stationlist[$i]_$paramlist[$j].txt") or die "Can\'t find INPUT_FILE\n";
      while ($_=<INPUT_FILE>) {
        if ($_ =~ /^#/) {
          next;
        }
        chomp $_;
        $linearray[$linecounter] = $_;
        $linecounter++;
      }#while input_file open and read file
      close(INPUT_FILE);
      print "Found $linecounter files in station number $i\n";
      #cycle backwards through the entries in the file looking for data within 15 minutes, 4 hours, and 24 hours.  Total them up as you find them and put them into a few variables
      for ($linecounter=$#linearray; $linecounter>$#linearray-1; $linecounter--) {
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
        if (($dur->seconds)>= 7200) { #2 hours
          if ($i==0) {$station_alert[0] = "STATION 1 (100) hasn't reported in the last two hours.\n";}
          if ($i==1) {$station_alert[1] = "STATION 2 (200) hasn't reported in the last two hours.\n";}
          if ($i==2) {$station_alert[2] = "STATION 3 (300) hasn't reported in the last two hours.\n";}
          if ($i==3) {$station_alert[3] = "STATION 4 (400) hasn't reported in the last two hours.\n";}
          if ($i==4) {$station_alert[4] = "STATION 5 (500) hasn't reported in the last two hours.\n";}
          if ($i==5) {$station_alert[5] = "STATION 6 (600) hasn't reported in the last two hours.\n";}
          if ($i==6) {$station_alert[6] = "STATION 7 (700) hasn't reported in the last two hours.\n";}
          if ($i==7) {$station_alert[7] = "STATION 8 (800) hasn't reported in the last two hours.\n";}
          if ($i==8) {$station_alert[8] = "STATION 9 (900) hasn't reported in the last two hours.\n";}
          if ($i==9) {$station_alert[9] = "STATION 10 (10000) hasn't reported in the last two hours.\n";}
          if ($i==10) {$station_alert[10] = "STATION 11 (1100) hasn't reported in the last two hours.\n";}
          if ($i==11) {$station_alert[11] = "STATION 12 (1200) hasn't reported in the last two hours.\n";}
          print "An alert was tripped in the duration calculation\n";
        }#24 hrs
      }#  for ($linecounter=$#linearray; $k>0; $k--)
    }#if (-e "$savepath/$stationlist[$i]/$paramlist[$j]/$stationlist[$i]_$paramlist[$j].txt" )
  }#for my $j (0 ..$#paramlist)
}#for my $i (0 ..$#stationlist)

#my @stationlist = qw(100 200 300 400 500 600 700 800 9000 10000 1100 1200 25000);
#mailx -s "$SUBJECT" $EMAIL < $MAILFILE
for $i (0 ..$#stationlist) {
  if ($station_alert[$i]) {
    $build_alert_file = 1;
    last; #no need to continue, we need to send an email
  }
  else {
    $build_alert_file = 0;
  }
}
print "Build_Alert_File has a status of: $build_alert_file\n";
if ($build_alert_file == 1) {
  open  (STATS_FILE, ">","$savepath/ALLDATA/ALLDATA_ALERTS.txt") or die "Can\'t find STATS_FILE\n";
  $mon=$mon+1;
  print "Date and Time of Alert: $mon/$mday/$year $hour:$min\n";
  print STATS_FILE "Date and Time of Alert: $mon/$mday/$year $hour:$min\n";
  for $i (0 ..$#stationlist) {
    if ($station_alert[$i]) {
      print "$station_alert[$i]";
      print STATS_FILE "$station_alert[$i]";
    }
  }
  close STATS_FILE;
  $MAILFILE = "$savepath/ALLDATA/ALLDATA_ALERTS.txt";
  $EMAILTO = 'fbyne@watergeorgia.com matt.erickson@phinizycenter.org';
  $SUBJECT = 'RAINGAGE_NOT_REPORTING';
  $EMAILFROM = 'admin@watergeorgia.com';
  system ("mailx -r $EMAILFROM -s $SUBJECT $EMAILTO < $MAILFILE");
  print "Just tried to send email\n";
}
print "Done with alerts file\n";
