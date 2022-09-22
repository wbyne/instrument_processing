#!/usr/bin/perl -w 
$k=0;

while ($_=<>) {
	$_=~s/^\s+|\s+$//g; #remove spaces at the end or beginning
	#target format : 	#STA,PR,DD,MM,YY,HH,MM,VAL
	#			#IMEISTA,lat,lon,sig_strength,timestring
	($station[$k],$parameter[$k],$day[$k],$month[$k],$year[$k],$hour[$k],$minute[$k],$value[$k])= split ",",$_;
	if ($day[$k] =~ /^12/) {$day[$k] = '12'; $k++; next;}
	if ($day[$k] =~ /^11/) {$day[$k] = '11'; $k++; next;}
	if ($day[$k] =~ /^10/) {$day[$k] = '10'; $k++; next;}		
	if ($day[$k] =~ /^9/)  {$day[$k] = '09'; $k++; next;}
	if ($day[$k] =~ /^8/)  {$day[$k] = '08'; $k++; next;}
	if ($day[$k] =~ /^7/)  {$day[$k] = '07'; $k++; next;}
	if ($day[$k] =~ /^6/)  {$day[$k] = '06'; $k++; next;}
	if ($day[$k] =~ /^5/)  {$day[$k] = '05'; $k++; next;}
	if ($day[$k] =~ /^4/)  {$day[$k] = '04'; $k++; next;}
	if ($day[$k] =~ /^3/)  {$day[$k] = '03'; $k++; next;}
	if ($day[$k] =~ /^2/)  {$day[$k] = '02'; $k++; next;}
	if ($day[$k] =~ /^1/)  {$day[$k] = '01'; $k++; next;}
}
$i=$k;
	for ($k=0;$k<$i;$k++) {
		print "$station[$k],$parameter[$k],$day[$k],$month[$k],$year[$k],$hour[$k],$minute[$k],$value[$k]\n";
	}
