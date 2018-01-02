#!/usr/bin/perl -w
# to generate match files at different cutoffs: seq.identity(90/60/40/25%) & p-value(0.05/0.01/0.005/0.001)

#@p = (0.05,0.04,0.02,0.01,0.008,0.006,0.005,0.004,0.002,0.001);
@p = (0.05,0.01,0.005,0.001,0.0005,0.0001,0.00005,0.00001);
@seq_cut = (90,60,40,25);
open NAME,">filename";
foreach $r (@seq_cut)
  {$piscesfile = 'piscesPDB_'.$r; %pisces = ();
   open PISCES,"../../modified_PISCES/$piscesfile" or die "cant open $piscesfile\n";
   while(<PISCES>)
	{chomp $_; $pisces{$_}++;}
   close PISCES;

   foreach $q(@p)
	{$fragfile = 'p_le_'.$q; %impfrag = ();
	 open IMP,"../$fragfile" or die "cant open $fragfile\n";
	 while(<IMP>)
		{chomp $_; @x = split "_",$_;
		 $impfrag{$x[4].$x[6]."_".$x[5]."_".$x[1]."_".$x[7]}++;
		}
	 close IMP;

	 open IN,"impfrag_in_pdb_100_0.05" or die "cant open input file\n";
	 $out = "impfrag_in_pdb_".$r."_".$q; open OUT,">$out"; print NAME "$out\n";
	 while(<IN>)
		{$t2 = substr($_,1,5); $t1 = (split '\t+',$_)[1];
		 if(defined $pisces{$t2} && defined $impfrag{$t1}) {print OUT $_;} ## '&&' leaves out piscespdb with nopred
		}
	 close IN; close OUT;
	}
  }
