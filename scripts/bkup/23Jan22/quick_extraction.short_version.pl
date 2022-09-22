#!/usr/bin/perl -w 
#27May17-changed control code handling (picking up 999 and 99 for the new gage naming convention).
#10Sept17-Added code around line 16 to catch an error where station 7 occasionally reports with > in the beginning of the line.
$i=0;
#@tmp;

while ($_=<>) {
	$_=~s/^\s+|\s+$//g; #remove spaces at the end or beginning
	#target format : 	#STA,PR,DD,MM,YY,HH,MM,VAL
	#			#IMEISTA,lat,lon,sig_strength,timestring
	while ($_ =~ /\r\n$/) {  #this works to remove multiple newlines\carriage return, etc....
		$_ =~ s/\r\n/\n/;
	}
        if ($_ =~ /\n/) {
        	chomp $_;
        }
	if ($_ =~ /^>   700/) { #station 7 randomly has > characters on the received texts. This is a one-off to capture and remove that. 
	    $_ = substr $_,4; #grab from first character to the end
	}
	if ($_ =~ /^(\d+)/) {
		my $month = '';
		my $day = '';
		my $year = '';
		my $hour = '';
		my $minute = '';
		@tmp = split ':',$_;
		if (length($tmp[1]) == 9) { # month doesn't have a leading 0
			$month = substr $tmp[1],0,1;
			$day = substr $tmp[1],1,2;
			$year = substr $tmp[1],3,2;
			$hour = substr $tmp[1],5,2;
			$minute = substr $tmp[1],7,2;
		}
		elsif (length($tmp[1]) == 10) { # leading 0 on the month or the month is > 9
			$month = substr $tmp[1],0,2;
			$day = substr $tmp[1],2,2;
			$year = substr $tmp[1],4,2;
			$hour = substr $tmp[1],6,2;
			$minute = substr $tmp[1],8,2;
		}
		if ($tmp[0] =~ /99$/) { #new IMEI or first start marker.  Changed the 5 digit value from 2 digit station to 3 digit station with 2 digit status code in May 2017.  The match of 99$, which means match 99 at the end of the number, will catch both. 
		#	//reset stamp is Station(999 extension), DateTimelong, lat, long, sig_Strength, timestamp
		#sprintf(stat, "%05lu:%010lu:%04u:%04u:%04u:%04u", STATION, DateTimelong[0], 0,0,0,0);
			if ($#tmp > 4) {
			  $new_data[$i]=$tmp[0].",RESET,".$month.",".$day.",".$year.",".$hour.",".$minute.",".$tmp[2].",".$tmp[3].",".$tmp[4].",".$tmp[5];
			}
			else {
  			  $new_data[$i]=$tmp[0].",RESET,".$month.",".$day.",".$year.",".$hour.",".$minute.",".$tmp[2].",".$tmp[3].",".$tmp[4]; #for older records
			}
			$i++;
			next;
		}
		#regular message is as detailed below
		#27May17: A regular message is 5 characters, 3 are station number, and 2 are control/status code.  Status codes are:
		#  00: regular read, system okay
		#  01: system sent the message from memory because it previously had a bad cell signal
		#  99: system was reset. These are logged separately above.
		#  There are a few stations still out there that have two digit station numbers and 3 digit control codes.
		#  They should be replaced soon. -27May17-fwb
		#	sprintf(message, "%05lu:%010lu:%04d:%04u:%04u:%04u:%04u:%04u\n", STATION,DateTimelong[RepCnt], Tip_Count_Copy[RepCnt],light[RepCnt],temp[RepCnt],depth[RepCnt],0,temp_RTC[RepCnt]);
		$new_data[$i]=$tmp[0].",RAIN,".$month.",".$day.",".$year.",".$hour.",".$minute.",".$tmp[2];
		$i++;
		$new_data[$i]=$tmp[0].",LIGHT,".$month.",".$day.",".$year.",".$hour.",".$minute.",".$tmp[3];
		$i++;
		$new_data[$i]=$tmp[0].",TEMP,".$month.",".$day.",".$year.",".$hour.",".$minute.",".$tmp[4];
		$i++;
		if ($#tmp > 4) { #$# is the number of the last element in the array, or 1 less than its length
		    if ($tmp[5]>65000) {$tmp[5]=0;} #remove spurious data in the depth field
		  $new_data[$i]=$tmp[0].",DEPTH,".$month.",".$day.",".$year.",".$hour.",".$minute.",".$tmp[5];
		  $i++;
		  $new_data[$i]=$tmp[0].",ANALOG,".$month.",".$day.",".$year.",".$hour.",".$minute.",".$tmp[6];
		  $i++;
		  $new_data[$i]=$tmp[0].",TEMP_RTC,".$month.",".$day.",".$year.",".$hour.",".$minute.",".$tmp[7];
		  $i++;
		}
        }
	if ($_ =~ /^GRU/) { #old format for raingage only.  should be changed by now
		@tmp = split ',',$_;
		my $station=$tmp[0];
		my $parameter=$tmp[1];
		my $day=$tmp[2];
		my $month=$tmp[3];
		my $year=15;
		my $hour=$tmp[4];
		my $minute=$tmp[5];
		my $second=$tmp[6];		
		my $rainfall = $tmp[7];
		$new_data[$i]=$tmp[0].",RAIN,".$month.",".$day.",".$year.",".$hour.",".$minute.",".$tmp[7];
		$i++;
        }
	else {
		next;
	}
}

#print STDOUT "Wes\n";

	for ($k=0;$k<$i;$k++) {
		print "$new_data[$k]\n";
	}
