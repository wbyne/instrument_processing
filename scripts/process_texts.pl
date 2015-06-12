#!/usr/bin/perl -w 
# Every 5 minutes, copy the working input file(s), open up the text file, process all datapoints, and 
# write a last line file to let me know where we last processed the file.
# format is #STAPRDDMMYYHHMMVAL
#
# concept is, well I'll write it up later....
###### file system setup:
######   /log
#		/archive
#		/cell_no.txt
#			/cell_no.reg #registration file
#			/cell_no.data
#	/db_sensors #this is really a postgis database
#		/rain
#		/level
#		/etc
#	/data
#		/sensor(rain)
#			/site(001)
#				/tab_data
#				/plots
#		probably symlink this to /site/sensor as well for ease of finding data....maybe
		
#added for auto-registration
my @IMEI;
my @lat;
my @lon;
my @sig_strength;
my @timestring;

#sorting array
my @new_data;
my @sorted_data;
my @condensed_data;

#regular datapoint
my @station;
my @parameter;
my @day;
my @month;
my @year;
my @hour;
my @minute;
my @value;

use sort "_mergesort";

my $savepath;

$savepath="/home/fbyne/workspace/raingage_text_processing";

#open (SAVEFILE, ">$savepath/var/wba/work_orders/working/$var_work_order_no.wba") or warn "Can't open SAVEFILE.\n"
#print SAVEFILE "mod|0\n";
#close (EQUIP_TBL);

$i=0;
$j=0;
$k=0;
$lastline=0;

print STDOUT "***************************************\n";
print STDOUT "CHECKING FOR LASTLINE FILE\n";
print STDOUT "***************************************\n";

if (-e "$savepath/7065551212.lastline" ) {
	open (LASTLINE_OF_INPUT_FILE, "7065551212.lastline") or warn "Can\'t find LASTLINE_OF_INPUT_FILE\n";
	while ($_=<LASTLINE_OF_INPUT_FILE>) {
		if ($_ =~ /^#/) {
			next;
		}
		chomp $_;
		$lastline = $_;
        }
	close(LASTLINE_OF_INPUT_FILE);
}
else { $lastline = 0; }
$i=0;
$k=0;

open (INPUT_FILE, "7065551212.txt") or die "Can\'t find INPUT_FILE\n";
while ($_=<INPUT_FILE>) {
	if ($_ =~ /^#/) {
		next;
        }
        if ($_ =~ /^\n/) {
        	next;
        }
        if ($k < $lastline) {
		$k++;
		next;
        }
        chomp $_;
	$new_data[$i] = $_;
	$i++;
}

$lastline = $k+$i; 
close(INPUT_FILE);

#### begin sort the new data
####from perl cd bookshelf, function reference for sort
sub numerically {$a <=> $b}
sub alphabetically {$a cmp $b }
@sorted_data = sort alphabetically @new_data;
#### end sort the new data

#### begin looking for duplicates in the new data
sub find_duplicates () {
my $y=1;
my $z=0;
if ($#sorted_data == 0) { #catches those cases where we created the file and it's a new entry.
		$condensed_data[0]=$sorted_data[0];
}	
for ($z=1; $z<=$#sorted_data; $z++) {
	if ($z == 1) {
		$condensed_data[0]=$sorted_data[0];
	}
	if ($sorted_data[$z] eq $sorted_data[$z-1]) {
		next;
	}
	else {
		$condensed_data[$y]=$sorted_data[$z];
		$y++;
	}
}
}
#### end looking for duplicates in the new data		

#### begin initialize and reset arrays and anything else
sub initialize_reset() {
@new_data=();
@sorted_data=();
@condensed_data=();
#my $z;
# for ($z=0;$z<=$#new_data;$z++) {
#        $new_data[$z] = "";
#    }
# for ($z=0;$z<=$#sorted_data;$z++) {
#        $sorted_data[$z] = "";
#    }
# for ($z=0;$z<=$#condensed_data;$z++) {
#        $condensed_data[$z] = "";
#    }
}
#### end initialize and reset arrays and anything else


find_duplicates();
$j=0;
$k=0;

#### begin now split the sorted data
for ($i=0; $i<=$#condensed_data; $i++) {
# is it an auto-registration line?  If so, put it in a different location for adding to the gis system
	if ($condensed_data[$i] =~ /^IMEI/) {
		#first, check the length of the string for validity, probably just a max length
		($IMEI[$j],$lat[$j],$lon[$j],$sig_strength[$j],$timestring[$j]) = split ",",$condensed_data[$i]; # IMEI supposed to be 15 digits long, need to verify format
		$IMEI[$j]=substr($IMEI[$j],4);
		$j++;
	}
	# if it's a dataline, we should check the length
	else {
		($station[$k],$parameter[$k],$day[$k],$month[$k],$year[$k],$hour[$k],$minute[$k],$value[$k]) = split ",",$condensed_data[$i]; #needs to be reconciled to IMEI number
		$k++;
	}
}
#### end now split the sorted data

#### begin process IMEI data to set up stations
#### check for existence of file
####  if exists, append to it, if not, create it.
for ($i=0; $i<=$#IMEI; $i++) {
	if (! -d "$savepath/data/site/$IMEI[$i]" ) { #checks for station
		system ("mkdir $savepath/data/site/$IMEI[$i]");
		if ($? != 0) { 
			print STDOUT "Unable to mkdir $IMEI[$i]...Stopping\n";
			exit;
		}
	}
	if (! -e "$savepath/data/site/$IMEI[$i]/$IMEI[$i].txt" ) { 
		system ("touch $savepath/data/site/$IMEI[$i]/$IMEI[$i].txt");
		if ($? != 0) { 
			print STDOUT "Unable to create $IMEI[$i].txt...Stopping\n";
			exit;
		}
	}
	open  (STAT_IMEI, ">>","$savepath/data/site/$IMEI[$i]/$IMEI[$i].txt") or warn "Can't open $IMEI[$i]\n";
	print STAT_IMEI "$IMEI[$i],$lat[$i],$lon[$i],$sig_strength[$i],$timestring[$i]\n";
	close (STAT_IMEI);
	# we handle construction of the $parameter directories when we encounter them below.
}
#### end process IMEI data to set up stations

#### begin process instrument data
for ($i=0; $i<=$#station; $i++) {
	#station and directory should already exist if we've gotten here.
	if (! -d "$savepath/data/site/$station[$i]/$parameter[$i]") {
		system ("mkdir $savepath/data/site/$station[$i]/$parameter[$i]");
		if ($? != 0) { 
			print STDOUT "Unable to mkdir $station[$i]/$parameter[$i]...Stopping\n";
			exit;
		}
	}
	if (! -e "$savepath/data/site/$station[$i]/$parameter[$i]/$station[$i]_$parameter[$i].txt") {
		system ("touch $savepath/data/site/$station[$i]/$parameter[$i]/$station[$i]_$parameter[$i].txt");
		if ($? != 0) { 
			print STDOUT "Unable to create $station[$i]_$parameter[$i]...Stopping\n";
			exit;
		}
	}
#	open (STAT_PARM, ">>","$savepath/data/site/$station[$i]/$parameter[$i]/$station[$i]_$parameter[$i].txt") or warn "Can't open $station[$i]_$parameter[$i]\n";
#	print STAT_PARM "$station[$i],$parameter[$i],$day[$i],$month[$i],$year[$i],$hour[$i],$minute[$i],$value[$i]\n";
#	close (STAT_PARM);
}

#### reset the counting arrays, reopen the files, sort the data, 
initialize_reset();
$i=0;
$j=0;
$k=0;
$l=0;

my @station_param; #station_param[station][param][line_no]
$station_param[$i][$j][$k] = $station[$i].",".$parameter[$i].",".$day[$i].",".$month[$i].",".$year[$i].",".$hour[$i].",".$minute[$i].",".$value[$i];
for ($i=1; $i<=$#station; $i++) {
	#station and directory should already exist if we've gotten here.
	if ($station[$i] ne $station[$i-1]) {
		$k=0;
		$l=0;
		$j++;
		$station_param[$j][$k][$l]=$station[$i].",".$parameter[$i].",".$day[$i].",".$month[$i].",".$year[$i].",".$hour[$i].",".$minute[$i].",".$value[$i];
	}
	else { #station numbers match, parameters don't match
		if ($parameter[$i] ne $parameter[$i-1]) {
			$l=0;
			$k++;
			$station_param[$j][$k][$l]=$station[$i].",".$parameter[$i].",".$day[$i].",".$month[$i].",".$year[$i].",".$hour[$i].",".$minute[$i].",".$value[$i];
		}
		else { #station numbers match, parameters match
			$l++;
			$station_param[$j][$k][$l]=$station[$i].",".$parameter[$i].",".$day[$i].",".$month[$i].",".$year[$i].",".$hour[$i].",".$minute[$i].",".$value[$i];
		}			
	}
}

#### begin find file, print and do stats
####  I realize I could do this in the loop(s) above, but the logic gets squirrelly and to me this seems simpler.
####   Might be too much/little coffee.
initialize_reset();

for $i (0 .. $#station_param) {
	for $j (0 .. $#{$station_param[$i]}) {
		$l=0;
		initialize_reset();
		@tmp = split ",",$station_param[$i][$j][0];
		open (STAT_PARM, "<","$savepath/data/site/$tmp[0]/$tmp[1]/$tmp[0]_$tmp[1].txt") or warn "Can't open $tmp[0]_$tmp[1]\n";
#		print STAT_PARM "$station[$i],$parameter[$i],$day[$i],$month[$i],$year[$i],$hour[$i],$minute[$i],$value[$i]\n";
		while (<STAT_PARM>) {
			if ($_ =~ /^#/) {
				next;
			}
			if ($_ =~ /^\n/) {
				next;
			}
			chomp $_;
			$new_data[$l]=$_;
			$l++;
		}
		close (STAT_PARM);
		for $k (0 .. $#{$station_param[$i][$j]}) {
			$new_data[$l] = $station_param[$i][$j][$k];
			$l++;
			print "$station_param[$i][$j][$k]\n";
		}
		@sorted_data = sort alphabetically @new_data;
		find_duplicates ();
		open (STAT_PARM, ">","$savepath/data/site/$tmp[0]/$tmp[1]/$tmp[0]_$tmp[1].txt") or warn "Can't open $tmp[0]_$tmp[1]\n";
		while (@condensed_data) {
			my $item = shift(@condensed_data);
		print STAT_PARM "$item\n";
		}
	}
}

my $test = 0;
	

	
# tweaking this.  If we make it to the end, then we rewrite the last line, otherwise we should've flagged an error by now.	
# at this point, if we write the lastline to a file and then a later file open dies, then we are out of position and place.
#  we need to recognize and identify this later to make sure that the system doesn't get inconsistent.
#open (LASTLINE_OF_INPUT_FILE,">","$savepath/data/site/7065551212.lastline") or warn "Can\'t find LASTLINE_OF_INPUT_FILE\n";
#	print LASTLINE_OF_INPUT_FILE "# $lastline at time NOW\n";
#	print LASTLINE_OF_INPUT_FILE "$lastline\n";
#close(LASTLINE_OF_INPUT_FILE);