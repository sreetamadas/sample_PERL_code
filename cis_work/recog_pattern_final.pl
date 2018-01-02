#!/usr/bin/perl -w
# to check if important fragments (exact/1mis- match) are present in PDB - use all PISCES seq at p= 0.05
# diff.levels of seq.identity(90/60/40/25%) & p-value(0.05/0.01/0.005/0.001) cutoffs : calculate later
# checked for multiple cis in imp frags 

@p = (0.05); #,0.04,0.02,0.01,0.008,0.006,0.005,0.004,0.002,0.001);	#,0.0008,0.0005,0.0001
@seq_cut = (100); #(90,60,40,25);
$FL = 6; # fragment length

foreach $q(@p)
  {$infile2 = "p_le_".$q; 
   open FRG,"../$infile2" or die "cant open imp frag file";
   @seq = %frag = ();
   while (<FRG>)   #saves impfrag info: pdb.ch_startres_GO as key, fragseq.' '.position-b4-cis
	{chomp $_;@x = split "_",$_; @y = split " ",$x[8];
 	 if($#y >0) {$frag{$x[4].$x[6]."_".$x[5]."_".$x[1]} = $x[7]." ".substr($y[0],0,1)." ".substr($y[1],0,1);}
	 else {$frag{$x[4].$x[6]."_".$x[5]."_".$x[1]} = $x[7]." ".substr($y[0],0,1);}
	}
  close FRG;

  foreach $r (@seq_cut)
    {$infile1 = "seq_".$r."_".$q; $outfile = "impfrag_in_pdb_".$r."_".$q;
     open OUT,">$outfile";
     open IN,"../$infile1" or die "cant open PDB seq file"; print "$infile1\n";
     while (<IN>)
	{chomp $_;
	($pdb,$go,$cisinfo,$aa,$num) = split '\t+',$_; @NUM = split ',',$num;
	 %cispep = ();
	 if($cisinfo ne ' xx')  # %cispep has info of cispep posn in PDBfile
	 	{@raw = split ' ',$cisinfo; 	#foreach $el(@raw) {print OUT "$el ";} print OUT "\n";#shift @raw;
	 	foreach $term (@raw) {$cispep{substr($term,3)}=substr($term,3) ;}
		}
	 $cnt = 0;
	 foreach $j (sort (keys%frag))
		{@seq = ();
		 push @seq, (split ' ',$frag{$j})[0];
=pod
		@a = split '',$seq[0];		## to generate patterns with 1 mismatch
		for ($i = 0; $i <= $#a; $i++)
			{$x = $a[$i];
	 		$a[$i] = "."; $pattern = "";
			for $j(0..$#a)
	 			{$pattern .= $a[$j];}
			#print "$pattern\n";
			$a[$i] = $x;
			push @seq, $pattern;
			}
=cut
		 
		 while($aa=~m/$seq[0]/g)	### USE WHILE LOOP FOR EXACT MATCH ; IF LOOP FOR 1 MISMATCH IN RESIDUE
		# if($aa=~m/$seq[0]/g ||( $aa=~m/$seq[1]/g ||( $aa=~m/$seq[2]/g ||( $aa=~m/$seq[3]/g ||( $aa=~m/$seq[4]/g ||( $aa=~m/$seq[5]/g ||( $aa=~m/$seq[6]/g)))))))  # ||( $aa=~m/$seq[7]/g || $aa=~m/$seq[8]/g)
			{@CIS = split " ",$frag{$j}; shift @CIS; 
			 my $inipep1; my $inipep2;
			 $init = pos($aa) - length($seq[0]) + 1 ; # calculated from the matching position in the sequence
			 $inipep1 = $init + $CIS[0];
			 if($#CIS > 0) {$inipep2 = $init + $CIS[1];}
			 else {$inipep2 = '';}
			# print OUT "ini1: $inipep1 ; ini2: $inipep2 ;\n";
			 $flg = 0; 
			 if(exists $cispep{$inipep1} || exists $cispep{$inipep2}) {print OUT "$pdb\-$go\_$NUM[$init]\t$j\_$seq[0]\tcis_posmatch\n";$flg++;}	#
			 else{
			      foreach $pdbpep(sort keys%cispep)
				{if($pdbpep >= $init && $pdbpep <= $init+$FL-1) {print OUT "$pdb\-$go\_$NUM[$init]\t$j\_$seq[0]\tcis_MISmatch\n";$flg++;last;} #FL6 <6; FL8 <8	# && (abs($inipep1-$pdbpep)< 6|| abs($inipep2-$pdbpep)< 6)
				}
			      }
			 if($flg == 0) {print OUT "$pdb\-$go\_$NUM[$init]\t$j\_$seq[0]\ttrans\n";}
			 $cnt++;
			}
		}
	if($cnt == 0) {print OUT "$pdb\-$go\tnoprediction\n";}
	}
     close IN;
    }
  }
#open NAME,">filename";
#foreach $r (@seq_cut)
#	{foreach $q(@p)
#		{$outfile = "impfrag_in_pdb_".$r."_".$q; print NAME "$outfile\n";}
#	}
