#!/usr/bin/perl
#this script removes info from the leap hour on 3/11/18 from 2-3 am.  The cell cards don't update until noon, so technically all data from 2AM->noon is an hour off.  Oh well.-fwb-6May18

use DateTime;

$savepath = "/mnt/space/workspace/instrument_processing/data/site";
my @stationlist = qw(100 200 300 400 500 600 700 800 900 10000 1100 1200);
my @paramlist = qw(RAIN LIGHT TEMP DEPTH ANALOG TEMP_RTC);

##find missing data section here
for $ii (0 ..$#stationlist) {
    for $jj (0 ..$#paramlist) {
	if (-e "$savepath/$stationlist[$ii]/$paramlist[$jj]/$stationlist[$ii]_$paramlist[$jj].txt" ) {
         ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$iisdst) = localtime(time);
	 $year += 1900;
        system ("cp $savepath/$stationlist[$ii]/$paramlist[$jj]/$stationlist[$ii]_$paramlist[$jj].txt $savepath/$stationlist[$ii]/$paramlist[$jj]/$stationlist[$ii]_$paramlist[$jj].bkup_".$mday."_".$mon."_".$year."_".$hour."_".$min."_".$sec.".txt");
	open (INPUT_FILE, "$savepath/$stationlist[$ii]/$paramlist[$jj]/$stationlist[$ii]_$paramlist[$jj].txt") or die "Can\'t find INPUT_FILE\n";
     	$linecounter = 0;
     	@linearray = ();
      	while ($_=<INPUT_FILE>) {
	    if ($_ =~ /^#/) {
		$linearray[$linecounter] = $_;
		$linecounter++;
	    }
	    else {
		($stat, $param, $datedate, $timetime, $value ) = split " ",$_;
		($datemon, $dateday, $dateyr) = split "\/",$datedate;
		($timehr, $timemin) = split ":",$timetime;
		if (($datemon == 3 ) && ($dateday == 11) && ($dateyr == 18) && ($timehr == 2) && ($timemin >= 0)) { #its leap hour, which doesn't exist, just ignore it.
		    next;
		}
		else {
		    $linearray[$linecounter] = $_;
		    $linecounter++;
		}
	    }        
	}#while input_file open and read file
	close(INPUT_FILE);
	open (INPUT_FILE,">","$savepath/$stationlist[$ii]/$paramlist[$jj]/$stationlist[$ii]_$paramlist[$jj].txt") or die "Can\'t find INPUT_FILE\n";
	for $linecounter (0 ..$#linearray) {
	    print INPUT_FILE $linearray[$linecounter];
	}
	close(INPUT_FILE);
	
    } #if file exists
    } # $jj
}#$ii
    


    print "At the End\n";
