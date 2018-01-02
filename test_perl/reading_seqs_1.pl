#!/usr/bin/perl -w
#read protein seqs. (FASTA format) and print ID and no. of AAs for each seq
$id= '';		#holds seq ID of current seq
$length = 0;		#holds length of current seq
$total_length = 0;	#tallies aggregate length of all seq.s
open SEQ ,'/home/ramak/sreetama/SORTASE PDB/3FN5.fasta.txt';
@seq = <SEQ>;
for($i=0;$i<=$#seq;$i++)
	{  chomp $seq[$i];
	   if ($seq[$i]=~ /^>/)				#sp\|(\w\d\w{3}\d)/ )					#^>sp\s\W\s(\S+)$/)
		{
		   print "$id : $length\n" if $length>0;
		   $id = $seq[$i];
		   $length = 0;
		}
	   else {  $length = $length + length $seq[$i] ;
		   $total_length = $total_length + length $seq[$i] ;
		}
	}
print "$id : $length\n" if $length>0; #last entry
print "total length = $total_length\n";
exit;
