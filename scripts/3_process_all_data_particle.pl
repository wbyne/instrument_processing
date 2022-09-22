#!/usr/bin/perl -w 
# 8July17-forked to process_all_data.pl to handle all data together for one file
# May17-cleaned up new control codes (99 instead of 999, and 01 instead of just 00)
# 26jan16-fwb-added code to seamless sort by year to fix those year rollovers.
# Every 5 minutes, copy the working input file(s), open up the text file, process all datapoints, and 
# write a last line file to let me know where we last processed the file.
# format is #STAPRDDMMYYHHMMVAL
#
# concept is, well I'll write it up later....Well, it's just a concept and the reality differs slightly.-fwb-21Oct15
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
my @rsthr;
my @rstmin;

#sorting array
my @new_data;
my @sorted_data;
my @condensed_data;
my @origin_and_data;
my @alldata;
my @IMEI_alldatastring;
my @alldatastring;

#regular datapoint
my $localStation;
my $fakestation;
my @station;
my @parameter;
my @day;
my @month;
my @year;
my @hour;
my @minute;
my @value;
my $IMEI_header;
my $alldata_header;

use sort "stable"; #changed from "_mergesort" 19Sep21 b/c sort now uses a stable mergesort

my $savepath;

$savepath="/mnt/space/workspace/instrument_processing";

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

if (-e "$savepath/log/screenlog.0.lastline" ) {
	open (LASTLINE_OF_INPUT_FILE, "screenlog.0.lastline") or warn "Can\'t find LASTLINE_OF_INPUT_FILE\n";
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

open (INPUT_FILE, "$savepath/log/screenlog.0.particle.tmp") or die "Can\'t find INPUT_FILE\n";
while ($_=<INPUT_FILE>) {
        if ($k < $lastline) { #skip to the end of the file
		$k++;
		next;
        }
	if ($_ =~ /^#/) {
		$k++;
		next;
        }
        if ($_ =~ /^\n/) {
		$k++;
        	next;
        }
        if ($_ =~ /^\r\n/) {  #this seems to match the empty dos line better than any others.
		$k++;
        	next;
        }
        if ($_ =~ /^OK/) {
		$k++;
        	next;
        }
        if ($_ =~ /^AT+/) {
		$k++;
        	next;
        }
        if ($_ =~ /^There/) {
		$k++;
		next;
	}
	while ($_ =~ /\r\n$/) {  #this works to remove multiple newlines\carriage return, etc....
		$_ =~ s/\r\n/\n/;
	}
        if ($_ =~ /\n/) {
        	chomp $_;
        }
	$_=~s/"//g; #remove double quotes
	$_=~s/[{}]//g; #remove the delimiting braces
#        if ($_ =~ /^\+CMT/) {
#	    $origin_and_data[$i] = $_;
#	    next; #skip the assignment below until we read the next line
#	}
	@tmp = split ',',$_; #the line is comma delimited, split into elements
	for ($j=0; $j<=$#tmp; $j++) { #traverse the array looking for data
	  if ($tmp[$j] =~ /^data/) { #if it starts with the word data...
	    @tmp2 = split ':',$tmp[$j]; #we delimit by colons
	    $tmp2[1]=~s/^\s+|\s+$//g; #remove spaces at the end or beginning
	    if ($tmp2[1]=~/^(\d+)/) { #looking for a digit match, 
		if ($#tmp2 != 11) { next; } #skipping hash data and everything else: 
		while ($tmp2[11] =~ /\\n$/) {  #remove multiple nl\cr, etc....
		  $tmp2[11] =~ s/\\n//;
		}#chomp $tmp2[9];
		#$tmp[$j] =~ s/:/,/g; #substitute commas for the colons.  helps later -wb-8july17
		$new_data[$i]=$tmp2[1].','.$tmp2[2].','.$tmp2[3].','.$tmp2[4].','.$tmp2[5].','.$tmp2[6].','.$tmp2[7].','.$tmp2[8].','.$tmp2[9].','.$tmp2[10].','.$tmp2[11].','.$i;
#### Okay, I think this is a fluke, and I'm changing it.  Looks like I left a ; off the end of the line above and it kept adding i to the end of the line
####  BUT it used $i++ as new_data[i++] which meant that $new_data[0] was always missing, and caused wonkiness.  I have changed this and
####  tweaked the find_duplicates subroutine below to try and correct this....-fwb-15feb22_1030
		$i++;  #this is funky; I add i but increment it, and the effect is that i gets used as i++ in new_data but as i in the datastring.
 		 	#  I can't find anywhere this would cause a problem if I increment it afterwards... -fwb-14Feb22
	    }
	  }
	}
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
my $y=0; #changed; this was to prevent an error when the file was created, but that should've been handled in process_texts_particle.pl
my $z=0;
##my $y=1;
##if ($#sorted_data == 0) { #catches those cases where we created the file and it's a new entry.
##		$condensed_data[0]=$sorted_data[0];
##}	
### Okay, I think this was done wrong on purpose a long time ago because it threw an error
###  but seemed to work otherwise.  Summary: if the first station (rainfall station info) is 
###  sorted and has the same value from 0 to x, then when it switches to the next station 
###  the first one will get clobbered because y is still 0 and hasn't been incremented.
###  I think I also count from z=1 because i used i=1 above instead of i=0.  I'm thinking
###  I can fix that here now. -fwb-15feb22_1030  
###for ($z=1; $z<=$#sorted_data; $z++) {
###	if ($z == 1) {
###		$condensed_data[0]=$sorted_data[0];
###	}
###	if ($sorted_data[$z] eq $sorted_data[$z-1]) {
###		next;
###	}
###	else {
###		$condensed_data[$y]=$sorted_data[$z];
###		$y++;
###	}
###}
for ($z=0; $z<=$#sorted_data; $z++) {
	if ($z == 0) {
		$condensed_data[0]=$sorted_data[0];
		$y=1;
		next;
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
####  I have NO idea why I used $k here instead of following $i...probably a decision
####    decision from the original work that was obsoleted. -fwb-12Feb22
for ($i=0; $i<=$#condensed_data; $i++) {
	my @test_array = split",",$condensed_data[$i];
	
	# if it's a dataline, we should check the length
	@alldata = split ",",$condensed_data[$i];
	$alldata[0] =~ s/^\s+|\s+$//g; #remove all spaces beginning and end
	$station[$k]       = $alldata[0];
	$fakestation[$k]   = 10*(int($station[$k]/10));
	$timestring[$k]    = $alldata[1];
	$month[$k]         = substr($alldata[1],0,2);
	$day[$k]           = substr($alldata[1],2,2);
	$year[$k]          = substr($alldata[1],4,2);
	$hour[$k]          = substr($alldata[1],6,2);
	$minute[$k]        = substr($alldata[1],8,2);
	if ((0<=$minute[$k]) && ($minute[$k]<5)) {$fakeminute[$k] = 0;}
	if ((5<=$minute[$k]) && ($minute[$k] < 10)) {$fakeminute[$k] = 5;}
	if ((10<=$minute[$k])&&($minute[$k] < 15)) {$fakeminute[$k] = 10;}
	if ((15<=$minute[$k])&&($minute[$k] < 20)) {$fakeminute[$k] = 15;}
	if ((20<=$minute[$k])&&($minute[$k] < 25)) {$fakeminute[$k] = 20;}
	if ((25<=$minute[$k])&&($minute[$k] < 30)) {$fakeminute[$k] = 25;}
	if ((30<=$minute[$k])&&($minute[$k] < 35)) {$fakeminute[$k] = 30;}
	if ((35<=$minute[$k])&&($minute[$k] < 40)) {$fakeminute[$k] = 35;}
	if ((40<=$minute[$k])&&($minute[$k] < 45)) {$fakeminute[$k] = 40;}
	if ((45<=$minute[$k])&&($minute[$k] < 50)) {$fakeminute[$k] = 45;}
	if ((50<=$minute[$k])&&($minute[$k] < 55)) {$fakeminute[$k] = 50;}
	if ((55<=$minute[$k])&&($minute[$k] < 60)) {$fakeminute[$k] = 55;} #yeah, I know, I know.
	$rain[$k]          =$alldata[2];
  	$velo[$k]          =$alldata[3];
	$temp[$k]          =$alldata[4];
	$depth[$k]         =$alldata[5];
	$volt[$k]          =$alldata[6];
	$temp_rtc[$k]      =$alldata[7];
	$wtr_tmp[$k]       =$alldata[8]; #bugfix 12Feb22: referenced $i instead of $k
	$gen_int[$k]       =$alldata[9]; #bugfix 12Feb22: referenced $i instead of $k	    
	$cond[$k]          =$alldata[10];#bugfix 12Feb22: referenced $i instead of $k	    
	$alldatastring[$k] =  $fakestation[$k].",".$timestring[$k].",".$station[$k].",".$month[$k].",".$day[$k].",".$year[$k].",".$hour[$k].",".$minute[$k].",".$month[$k]."/".$day[$k]."/".$year[$k]." ".$hour[$k].":".$minute[$k].",".$month[$k]."/".$day[$k]."/".$year[$k]." ".$hour[$k].":".$fakeminute[$k].",".$rain[$k].",".$velo[$k].",".$temp[$k].",".$depth[$k].",".$volt[$k].",".$temp_rtc[$k].",".$wtr_tmp[$k].",".$gen_int[$k].",".$cond[$k];
        #kept here for reference, used to print a header once when the file is created
        #$alldata_header = "#Station,TimeStamp,StationCtrlCode,Month,Day,Year,Hour,Minute,Date_Time,Date_Time_Adj,Rain_hundredths,Light,Temp_F,Depth_Hundredths_of_Feet,Analog,Temp_RTC_F,Station_Tel_No,Sent_Year,Sent_Mon,Sent_Day,Sent_Hour,Sent_Min,Sent_Sec,Sent_Ctrl_Code,Sent_Date_Time,Sent_Time,
	$k++;
}
#### end now split the sorted data

initialize_reset();
@sorted_data = sort alphabetically @fakestation;
find_duplicates();
#### begin process instrument data
for ($i=0; $i<=$#condensed_data; $i++) {
	#station and directory should already exist if we've gotten here.
        $localStation = int($condensed_data[$i]/10); #catches control codes so the script doesn't think 401 is different than 400-fwb-4june17_1017 ##not really needed anymore because I'm sorting on fakestation, which has the control code removed
	$localStation = $localStation*10;
	if (! -d "$savepath/data/site/$localStation/ALLDATA") {
		system ("mkdir -p $savepath/data/site/$localStation/ALLDATA");
		if ($? != 0) { 
			print STDOUT "Unable to mkdir $localStation/ALLDATA...Stopping\n";
			exit;
		}
	}
	if (! -e "$savepath/data/site/$localStation/ALLDATA/$localStation"."_"."ALLDATA_Summary.csv") {
		system ("touch $savepath/data/site/$localStation/ALLDATA/$localStation"."_"."ALLDATA_Summary.csv");
		if ($? != 0) { 
		  print STDOUT "Unable to create $localStation"."_"."ALLDATA_Summary.csv...Stopping\n";
   		  exit;
		}
	}
}

#### reset the counting arrays, reopen the files, sort the data, 
initialize_reset(); 
$i=0;
$j=0;
$k=0;
$l=0;

@sorted_data = sort alphabetically @fakestation;
find_duplicates();

@station_list = @condensed_data;

for $i (0 .. $#station_list) {
		$l=0;
		#See Note below where I dropped ALLDATA.csv because originally ALLDATA_Summary omitted phone numbers of the stations (public website)
		#  but then with particle that was no longer true, and so I only uploaded the Summary file, but then we were using the NON-SUMMARY
		#  file here to read all of the previous days data!  Ahhh, bugs and unintended consequences...-fwb-12Feb22_2100
		open (STAT_PARM, "<","$savepath/data/site/$station_list[$i]/ALLDATA/$station_list[$i]"."_ALLDATA_Summary.csv") or warn "Can't open $station_list[$i]_ALLDATA_Summary.csv line 292\n";
		while (<STAT_PARM>) {
			if ($_ =~ /^#/) {
				next;
			}
			if ($_ =~ /^\n/) {
				next;
			}
			chomp $_;
##			$_ =~ s/^\s+//; #from https://perlmaven.com/trim 24jun17_1446.  Successive reads and writes on the data files ends up multiplying errant spaces
			$_ =~ s/^\s+|\s+$//g; #even better, remove blank spaces beginning and end
			$new_data[$l]=$_;
			$l++;
		}
		close (STAT_PARM);
		for $k (0 .. $#alldatastring) { #alldata
		    if ($station_list[$i] == $fakestation[$k]) {
		        $new_data[$l] = $alldatastring[$k];
			$l++;
			print "$alldatastring[$k]\n";
		    }
		}
		presort(); #fixes year-end rollover, aka New Years Fix
		@sorted_data = sort alphabetically @new_data;
		postsort(); #fixes year-end rollover, aka New Years Fix
		find_duplicates ();
		#short note: the original ALLDATA file had the stations phone number in it, so we created a Summary file with 
		#  only relevant water data and no identifiers.  With the particle switch, this is no longer true, but the 
		#  original script still needs to skip the old data so that we're not exposing those numbers.  
		#  So, the quickest fix is to change the file where we save the data to be named the Summary file.
		#  fwb-22Jan22
		#commented 22Jan22: open (STAT_PARM, ">","$savepath/data/site/$station_list[$i]/ALLDATA/$station_list[$i]"."_"."ALLDATA.csv") or warn "Can't open $station_list[$i]_ALLDATA.csv\n";
		open (STAT_PARM, ">","$savepath/data/site/$station_list[$i]/ALLDATA/$station_list[$i]"."_"."ALLDATA_Summary.csv") or warn "Can't open $station_list[$i]_ALLDATA_Summary.csv\n";
	        print STAT_PARM "#Station,TimeStamp,StationCtrlCode,Month,Day,Year,Hour,Minute,Date_Time,Date_Time_Adj,Rain_hundredths,Velo_fps,Temp_F,Depth_Hundredths_of_Feet,Voltage_V,Temp_RTC_F,WTR_TMP_F,GEN_INT,COND\n";
		#open (STAT_PARM_SUMM, ">","$savepath/data/site/$station_list[$i]/ALLDATA/$station_list[$i]"."_"."ALLDATA_Summary.csv") or warn "Can't open $station_list[$i]_ALLDATA_Summary.csv\n";
	        #print STAT_PARM_SUMM "#Station,Date_Time,Date_Time_Adj,Rain_hundredths,Light,Temp_F,Depth_Hundredths_of_Feet,Analog,Temp_RTC_F,\n";
	        while (@condensed_data) {
			my $item = shift(@condensed_data);
			@tmp2 = split ",",$item;
			print STAT_PARM "$item\n";
		#	print STAT_PARM_SUMM "$tmp2[0],$tmp2[8],$tmp2[9],$tmp2[10],$tmp2[11],$tmp2[12],$tmp2[13],$tmp2[14],$tmp2[15]\n";
		}
		close (STAT_PARM);
                initialize_reset();		
}

sub presort { #fixes end of year rollover, part 1/2, aka New Years Day fix
	#$station_param[$j][$k][$l]=$station[$i]." ".$parameter[$i]." ".$day[$i]."/".$month[$i]."/".$year[$i]." ".$hour[$i].":".$minute[$i]." ".$value[$i];
	for ($ii=0; $ii<=$#new_data; $ii++) {
	    #		@tmptmp = split "/",$new_data[$ii];
	        @tmptmp = split ",",$new_data[$ii];
		$yrtmp2=substr($tmptmp[1],4,2);
		$statmp = $tmptmp[0]; #In this script, this fixes the broken New Years Day rollover.  It's different in process_texts.pl, but the concept is the same. 1Jan18.
		$new_data[$ii]=$statmp.":".$yrtmp2."||".$new_data[$ii];	
	}
}

sub postsort { #fixes end of year rollover, part 2/2, aka New Years Day fix
	#$station_param[$j][$k][$l]=$station[$i]." ".$parameter[$i]." ".$day[$i]."/".$month[$i]."/".$year[$i]." ".$hour[$i].":".$minute[$i]." ".$value[$i];
	for ($ii=0; $ii<=$#sorted_data; $ii++) {
	    @tmptmp = split '\|\|',$sorted_data[$ii];
	    $sorted_data[$ii]=$tmptmp[1];
	}	
}

