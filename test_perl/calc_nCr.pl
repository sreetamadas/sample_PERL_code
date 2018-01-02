#!/usr/bin/perl -w

## method 1: program to calculate combination (nCr) using 2 subroutines
#open IN ,"array";
#@t = <IN>;
print "enter 2 nos, (first no. >= second no.):";
for($i = 0;$i<2;$i++)
	{$t[$i] = <STDIN>;
	chomp $t[$i];}
$value = &combination($t[0],$t[1]);		#,($t[2]-$t[3]));
print "nCr : $value\n";

sub combination {
	my $n = &fact ($_[0]);
	my $r = &fact ($_[1]);
	my $n_r = &fact (($_[0]-$_[1]));
	my $nCr = $n/($r*$n_r);
	return $nCr;}

sub fact {
	 my $a = $_[0];
	 my $fact = 1;
	for( my $i = 1; $i <= $a; $i++)
		{$fact = $fact*$i;}
	return $fact;
	}

##################################################################################

# method 2: calculate combination (nCr)
@t = ();
print "enter nos, (first no. >= second no.):";
while(<>)
	{chomp $_;
	 push @t,$_;
	last if ($#t>1);}

$n = &fact ($t[0]);
$r = &fact ($t[1]);
$n_r = &fact (($t[0]-$t[1]));
$nCr = $n/($r*$n_r);
print "nCr : $nCr\n";
sub fact {
	 $a = $_[0];
	 $fact = 1;
	for( $i = 1; $i <= $a; $i++)
		{$fact = $fact*$i;}
	return $fact;
	}



