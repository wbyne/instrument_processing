#!/usr/bin/perl
#this script is designed to find all rain events with a specified inter-event period, and 
# record their start time, stop time, and rain volume.

#open rainfall file, read each line. 
# opening, set raining = 0; lastraintime = 0; rainstarttime and rainstartposition = 0
# is it raining: 	N, is lastraintime=0? Y->raining=0, N->more than one hour since lastraintime (count events)? Y->lastraintime = 0; raining = 0; N->lastraintime is unchanged, raining = 0; ; 
#   			Y->if lastraintime = 0, lastraintime=currenttime, set rainstarttime, rainstartposition
# 

use DateTime;

my $lastraintime = 0;
my @rainstarttime = ();
my @rainstartlineno = ();
my @rainstoptime = ();
my @rainstoplineno = ();
my @rainvolume = ();
my @timeseries = ();

$savepath = "/mnt/space/workspace/instrument_processing/data/site";
my @paramlist = qw(RAIN); #LIGHT TEMP DEPTH ANALOG TEMP_RTC);
my @stationlist = qw(100 200 300 400 500 600 700 800 900 10000 1100 1200);

for $ii (0 ..$#stationlist) {
    for $jj (0 ..$#paramlist) {
	$kk = 0;
	$ll = 0;
      $lastraintime = 0;
      $rainstarttime[$ii][$jj][$kk] = 0;
      $rainstartlineno[$ii][$jj][$kk] = 0;
      $rainstoptime[$ii][$jj][$kk] = 0;
      $rainstoplineno[$ii][$jj][$kk] = 0;
      $rainvolume[$ii][$jj][$kk] = 0;

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

      for ($linecounter=0; $linecounter<=$#linearray; $linecounter++) {
		      #split the entry in linearray
		      ($stat, $param, $datedate, $timetime, $value) = split " ",$linearray[$linecounter];
		      if ($value > 0) {
			  if ($lastraintime == 0) {
			      $rainstarttime[$ii][$jj][$kk] = $datedate." ".$timetime;
			      $rainstartlineno[$ii][$jj][$kk] = $linecounter;
			  }
			  $lastraintime = $datedate." ".$timetime;
			  $rainvolume[$ii][$jj][$kk] = $rainvolume[$ii][$jj][$kk]+$value;
			  $timeseries[$ii][$jj][$kk][$ll] =  $datedate." ".$timetime." ".$value;
			  $ll++;
		      }
		      if ($value == 0) {
			  if ($lastraintime == 0) {
			      #nothing to see here, move along
			  }
			  if ($lastraintime != 0) {
			      #construct evaluation date:
			      ($dateeval,$timeeval) = split " ",$lastraintime;
      			      ($datemon, $dateday, $dateyr) = split "\/",$dateeval;
			      $dateyr=2000+$dateyr; #correct for 4 year type.  This script will be good until the year 3000.
			      ($timehr, $timemin) = split ":",$timeeval;
			      #convert to datetime object:
			      $evaldate = DateTime->new(
				  year      => $dateyr,
				  month     => $datemon,
				  day       => $dateday,
				  hour      => $timehr,
				  minute    => $timemin,
				  time_zone => "America/New_York",
				  );

      			      #construct current date/time:
			      ($datemon, $dateday, $dateyr) = split "\/",$datedate;
			      $dateyr=2000+$dateyr; #correct for 4 year type.  This script will be good until the year 3000.
			      ($timehr, $timemin) = split ":",$timetime;
			      #convert to datetime object:
			      $currdate = DateTime->new(
				  year      => $dateyr,
				  month     => $datemon,
				  day       => $dateday,
				  hour      => $timehr,
				  minute    => $timemin,
				  time_zone => "America/New_York",
				  );

			      #my $dur = $currdate->subtract_datetime($evaldate); if you access the methods from this one, it will return minutes in "less than one hour" format...gets strange, just use the absolute version.
			      my $dur = $currdate->subtract_datetime_absolute( $evaldate );

			      if (($dur->seconds)>3600) { #it's been more than an hour with no rain
				  if (($dur->seconds)>10800) { #it's been more than 3 hours between data points.  This probably means that there's missing data.  Recalculate the stop time using the previous data entry to prevent crazy durations.
				      ($stat, $param, $datedate, $timetime, $value) = split " ",$linearray[$linecounter-1];
				      $rainstoptime[$ii][$jj][$kk] = $datedate." ".$timetime;
				      $rainstoplineno[$ii][$jj][$kk] = ($linecounter-1);
				  }
				  else {   
				      $rainstoptime[$ii][$jj][$kk] = $datedate." ".$timetime;
				      $rainstoplineno[$ii][$jj][$kk] = $linecounter;
				  }
				      $lastraintime = 0;
				      $kk++;
				      $ll = 0;
			      }
			      else {
				  $timeseries[$ii][$jj][$kk][$ll] = $datedate." ".$timetime." ".$value;
				  $ll++;
			      }
			  }#lastraintime = 0
		      }#if value == 0
		  }#  for ($linecounter=$#linearray; $kk>0; $kk--)
	      }#if (-e "$savepath/$stationlist[$ii]/$paramlist[$jj]/$stationlist[$ii]_$paramlist[$jj].txt" )
	  }#for my $jj (0 ..$#paramlist)
      }#for my $ii (0 ..$#stationlist)

print STDOUT "$kk\n";
print STDOUT "$kk\n";

for $ii (0 ..$#stationlist) {
    for $jj (0 ..$#paramlist) {
	#$kk = 0;
	$ll = 0;
	open (INPUT_FILE,">", "$savepath/$stationlist[$ii]/$paramlist[$jj]/$stationlist[$ii]_$paramlist[$jj]_summary.csv") or die "Can\'t find INPUT_FILE\n";
	print INPUT_FILE "#Start_Time\tStop_Time\tDuration_Mins\tStart_Line_No\tStop_Line_No\tRain_Vol\tHyetographs\n";
	for $kk (0 .. $#{$rainstarttime[$ii][$jj]}) {
	    #construct evaluation date:
	    ($dateeval,$timeeval) = split " ",$rainstarttime[$ii][$jj][$kk];
	    ($datemon, $dateday, $dateyr) = split "\/",$dateeval;
	    $dateyr=2000+$dateyr; #correct for 4 year type.  This script will be good until the year 3000.
	    ($timehr, $timemin) = split ":",$timeeval;
	    #convert to datetime object:
	    $evaldate = DateTime->new(
		year      => $dateyr,
		month     => $datemon,
		day       => $dateday,
		hour      => $timehr,
		minute    => $timemin,
		time_zone => "America/New_York",
		);

	    #construct current date/time:
	    ($datedate,$timetime) = split " ",$rainstoptime[$ii][$jj][$kk];
	    ($datemon, $dateday, $dateyr) = split "\/",$datedate;;
	    $dateyr=2000+$dateyr; #correct for 4 year type.  This script will be good until the year 3000.
	    ($timehr, $timemin) = split ":",$timetime;
	    #convert to datetime object:
	    $currdate = DateTime->new(
		year      => $dateyr,
		month     => $datemon,
		day       => $dateday,
		hour      => $timehr,
		minute    => $timemin,
		time_zone => "America/New_York",
		);

	    my $dur = $currdate->subtract_datetime_absolute( $evaldate );
	    #if (($dur->seconds)>3600) { #it's been more than an hour with no rain
		$elapsed_time = ($dur->seconds)/60;		  
	    print INPUT_FILE "$rainstarttime[$ii][$jj][$kk]\t$rainstoptime[$ii][$jj][$kk]\t$elapsed_time\t$rainstartlineno[$ii][$jj][$kk]\t$rainstoplineno[$ii][$jj][$kk]\t$rainvolume[$ii][$jj][$kk]\t";
	    print STDOUT "$rainstarttime[$ii][$jj][$kk]\t$rainstoptime[$ii][$jj][$kk]\t$elapsed_time\t$rainstartlineno[$ii][$jj][$kk]\t$rainstoplineno[$ii][$jj][$kk]\t$rainvolume[$ii][$jj][$kk]\t";

    	    for $ll (0 .. $#{$timeseries[$ii][$jj][$kk]}) {
		(@tmp) = split " ",$timeseries[$ii][$jj][$kk][$ll];
		print INPUT_FILE "$tmp[2]\t";
		print STDOUT "$tmp[2]\t";
	    }
	    print INPUT_FILE "\n";
	    print STDOUT "\n";
	}
	print INPUT_FILE "#No of Events: $#{$rainstarttime[$ii][$jj]}\n $#{$rainstarttime[$ii][$jj]}\n";
	print STDOUT "#No of Events: $#{$rainstarttime[$ii][$jj]}\n $#{$rainstarttime[$ii][$jj]}\n";
	for $kk (0 .. $#{$rainstarttime[$ii][$jj]}) {
	    print INPUT_FILE "\n\n";
	    print STDOUT "\n\n";
	    for $ll (0 .. $#{$timeseries[$ii][$jj][$kk]}) {
		(@tmp) = split " ",$timeseries[$ii][$jj][$kk][$ll];
		print INPUT_FILE "$tmp[0] $tmp[1] $kk $tmp[2]\n";
		print STDOUT     "$tmp[0] $tmp[1] $kk $tmp[2]\n";
	    }
	}
	close (INPUT_FILE);
    }
}	    
    print "At the End\n";
