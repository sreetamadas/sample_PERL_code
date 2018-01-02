#!/usr/bin/perl -w
#read protein seqs. (FASTA format) and print ID and no. of AAs for each seq
$id= '';		#holds seq ID of current seq
$length = 0;		#holds length of current seq
$total_length = 0;	#tallies aggregate length of all seq.s
open SEQ ,'many_fasta_seq.txt';
while (<SEQ>)
	{
	   chomp;
	   if($_=~/^>sp\|(\w\d\w{3}\d)/ )			#/^>sp\s\W\s(\S+)$/)
		 { print "$id : $length\n" if $length>0;
		   $id = $1;
		   $length = 0;
		}
	   else {  $length = $length + length $_ ;
		   $total_length = $total_length + length $_ ;
		}
	}
print "$id : $length\n" if $length>0; #last entry
print "total length = $total_length\n";
exit;
