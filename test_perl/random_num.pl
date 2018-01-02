#!/usr/bin/perl -w
#program to generate 10  random no. from 0 to 5
use strict;
for(my$i=0;$i<=10;$i++)
	{	my $range = 6;
		my $random_number = int(rand($range));
		print "$random_number\t";	}
print"\n";
exit;

