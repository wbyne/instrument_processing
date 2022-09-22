#!/usr/bin/perl -w 
$k=0;
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
	$_=~s/"//g; #remove double quotes
	$_=~s/[{}]//g; #remove the delimiting braces
	@tmp = split ',',$_; #the line is comma delimited, split into elements
	for ($i=0; $i<=$#tmp; $i++) { #traverse the array looking for data
	  if ($tmp[$i] =~ /^data/) { #if it starts with the word data...
	    @tmp2 = split ':',$tmp[$i]; #we delimit by colons
	    $tmp2[1]=~s/^\s+|\s+$//g; #remove spaces at the end or beginning
	    if ($tmp2[1]=~/^(\d+)/) { #looking for a digit match, 
		if ($#tmp2 != 9) { next; } #skipping hash data and everything else. With the word data, it's 9
		while ($tmp2[9] =~ /\\n$/) {  #remove multiple nl\cr, etc....
		  $tmp2[9] =~ s/\\n//;
		}#chomp $tmp2[9];
		my $month = '';
		my $day = '';
		my $year = '';
		my $hour = '';
		my $minute = '';
		$month = substr $tmp2[2],0,2;
		$day = substr $tmp2[2],2,2;
		$year = substr $tmp2[2],4,2;
		$hour = substr $tmp2[2],6,2;
		$minute = substr $tmp2[2],8,2;
		my $datestring = $month.",".$day.",".$year.",".$hour.",".$minute;
		#print STDOUT ("$tmp2[1]\n");
		#sprintf(dataPnt10ago, "%5lu:%010lu:%04d:%04u:%04u:%04u:%04u:%04u:%04u\n", STATION, DateTimelong, Tip_Count_Copy, velocity, air_temp, depth, voltage, rtc_temp, wtr_temp);
		$new_data[$k]=$tmp2[1].",RAIN,".$datestring.",".$tmp2[3];
		$k++;
		$new_data[$k]=$tmp2[1].",VELO,".$datestring.",".$tmp2[4];
		$k++;
		$new_data[$k]=$tmp2[1].",TEMP,".$datestring.",".$tmp2[5];
		$k++;
	        $new_data[$k]=$tmp2[1].",DEPTH,".$datestring.",".$tmp2[6];
		$k++;
		$new_data[$k]=$tmp2[1].",VOLT,".$datestring.",".$tmp2[7];
		$k++;
		$new_data[$k]=$tmp2[1].",TEMP_RTC,".$datestring.",".$tmp2[8];
		$k++;
		$new_data[$k]=$tmp2[1].",WTR_TMP,".$datestring.",".$tmp2[9];
		$k++;
	    }
      	  }
	}
}
#Technically, control codes are probably not going to be used anymore in favor of the particle system data; might be grabbed by a mass data dump.
#  Don't see TEMP_RTC sticking around much longer either.		
#27May17: A regular message is 5 characters, 3 are station number, and 2 are control/status code.  Status codes are:
		#  00: regular read, system okay
		#  01: system sent the message from memory because it previously had a bad cell signal
		#  99: system was reset. These are logged separately above.
		#  There are a few stations still out there that have two digit station numbers and 3 digit control codes.
		#  They should be replaced soon. -27May17-fwb
		#	sprintf(message, "%05lu:%010lu:%04d:%04u:%04u:%04u:%04u:%04u\n", STATION,DateTimelong[RepCnt], Tip_Count_Copy[RepCnt],light[RepCnt],temp[RepCnt],depth[RepCnt],0,temp_RTC[RepCnt]);


#print STDOUT "Wes\n";

	for ($k=0;$k<$#new_data;$k++) {
		print "$new_data[$k]\n";
	}
