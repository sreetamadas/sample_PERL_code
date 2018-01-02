#!/usr/bin/perl -w
# using subroutine to trim a scalar - from harsh

print "enter anything with spaces\n";
$input = <STDIN>;
$a = trim ($input);
print "$a\n";

sub trim
{
my $str = $_[0];
$str=~s/^\s*(.*)/$1/;
$str=~s/\s*$//;
return $str;
}
