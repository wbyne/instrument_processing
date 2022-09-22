#!/usr/bin/perl -w
# script update .
# should be called following calc_stats.pl, and should be setuid gis_edit.
# all sql files should be group owned as gis_editor
### Should be placed in gis_edit's directory and run from there by cron -wb-24June17_1615

print "Running sql updates on database\n";
			
$savepath = "/mnt/space/workspace/instrument_processing/data/site";
my @paramlist = qw(RAIN); #only doing rain right now.  Other params later, maybe, DEPTH, TEMP, TEMP_RTC, ANALOG, LIGHT);
#my @stationlist = qw(100 200 300 400 500 600 700 800 900 10000 1100 1200 3000 3100 3200 3300 3400 3500 3600 5000 5100 5200 7600 7900 ); #1000 2000 3000 5000 7000 25000);
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

for my $i (0 ..$#stationlist) {
	for my $j (0 ..$#paramlist) {
		if (-e "$savepath/$stationlist[$i]/$paramlist[$j]/$stationlist[$i]_$paramlist[$j].sql" ) {
		    @argslist = ("/usr/bin/psql -d aed_storm < $savepath/$stationlist[$i]/$paramlist[$j]/$stationlist[$i]_$paramlist[$j].sql");
		    system(@argslist) == 0 or die "system @argslist failed: $?";			
		}
	}
}	

print "Finished Running sql updates on database\n";
	
