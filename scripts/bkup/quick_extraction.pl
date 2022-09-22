while ($_=<>) {
	if ($_ =~ /^#/) {
		next;
        }
        if ($_ =~ /^$/) { #a line with nothing in it.
        	next;
        }
        if ($_ =~ /^\n/) {
        	next;
        }
        if ($_ =~ /^\r\n/) {  #this seems to match the empty dos line better than any others.
        	next;
        }
        if ($_ =~ /^OK/) {
        	next;
        }
        if ($_ =~ /^AT+/) {
        	next;
        }
      #  if ($_ =~ /^\There/) {
		next;
	}
	while ($_ =~ /\r\n$/) {  #this works to remove multiple newlines\carriage return, etc....
		$_ =~ s/\r\n/\n/;
	}
        if ($_ =~ /\n/) {
        	chomp $_;
        }
        if ($_ =~ /^\+CMT/) {
		$origin_and_data[$i] = $_;
	}
# how to tell which line you're on if  you're next'ing above....       if ($_ < $lastline) {
#		$k++;
#		next;
 #       }

	else {
		$new_data[$i]=$_;
		$origin_and_data[$i]=$_.",".$origin_and_data[$i];
		$i++;
	}
}

print STDOUT "Wes\n";

	for ($k=0;$k<$i;$k++) {
		print "I'm here\n";
		#$k++;
		print 
	}