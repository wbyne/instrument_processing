#!/usr/bin/perl
#this script is designed to find all rain events with a specified inter-event period, and 
# record their start time, stop time, and rain volume.

#open rainfall file, read each line. 
# opening, set raining = 0; lastraintime = 0; rainstarttime and rainstartposition = 0
# is it raining: 	N, is lastraintime=0? Y->raining=0, N->more than one hour since lastraintime (count events)? Y->lastraintime = 0; raining = 0; N->lastraintime is unchanged, raining = 0; ; 
#   			Y->if lastraintime = 0, lastraintime=currenttime, set rainstarttime, rainstartposition
# 

use DateTime;

$savepath = "/mnt/space/workspace/instrument_processing/data/site";
my @stationlist = qw(1200);# 200 300 400 500 600 700 800 900 10000 1100 1200);

##find missing data section here
for $ii (0 ..$#stationlist) {
    $jj = 0;
    @linearray = ();
    $linecounter = 0;
    @missing_data = ();
    print STDOUT "Starting File No: ".$stationlist[$ii]."\n";
    if (-e "$savepath/$stationlist[$ii]/RAIN/$stationlist[$ii]_RAIN.txt" ) {
	open (INPUT_FILE, "$savepath/$stationlist[$ii]/RAIN/$stationlist[$ii]_RAIN.txt") or die "Can\'t find INPUT_FILE\n";
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

      ($stat, $param, $datedate, $timetime, $value ) = split " ",$linearray[0];
      #construct evaluation date:
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

      
      for ($linecounter=1; $linecounter<=$#linearray; $linecounter++) {
	  ($stat, $param, $datedate, $timetime, $value ) = split " ",$linearray[$linecounter];
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
	  if ($dur->seconds > 630) { #more than 7 minutes
	      if (($dur->seconds > 3000) && ($dur->seconds < 3960)) { #hourly event
		  #do nothing
	      }
	      else { #flag it as missing data
		  $missing_data[$ii][$jj][0] = int(($dur->seconds)/60);
		  $missing_data[$ii][$jj][1] = $linearray[$linecounter-1];
		  $missing_data[$ii][$jj][2] = $linearray[$linecounter];
		  $jj++;
	      }
	  }
	  $evaldate = $currdate;
      }
    }
}
close(INPUT_FILE);
print "At the Middle\n";

for $ii (0 ..$#stationlist) {
    open (INPUT_FILE,">", "$savepath/$stationlist[$ii]/RAIN/$stationlist[$ii]_RAIN_DATAGAPS.csv") or die "Can\'t find INPUT_FILE\n";
    print INPUT_FILE "Station No: ".$stationlist[$ii]."\n";
    for $jj (0 ..$#{$missing_data[$ii]}) {
	if ($missing_data[$ii][$jj][0] < 7000000) { #get rid of those 01/01/04 dates
	    print INPUT_FILE $missing_data[$ii][$jj][0].",".$missing_data[$ii][$jj][1].",".$missing_data[$ii][$jj][2]."\n";
	}
    }
    print INPUT_FILE "\n\n";
    for $jj (0 ..$#{$missing_data[$ii]}) {
	if ($missing_data[$ii][$jj][0] < 7000000) { #get rid of those 01/01/04 dates
	    print INPUT_FILE $missing_data[$ii][$jj][1].",".$stationlist[$ii]."\n".$missing_data[$ii][$jj][2].",".$stationlist[$ii]."\n";
	}
    }

        print INPUT_FILE "\n\n";
    for $jj (0 ..$#{$missing_data[$ii]}) {
	if ($missing_data[$ii][$jj][0] < 7000000) { #get rid of those 01/01/04 dates
	    @tmp = split " ",$missing_data[$ii][$jj][1];
	    print INPUT_FILE $tmp[2]." ".$tmp[3]." ".$missing_data[$ii][$jj][0]."\n";
	}
    }
    close(INPUT_FILE);
}#while input_file open and read file

print "At the End\n";
