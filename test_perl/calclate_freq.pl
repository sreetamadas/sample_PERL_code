#!/usr/bin/perl -w
#ranking clusters by and size (freq. distribution table) for given fragment length
print "enter size of first cluster:";
$size = <STDIN>;
open MYFILE ,'table.txt';
$count = 0;
while(<MYFILE>)
	{
	   chomp $_;
	   if($_=~/\d{1,8}\s(\d{1,3})/)			#	/\#\s\d{1,8}\s\d{1,3}\s(\d{1,3})/)
	   {  $det = $1;
	      if ($size==$det)
			{ $count=$count+1;
	     	   	}else
			{print "cluster size $size,\t no.of such clusters $count\n";
			 $count = 1;
			 $size = $det;
			}
	   }	   
	}
print "cluster size $size,\t no.of such clusters $count\n";
close MYFILE;
exit;
