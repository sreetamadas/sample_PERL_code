#!/usr/bin/perl -w
#read from file and print on screen using array
open(MYFILE,'new file.txt') or die"cannot open file";
@data=<MYFILE>;
print "method 1\n";
foreach(@data)
   {
	print "$_";
   }
# method 2 : using for loop and array index
print "method 2\n";
$count = 0;
for($i=0;$i<=$#data;$i++)
	{   
	    print "$data[$i]";
	    $count = $count + 1;
	}
print "count = $count\n";
print "both methods OK\n";
close MYFILE;
exit;

# in the foreach command , if no LOOP VARIABLE is explicitly mentioned , the successive elements in the array are stored in the default variable $_
#foreach $data(@data) {print "$data ";}
