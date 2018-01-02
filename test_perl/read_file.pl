#!/usr/bin/perl -w
#read from file and print on screen
open(MYFILE,'new file.txt') or die"cannot open file";
$count = 0;
$length=0;
while(defined ($line = <MYFILE>))
      {
	print "$line";
	chomp $line;
	$length=$length + length $line;
	$count = $count + 1;
      }
print "you have reached end of file,no. of lines is $count , no. of char.s is $length\n";
close MYFILE;
exit;

