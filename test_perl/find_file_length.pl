#!/usr/bin/perl -w
#to find length of a file
$length = 0;
$line = 0;
open MYFILE , "srtA-S-aur_seq.txt";		#'new file.txt';
while(<MYFILE>) # reads new file.txt (associated filehandler MYFILE) 1 line at a time
	{
	#### print $_;
	 chomp;# without chomp,script counts terminal newline character
	 $length=$length+length $_;
	 $line=$line+1;
	}
print 'length (no. of chars)=',$length,"\n",'lines=',$line,"\n";
exit;

#if you do not use   while(defined ($line = <MYFILE>))   , the lines are read and stored in the default variable $_ . SO YOU "print $_ "  and not " print $line ". otherwise you get error for undefined $line and the script doesn't terminate.
