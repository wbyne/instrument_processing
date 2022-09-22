#!/usr/bin/perl 
# script designed to perform statistics on each datafile.
# should be calc'ed for all parameters:
# Station_No\RAIN, DEPTH, TEMP, TEMP_RTC, ANALOG, LIGHT
#
# Open Stats file, check the time.  Check the arguments passed to the file to
#  determine the time frame that called the script.  Then open the ALLDATA_ALARM_LEVELS.csv
#  file to read which parameters will generate an alert.  Then open ALLDATA_STATS.csv
#  to use pre-calculated stats.  Compare the calculated stats to the alarms and
#  generate an email based on values.
use DateTime;

my @stationlist = qw(1 2 3 4 5 6 7 8 9 10 11 12);
my @param;
my @alarm;
my @notify;


($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
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

##########################################################################################
#
#Read the ALLDATA_STATS.csv file, which is created by calc_stats_alldata.pl
#
##########################################################################################
 #$param[i][j][k][l]
 # i = station
 # j = parameter (rain(0), light(1), temp_f(2), depth(3), analog(4), temp_rtc(5))
 # k = time period for statistic (15min(0), hr(1), 4 hrs(2), day(3), weekly(4), bi-monthly(5), monthly(6), quarterly(7), 6-monthly(8), yearly(9))
 # l = parameter stat (0 (reserved for alerts, maybe), max(1), min(2), total(3), ave(4))

$savepath = "/mnt/space/workspace/instrument_processing/data/site";
$scriptpath = "/mnt/space/workspace/instrument_processing/scripts";


if (-e "$savepath/ALLDATA/ALLDATA_STATS.csv" ) {
    open (INPUT_FILE, "$savepath/ALLDATA/ALLDATA_STATS.csv") or die "Can\'t find INPUT_FILE\n";
    while ($_=<INPUT_FILE>) {
	if ($_ =~ /^#/) {
		next;
	}
	chomp $_;
	if ($_ =~ /^Date/) {
	    (@tmp) = split " ",$_;
	    $datedate = $tmp[5];
	    $timetime = $tmp[6];
	    ($datemon, $dateday, $dateyr) = split "\/",$datedate;
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
	    my $dur = $currdate->subtract_datetime_absolute( $evaldate );
	    if (($dur->seconds)>86400) { 
		print "The ALLDATA_STATS.csv file hasn't been updated in more than 24 hours.  Exiting...\n";
		last; 
	    } #exit the loop if it's been more than a day.
	} #if Date 

	if ($_ =~ /^STATION/) {  # i = station
	    @tmp={0};
	    @tmp = split " ",$_;
	    $i = $tmp[1];
	}
	if ($_ =~ /^,,,,/) { # j = parameter (rain(0), light(1), temp_f(2), depth(3), analog(4), temp_rtc(5))
	    if ($_ =~ /^,,,,RAIN/)     { $j = 0; }
	    if ($_ =~ /^,,,,LIGHT/)    { $j = 1; }
	    if ($_ =~ /^,,,,TEMP /)    { $j = 2; }
	    if ($_ =~ /^,,,,DEPTH/)    { $j = 3; }
	    if ($_ =~ /^,,,,ANALOG/)   { $j = 4; }
	    if ($_ =~ /^,,,,TEMP_RTC/) { $j = 5; }
	}
	if ($_ =~ /^,,MAX/) {
	    #don't do anything, it's just a header field.
	}
	if ($_ =~ /^,15MIN/) { # k = time period for statistic (15min(0), hr(1), 4 hrs(2), day(3), weekly(4), bi-monthly(5), monthly(6), quarterly(7), 6-monthly(8), yearly(9))
	     # l = parameter stat (0 (reserved for alerts, maybe), max(1), min(2), total(3), ave(4))
	    @tmp={0};
	    @tmp = split ",",$_;
	    $param[$i][$j][0][1]=$tmp[2];
	    $param[$i][$j][0][2]=$tmp[3];
	    $param[$i][$j][0][3]=$tmp[4];
	    $param[$i][$j][0][4]=$tmp[5];
	}
	if ($_ =~ /^,1HR/) {
	    @tmp={0};
	    @tmp = split ",",$_;
	    $param[$i][$j][1][1]=$tmp[2];
	    $param[$i][$j][1][2]=$tmp[3];
	    $param[$i][$j][1][3]=$tmp[4];
	    $param[$i][$j][1][4]=$tmp[5];
	}
	if ($_ =~ /^,4HR/) {
	    @tmp={0};
	    @tmp = split ",",$_;
	    $param[$i][$j][2][1]=$tmp[2];
	    $param[$i][$j][2][2]=$tmp[3];
	    $param[$i][$j][2][3]=$tmp[4];
	    $param[$i][$j][2][4]=$tmp[5];
	}
	if ($_ =~ /^,24HR/) {
	    @tmp={0};
	    @tmp = split ",",$_;
	    $param[$i][$j][3][1]=$tmp[2];
	    $param[$i][$j][3][2]=$tmp[3];
	    $param[$i][$j][3][3]=$tmp[4];
	    $param[$i][$j][3][4]=$tmp[5];
	}
	if ($_ =~ /^\n/) { #blank line?
	}
    }
}
close(INPUT_FILE);


##########################################################################################
#
# Read the Alarms file, which dictates which people receive alerts from each station.
#
##########################################################################################
#
#$alarm[$i][$j][$k][$l]
# i = station
# j = parameter (rain(0), light(1), temp_f(2), depth(3), analog(4), temp_rtc(5))
# k = time period for statistic (15min(0), hr(1), 4 hrs(2), day(3), weekly(4), bi-monthly(5), monthly(6), quarterly(7), 6-monthly(8), yearly(9))
# l = parameter stat (0 (reserved for alerts, maybe), max(1), min(2), total(3), ave(4))

if (-e "$scriptpath/ALLDATA_ALARM_LEVELS.csv" ) {
    open (INPUT_FILE, "$scriptpath/ALLDATA_ALARM_LEVELS.csv") or die "Can\'t find INPUT_FILE\n";
    while ($_=<INPUT_FILE>) {
	if ($_ =~ /^#/) {
		next;
	}
	chomp $_;
	if (($_ =~ /^ALL/)||($_ =~ /^STATION/)) {
            if ($_ =~ /^ALL/) {
	      $i=0;
	    }
	    if ($_ =~ /^STATION/) {
		@tmp = {0};
		@tmp = split ",",$_;
		@tmptmp = split " ",$tmp[0];
		if ($tmptmp[1]<9000) {
		    $i=int($tmptmp[1]/100);
		}
		else {
		    $i=int($tmptmp[1]/1000); #capture that pesky 10000
		}
	    }
	    #split the station string into its parts
	    @tmp = {0};
	    @tmp = split ",",$_;
	
	    if ($tmp[1] =~ /^RAIN/)    { $j=0; }
	    if ($tmp[1] =~ /^LIGHT/)   { $j=1; }
	    if ($tmp[1] =~ /^TEMP/)    { $j=2; }
	    if ($tmp[1] =~ /^DEPTH/)   { $j=3; }
	    if ($tmp[1] =~ /^ANALOG/)  { $j=4; }
	    if ($tmp[1] =~ /^TEMP_RTC/){ $j=5; }

	    if ($tmp[2] =~ /^15MIN/)   { $k=0; }
	    if ($tmp[2] =~ /^1HR/)     { $k=1; }
	    if ($tmp[2] =~ /^4HR/)     { $k=2; }
	    if ($tmp[2] =~ /^24HR/)    { $k=3; }
	
	    if ($tmp[3] =~ /^MAX/)     { $l=1; }
	    if ($tmp[3] =~ /^MIN/)     { $l=2; }
	    if ($tmp[3] =~ /^TOTAL/)   { $l=3; }
	    if ($tmp[3] =~ /^AVE/)     { $l=4; }

	    if ($i == 0) { #ALL stations, populate everyone
		for my $ii (0 ..$#stationlist) {
		    #assign the value to the alarm
		    $alarm[$stationlist[$ii]][$j][$k][$l] = $tmp[4];
		    #assign the distribution list to the same set of parameters
		    $list[$stationlist[$ii]][$j][$k][$l] = $tmp[5];
		}
	    }
	    else {
		#assign the value to the alarm
		$alarm[$i][$j][$k][$l] = $tmp[4];
		#assign the distribution list to the same set of parameters
		$list[$i][$j][$k][$l] = $tmp[5];
	    }
	}#if ALL or STATION
	if ($_ =~ /^LIST/) {
	    $count = 0;
	    @tmp = {0};
	    @tmp=split ",",$_;
	    #name of the list
	    $notification_list[$tmp[2]][0]=$tmp[3];
	    $count = ($#{$notification_list[$tmp[2]]})+1;
	    for my $zztop (4 ..$#tmp) {
		#text lines have the user name with the address so we know who the number belongs to.  It needs to be stripped out.
		if ($tmp[1] =~ /^TEXT/) {
		    @tmptmp = {0};
		    @tmptmp = split ":",$tmp[$zztop];
		    $tmp[$zztop] = $tmptmp[0];
		}#TEXT
		$notification_list[$tmp[2]][$count]=$tmp[$zztop];
		$count++;
	    } #zztop
	}#LIST
    }#open INPUT_FILE
}#check to see if file exists

close(INPUT_FILE);
$count = 0; #this is used in the build_message subroutine below. it has to be cleared before the sub is called.
$count_text = 0;

#check to see time frame called for in check
if ($ARGV[0] =~ /15MIN/) { $jk=0; }
if ($ARGV[0] =~ /1HR/)   { $jk=1; }
if ($ARGV[0] =~ /4HR/)   { $jk=2; }
if ($ARGV[0] =~ /24HR/)  { $jk=3; }

for ($i=0; $i<=$#stationlist; $i++) {
    $istat=$stationlist[$i];
    for ($j=0; $j<=5; $j++) {
	for ($k=0; $k<=$jk; $k++) { #this is so every major interval includes all lower intervals (4HR checks for 1HR)
	    for ($l=1; $l<=4; $l++) {
		if (defined $alarm[$istat][$j][$k][$l]) {
		    if ($l == 1) {
			if ($param[$istat][$j][$k][$l]>$alarm[$istat][$j][$k][$l]) {
			    print "MAX EXCEEDED: $param[$istat][$j][$k][$l] : $alarm[$istat][$j][$k][$l]\n";
			    build_message();
			    if (($j==0)||($j==3)) {
				build_message_text();
			    }
			}
		    }
		    if ($l == 2) {
			if ($param[$istat][$j][$k][$l]<$alarm[$istat][$j][$k][$l]) {
			    print "MIN EXCEEDED: $param[$istat][$j][$k][$l] : $alarm[$istat][$j][$k][$l]\n";
			    build_message();
			    if (($j==0)||($j==3)) {
				build_message_text();
			    }
			}
		    }
		    if ($l == 3) {
			if ($param[$istat][$j][$k][$l]>$alarm[$istat][$j][$k][$l]) {
			    print "TOTAL EXCEEDED: $param[$istat][$j][$k][$l] : $alarm[$istat][$j][$k][$l]\n";
			    build_message();
			    if (($j==0)||($j==3)) {
				build_message_text();
			    }
			}
		    }
		    if ($l == 4) {
			if ($param[$istat][$j][$k][$l]>$alarm[$istat][$j][$k][$l]) {
			    print "SOMEONE SET AN AVE ALARM.  NOT SURE WHY.\n";
			    build_message();
			    if (($j==0)||($j==3)) {
				build_message_text();
			    }
			}
		    }
		}
	    }
	}
    }
}

send_alerts();

#Construct message to send.
sub build_message {
    #find list name, name file after list
    $message[$count] = "************************************************************\n";
    $message[$count] = $message[$count]."An alarm has occurred at raingage station $istat.  This is located at: ";
    if ($istat ==1) { $message[$count] = $message[$count]."Rae's Creek at 520\n"; }    
    if ($istat ==2) { $message[$count] = $message[$count]."Rock Creek at Bertram Rd\n"; }    
    if ($istat ==3) { $message[$count] = $message[$count]."Rae's Creek at Berckman Rd\n"; }    
    if ($istat ==4) { $message[$count] = $message[$count]."Detention Pond behind Jamestown Community Center\n"; }    
    if ($istat ==5) { $message[$count] = $message[$count]."East Augusta Pond\n"; }    
    if ($istat ==6) { $message[$count] = $message[$count]."Oates Creek at MLK\n"; }    
    if ($istat ==7) { $message[$count] = $message[$count]."3rd Level Canal at Twiggs\n"; }    
    if ($istat ==8) { $message[$count] = $message[$count]."Spirit Creek at Goshen Rd\n"; }    
    if ($istat ==9) { $message[$count] = $message[$count]."Rae's Creek at Merrick Pl\n"; }    
    if ($istat ==10) { $message[$count] = $message[$count]."Rock Creek at Stevens Creek Rd\n"; }    
    if ($istat ==11) { $message[$count] = $message[$count]."Butler Creek at Phinizy Boardwalk\n"; }    
    if ($istat ==12) { $message[$count] = $message[$count]."Augusta University\n"; }    

    if ($istat != 10) {
	$tmptmptmp=$istat*100;
	$hyperlink = "\thttp://rainfalldata.com/data/site/$tmptmptmp/gnuplot/Rainfall_at_Station_$tmptmptmp.R2.html \n";
	$message[$count] = $message[$count]." ".$hyperlink;
    }
    else {
	$tmptmptmp=$istat*1000;
	$hyperlink = "\thttp://rainfalldata.com/data/site/$tmptmptmp/gnuplot/Rainfall_at_Station_$tmptmptmp.R2.html \n";
	$message[$count] = $message[$count]." ".$hyperlink;
    }

    if ($j == 0) { $message[$count] = $message[$count]."\tThe Rainfall Volume "; }
    if ($j == 1) { $message[$count] = $message[$count]."\tThe Turbidity Level "; }
    if ($j == 2) { $message[$count] = $message[$count]."\tThe External Temperature "; }
    if ($j == 3) { $message[$count] = $message[$count]."\tThe Depth "; }
    if ($j == 4) { $message[$count] = $message[$count]."\tThe Battery Voltage "; }
    if ($j == 5) { $message[$count] = $message[$count]."\tThe Internal Temperature "; }

    if ($k == 0) { $message[$count] = $message[$count]."for the last 15 Minutes "; }
    if ($k == 1) { $message[$count] = $message[$count]."for the last Hour "; }
    if ($k == 2) { $message[$count] = $message[$count]."for the last 4 Hours "; }
    if ($k == 3) { $message[$count] = $message[$count]."for the last 24 Hours "; }

    if ($l == 1) { $message[$count] = $message[$count]."has exceeded the alarm level.\n"; }
    if ($l == 2) { $message[$count] = $message[$count]."is less than the alarm level.\n"; }
    if ($l == 3) { $message[$count] = $message[$count]."has exceeded an alarm total.\n"; }
    if ($l == 4) { $message[$count] = $message[$count]."we\'re not sure what happened.\n"; }

    $message[$count] = $message[$count]."\tThe value is: $param[$istat][$j][$k][$l] and the alarm level is: $alarm[$istat][$j][$k][$l]\n";

    if ($count == 0) {
	open (INPUT_FILE, ">","$savepath/ALLDATA/ALERTS/ALLDATA_ALERTS_$list[$istat][$j][$k][$l].txt") or die "Can\'t find INPUT_FILE\n";
    }
    else {
	open (INPUT_FILE, ">>","$savepath/ALLDATA/ALERTS/ALLDATA_ALERTS_$list[$istat][$j][$k][$l].txt") or die "Can\'t find INPUT_FILE\n";
    }
    if ($count == 0) {
	$mon=$mon+1;
	print "Date and Time of Alert: $mon/$mday/$year $hour:$min\n";
	print INPUT_FILE "Date and Time of Alert: $mon/$mday/$year $hour:$min\n";
    }
    print "$message[$count]";
    print INPUT_FILE "$message[$count]";

close INPUT_FILE;
$count++;
}


sub build_message_text {
    if ($istat ==1) { $message_text[$count_text] = "Rae's Creek at 520\n"; }    
    if ($istat ==2) { $message_text[$count_text] = "Rock Creek at Bertram Rd\n"; }    
    if ($istat ==3) { $message_text[$count_text] = "Rae's Creek at Berckman Rd\n"; }    
    if ($istat ==4) { $message_text[$count_text] = "Detention Pond behind Jamestown Community Center\n"; }    
    if ($istat ==5) { $message_text[$count_text] = "East Augusta Pond\n"; }    
    if ($istat ==6) { $message_text[$count_text] = "Oates Creek at MLK\n"; }    
    if ($istat ==7) { $message_text[$count_text] = "3rd Level Canal at Twiggs\n"; }    
    if ($istat ==8) { $message_text[$count_text] = "Spirit Creek at Goshen Rd\n"; }    
    if ($istat ==9) { $message_text[$count_text] = "Rae's Creek at Merrick Pl\n"; }    
    if ($istat ==10) { $message_text[$count_text] = "Rock Creek at Stevens Creek Rd\n"; }    
    if ($istat ==11) { $message_text[$count_text] = "Butler Creek at Phinizy Boardwalk\n"; }    
    if ($istat ==12) { $message_text[$count_text] = "Augusta University\n"; }    
    if ($j == 0) { $message_text[$count_text] = $message_text[$count_text]."\tRain Vol "; }
    if ($j == 3) { $message_text[$count_text] = $message_text[$count_text]."\tDepth "; }

    if ($k == 0) { $message_text[$count_text] = $message_text[$count_text]."for the last 15 Mins "; }
    if ($k == 1) { $message_text[$count_text] = $message_text[$count_text]."for the last Hr "; }
    if ($k == 2) { $message_text[$count_text] = $message_text[$count_text]."for the last 4 Hrs "; }
    if ($k == 3) { $message_text[$count_text] = $message_text[$count_text]."for the last 24 Hrs "; }

    if ($l == 1) { $message_text[$count_text] = $message_text[$count_text]."is > the alarm."; }
    if ($l == 2) { $message_text[$count_text] = $message_text[$count_text]."is < the alarm."; }
    if ($l == 3) { $message_text[$count_text] = $message_text[$count_text]."is > the alarm."; }
    if ($l == 4) { $message_text[$count_text] = $message_text[$count_text]."we\'re not sure what happened."; }

    $message_text[$count_text] = $message_text[$count_text]."\tIt is: $param[$istat][$j][$k][$l], Alarm is: $alarm[$istat][$j][$k][$l]\n";


    if ($count_text == 0) {
	open (INPUT_FILE, ">","$savepath/ALLDATA/ALERTS/ALLDATA_ALERTS_TEXTS_$list[$istat][$j][$k][$l].txt") or die "Can\'t find INPUT_FILE\n";
	print INPUT_FILE "http://www.rainfalldata.com/\n";
    }
    else {
	open (INPUT_FILE, ">>","$savepath/ALLDATA/ALERTS/ALLDATA_ALERTS_TEXTS_$list[$istat][$j][$k][$l].txt") or die "Can\'t find INPUT_FILE\n";
    }
    if ($count_text == 0) {
	$mon=$mon+1;
	print "Alert Time: $mon/$mday/$year $hour:$min\n";
	print INPUT_FILE "Date and Time of Alert: $mon/$mday/$year $hour:$min\n";
    }
    print "$message_text[$count_text]";
    print INPUT_FILE "$message_text[$count_text]";

    close INPUT_FILE;
    $count_text++;
}


sub send_alerts {
    for my $ii (0 ..$#notification_list) {
	for my $jj (1 .. $#{$notification_list[$ii]}) {
	    if ($notification_list[$ii][$jj] !~ /^\d/) { #ignore text numbers, they get handled at the else.
		$EMAILTO = $EMAILTO." ".$notification_list[$ii][$jj];
	    }
	    else {
		$EMAILTOTEXT = $EMAILTOTEXT." ".$notification_list[$ii][$jj];
	    }
	}
	############
	# send emails
	############
	if (-e "$savepath/ALLDATA/ALERTS/ALLDATA_ALERTS_$notification_list[$ii][0].txt" ) {
	    $MAILFILE = "$savepath/ALLDATA/ALERTS/ALLDATA_ALERTS_$notification_list[$ii][0].txt";
	    $SUBJECT = 'RAINGAGE_ALARM';
	    $EMAILFROM = 'admin@watergeorgia.com';
	    system ("mailx -r $EMAILFROM -s $SUBJECT $EMAILTO < $MAILFILE");
	    print "Just tried to send email\n";
	    $mon--;
	    $MAILFILE2 = $MAILFILE.'_'."$mday:$mon:$year".'_'."$hour:$min";
	    system ("mv $MAILFILE $MAILFILE2");
	    print "Just backed up alert file\n";
	}
	else {
	    $EMAILTO = 'fbyne@watergeorgia.com';
	    $SUBJECT = 'ERROR WITH RAINGAGE_ALARM SYSTEM';
	    $EMAILFROM = 'admin@watergeorgia.com';
	    $MAILFILE = "An Error Occurred while trying to locate the file ALLDATA_ALERTS_$notification_list[$ii][0].txt";
#	    system ("mailx -r $EMAILFROM -s $SUBJECT $EMAILTO $MAILFILE");
	}

	############
	# send texts
	############
	if (-e "$savepath/ALLDATA/ALERTS/ALLDATA_ALERTS_TEXTS_$notification_list[$ii][0].txt" ) {
	    $MAILFILE = "$savepath/ALLDATA/ALERTS/ALLDATA_ALERTS_TEXTS_$notification_list[$ii][0].txt";
	    $SUBJECT = 'RAINGAGE_ALARM';
	    $EMAILFROM = 'admin@watergeorgia.com';
	    system ("mailx -r $EMAILFROM -s $SUBJECT $EMAILTOTEXT < $MAILFILE");
	    print "Just tried to send email\n";
	    $MAILFILE2 = $MAILFILE.'_'."$mday:$mon:$year".'_'."$hour:$min";
	    system ("mv $MAILFILE $MAILFILE2");
	    print "Just backed up alert file\n";
	}
	else {
	    $EMAILTO = 'fbyne@watergeorgia.com';
	    $SUBJECT = 'ERROR WITH RAINGAGE_ALARM SYSTEM';
	    $EMAILFROM = 'admin@watergeorgia.com';
	    $MAILFILE = "An Error Occurred while trying to locate the file ALLDATA_ALERTS_TEXT_$notification_list[$ii][0].txt";
#	    system ("mailx -r $EMAILFROM -s $SUBJECT $EMAILTO $MAILFILE");
	}

    }
}

