#!/usr/bin/perl 
# script designed to perform statistics on each datafile.
# should be calc'ed for all parameters:
# Station_No\RAIN, DEPTH, TEMP, TEMP_RTC, ANALOG, LIGHT
# Rev: 6Aug17_1600: changed $i to $ii in stationlist loop call.
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
my @paramlist = qw(RAIN); #only doing rain right now.  Other params later, maybe, DEPTH, TEMP, TEMP_RTC, ANALOG, LIGHT);
$savepath = "/mnt/space/workspace/instrument_processing/data/site";
#new routines to globalize params and stations: 23Jan22
$confpath = "/mnt/space/workspace/instrument_processing/scripts";
open (CONF_FILE, "$confpath/0_script_runner_conf.csv") or die "Can\'t find CONF_FILE\n";
      while ($_=<CONF_FILE>) {
        if ($_ =~ /^#/) {
          next;
        }
        chomp $_;
	if ($_ =~ /^global_station_list/) {
	    @tmp=split ":",$_;
	    for ($i=2; $i<=$#tmp; $i++) {
		$stationlist[$i-2]=$tmp[$i];
	    }
	}
}
close (CONF_FILE);

#my @stationlist = qw(600 5000 5100 5200 7500 7600 7900); #5300 5500 5900); #100 200 300 400 500 600 700 800 900 1000 1100 1200 3000 3100 3200 3300 3400 3500 3600 
#my @stationlist = qw(400); 

$kk=0;
for my $ii (0 ..$#stationlist) {
    for my $jj (0 ..$#paramlist) {
	$lastday = 0;
	$lastfourhours = 0;
	$lasthour = 0;
	$lastfifteen = 0;
	if (-e "$savepath/$stationlist[$ii]/$paramlist[$jj]/$stationlist[$ii]_$paramlist[$jj].txt" ) {
			open (INPUT_FILE, "$savepath/$stationlist[$ii]/$paramlist[$jj]/$stationlist[$ii]_$paramlist[$jj].txt") or die "Can\'t find INPUT_FILE\n";
			while ($_=<INPUT_FILE>) {
				if ($_ =~ /^#/) {
					next;
				}
				chomp $_;
				$linearray[$kk] = $_;
				$kk++;
				#you know we could exit the read after say 1440 lines, which would be every minute for a day...maybe save some memory...
			}
			close(INPUT_FILE);
			#cycle backwards through the entries in the file looking for data within 15 minutes, 4 hours, and 24 hours.  Total them up as you find them and put them into a few variables
			for ($kk=$#linearray; $kk>0; $kk--) {
				#split the last entry in linearray, and determine if it's within 30 minutes of the actual time.  If not, then this station likely isn't working and set everything to -9999 (error, marked yellow, or some such).
				($stat, $param, $datedate, $timetime, $value) = split " ",$linearray[$kk];
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
				if (($dur->seconds)>86400) { 
				    last; 
			        } #exit the loop if it's been more than a day.
				if (($dur->seconds)<= 86400) { #1day
					$lastday = $lastday+$value;
					if (($dur->seconds)<=14400) { #four hours
						$lastfourhours = $lastfourhours+$value;
						if (($dur->seconds)<= 3600) { #1 hour
							$lasthour = $lasthour+$value;
							if (($dur->seconds)< 1200) { #20 minutes, close enough to acct for a calculation cycle
							    $lastfifteen = $lastfifteen+$value;
							}
						}
					}
				}
			}
	$lastfifteen = $lastfifteen/100.;
	$lasthour = $lasthour / 100.;
	$lastfourhours = $lastfourhours/100.;
	$lastday = $lastday/100.;
			open  (STATS_FILE, ">","$savepath/$stationlist[$ii]/$paramlist[$jj]/$stationlist[$ii]_$paramlist[$jj].sql") or die "Can\'t find STATS_FILE\n";;
			#printf STATS_FILE "UPDATE rain_gauges_production SET rain_15m=$lastfifteen where rain_gauge like \'$stationlist[$ii]\'\;\n";
			printf STATS_FILE "%s %0.2f %s","UPDATE rain_gauges_production SET rain_15m=", $lastfifteen, " where rain_gauge like \'$stationlist[$ii]\'\;\n";
			printf STATS_FILE "%s %0.2f %s", "UPDATE rain_gauges_production SET rain_1hr=", $lasthour, " where rain_gauge like \'$stationlist[$ii]\'\;\n";
			printf STATS_FILE "%s %0.2f %s","UPDATE rain_gauges_production SET rain_4hr=", $lastfourhours, " where rain_gauge like \'$stationlist[$ii]\'\;\n";
			printf STATS_FILE "%s %0.2f %s","UPDATE rain_gauges_production SET rain_24h=", $lastday, " where rain_gauge like \'$stationlist[$ii]\'\;\n";
			my $formatteddate = $currdate->month."/".$currdate->day."/".$currdate->year." ".$currdate->hour.":".$currdate->minute;
			print STATS_FILE "UPDATE rain_gauges_production SET lastupdate=\'$formatteddate\' where rain_gauge like \'$stationlist[$ii]\'\;\n";
                        #now the polygon raingages
			printf STATS_FILE "%s %0.2f %s","UPDATE rain_gauges_production_poly SET rain_15m=", $lastfifteen, " where rain_gauge like \'$stationlist[$ii]\'\;\n";
			printf STATS_FILE "%s %0.2f %s","UPDATE rain_gauges_production_poly SET rain_1hr=", $lasthour, " where rain_gauge like \'$stationlist[$ii]\'\;\n";
			printf STATS_FILE "%s %0.2f %s","UPDATE rain_gauges_production_poly SET rain_4hr=", $lastfourhours, " where rain_gauge like \'$stationlist[$ii]\'\;\n";
			printf STATS_FILE "%s %0.2f %s","UPDATE rain_gauges_production_poly SET rain_24h=", $lastday, " where rain_gauge like \'$stationlist[$ii]\'\;\n";
			print STATS_FILE "UPDATE rain_gauges_production_poly SET lastupdate=\'$formatteddate\' where rain_gauge like \'$stationlist[$ii]\'\;\n";
			close (STATS_FILE);
		}
	}
}	

	
