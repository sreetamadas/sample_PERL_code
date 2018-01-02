#!/usr/bin/perl -w
# to find the distribution of position of cis peptide

open IN,"../RESULTS_6fl_c2_cis_editedF2" or die "cant open file";
$FL = 6;
%dataP = %dataNP = ();	# = @POSN
@ls = <IN>;close IN;
push @ls, $ls[0];
=pod
open OUT,">6fl_position_distr_cispep_p-np";
#print OUT "$ls[0]";
@a = (split '\s+|\t+', $ls[0]);
$cno = $a[1]; $num = $a[2];$avg_dist = $a[$#a];$compact = $avg_dist/ (2*$FL);
print OUT "Cno   num    avg_dist     compact\n";
print OUT "\# $cno\t$num\t$avg_dist\t$compact\t";

for($i = 2; $i <= $#ls; $i++)
	{$_ = $ls[$i]; chomp $_;
	if( $_ =~ /prolyl-cis/)
		{@in = split ('\s|\t',$_);
		 $posn = $in[7]; $dataP{$posn}++;} #push @POSN, $posn;}
	if( $_ =~ /non-prolyl/)
		{@in = split ('\s|\t',$_);
		 $posn = $in[7]; $dataNP{$posn}++;}
	if( $_ =~ /^# /)
	 	{print OUT "p ";	#print OUT "pos no P\n";
		 foreach $posn(sort(keys%dataP)) {print OUT "$posn   $dataP{$posn}";}
		 print OUT "\tnp ";	# print OUT "pos no NP\n";
		 foreach $posn(sort(keys%dataNP)) {print OUT "$posn   $dataNP{$posn}";}
		 %dataP = %dataNP = (); # print OUT "$_\n";
		@a = (); @a = (split '\s+|\t+', $_);
		$cno = $a[1]; $num = $a[2];$avg_dist = $a[$#a];$compact = $avg_dist/ (2*$FL);
		print OUT "\n\# $cno\t$num\t$avg_dist\t$compact\t";
		}
	}
=cut
#=pod
open OUT,">6fl_position_distr_cispep";
#print OUT "$ls[0]";
@a = (split '\s+|\t+', $ls[0]);
$cno = $a[1]; $num = $a[2];$avg_dist = $a[$#a];$compact = $avg_dist/ (2*$FL);
print OUT "Cno   num    avg_dist     compact	pos	num\n";
print OUT "\# $cno\t$num\t$avg_dist\t$compact\t";

for($i = 2; $i <= $#ls; $i++)
	{$_ = $ls[$i]; chomp $_;
	if(($_ =~ /prolyl-cis/) || ( $_ =~ /non-prolyl/))
		{@in = split ('\s|\t',$_);
		 $posn = $in[7]; $dataP{$posn}++;}
	if( $_ =~ /^# /)
	 	{#print OUT "pos no\n";
		 foreach $posn(sort(keys%dataP)) {print OUT "$posn   $dataP{$posn}\n";}
		 %dataP = %dataNP = ();	#  print OUT "$_\n";
		@a = (); @a = (split '\s+|\t+', $_);
		$cno = $a[1]; $num = $a[2];$avg_dist = $a[$#a];$compact = $avg_dist/ (2*$FL);
		print OUT "\# $cno\t$num\t$avg_dist\t$compact\t";
		}
	}
#=cut
