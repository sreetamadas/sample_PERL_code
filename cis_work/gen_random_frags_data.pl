#!/usr/bin/perl
# Program to generate random pseudo clusters
open IN, "./library/RESULTS_6fl_c2_cis_lib";	### CHANGE HERE
$i = -1;
%Frags = ();

while(<IN>)
{        $i++;
        $Frags{$i} = $_;
}
close IN;

for $I (1..30)
{
$name = "random_frags_6fl_set";		### CHANGE HERE
$filename = $name."_".$I;

#open OUT, ">random_8fl_GO_depth";
open OUT, ">$filename"; print "$filename\n";

$sum = 0; @random = (); $min = 10; $max = 1000;

while(1)
{	$ran = int(rand($max-$min+1)) + $min;
	push @random, $ran;	## this array contains random no.s which will be used as #terms in the clusters
	$sum = $sum + $ran;	## the sum denotes total no. of frags in the file
	if($sum >= 1000) { last; } # why 100000 ? use 1000 for cis		## if($sum >= 100000) { last; }
}
$count = 0;

foreach $a (@random)
{
	$sum = 0; @random1 = ();
	$min = 0; $max = 4379; # Number of fragments in $FL set (#frags = 4001 for FL8; 4379 for FL6 )		#### CHANGE HERE

	while(1)
	{
	        $ran = int(rand($max-$min+1)) + $min;
	        push @random1, $ran;
        	$sum++;
        	if($sum >= $a) { last; }	### $a controls no. of terms in a cluster
	}

	print OUT "# cluster number $count\n";

	foreach $b (@random1)
	{
		print OUT "$Frags{$b}";
	}
	$count++;
}
close OUT;
}
