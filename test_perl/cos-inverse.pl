#!/usr/bin/perl -w

$i = 0;
$pi = 3.14159265358979;
$theta = atan2 (sqrt(1-$i**2),$i) * 180/$pi;
print "$theta\n";
