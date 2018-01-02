#!/usr/bin/perl -w
#program to calculate array size
@a = ();
open FILE,"array";
@a = <FILE>;
print "array = @a\n";
print " array size = $#a\n";
exit;
