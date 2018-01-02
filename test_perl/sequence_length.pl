#!/usr/bin/perl -w
#read protein seq. (FASTA format) and print no. of AAs
open PROT ,'fasta_seq.txt';
$length=0;
$line=0;
while(<PROT>)
	{
	   chomp;
	   $length=$length + length $_ if $_ =~ /^\w+$/; # /^[RKHDENQSCTALIVFMWYGP]+$/;   this omits 1st line
	   $line=$line + 1;  # this counts total no. of lines including the 1st one
	}
print " length of seq = $length , no. of lines = $line \n";
exit;


# the pattern checking can be done in 2 ways': a) beginning of line char(^) - any of the AAs any no. of times - 						  end of line char($) ;
#					       b) ^ - any word char (\w) any no. of times - $
