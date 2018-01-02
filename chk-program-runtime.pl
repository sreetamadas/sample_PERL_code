#!/usr/bin/perl
#use Time::HiRes qw(gettimeofday tv_interval);
$start_time = localtime(); #[ gettimeofday ];
print "$start_time\n";
open OUT,">chkout";
@bin = ();
for $i(0..1000000) {$bin[$i]= 0;}
for $i(1..1000000) {$bin[$i]= $bin[$i-1] + $i;print OUT "$bin[$i]\n";}
$endtime = localtime(); #[ gettimeofday ];
print "$endtime\n";
