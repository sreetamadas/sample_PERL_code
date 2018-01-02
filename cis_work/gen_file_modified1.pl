#!/usr/bin/perl -w
# to prepare input file with cluster no. , >F\tpdbid.chid\tstart-res \t frag \t sec-str \t cis-peptide type\tposition of cispept\tAA in cis angle
%three2one = ('ALA' => 'A', 'ARG' => 'R', 'ASN' => 'N', 'ASP' => 'D', 'CYS' => 'C',
              'GLN' => 'Q', 'GLU' => 'E', 'GLY' => 'G', 'HIS' => 'H', 'ILE' => 'I',
              'LEU' => 'L', 'LYS' => 'K', 'MET' => 'M', 'PHE' => 'F', 'PRO' => 'P',
              'SER' => 'S', 'THR' => 'T', 'TRP' => 'W', 'TYR' => 'Y', 'VAL' => 'V');

open IN,"./propen/RESULTS_8fl_c2_cis_All" or die "cant open file";	#### CHANGE HERE	 6 -> 8
#open OUT,">RESULTS_6fl_c2_cis_editedF2";				#### CHANGE HERE 	
open OUT,">RESULTS_8fl_c2_cis_editedF_multicis";				#### CHANGE HERE 	
$FL = 8; ### CHANGE HERE
$fl1 = $FL -1;
$start = 6+$FL*2;
while (<IN>)
	{if($_ =~ /^\#/)
		{print OUT "$_";}
	 if($_ =~ /^[F|f]/)
		{@a = split '\s+|\t+',$_; @cispos = ();
		 $F = $a[0];
		 $pdb = substr($a[3],3,4);
		 $ch = $a[5]; if($a[5] eq ' ') { $ch = '0'; } 
		 $res = $a[4];
		 $seq = $a[1]; $sse = $a[2];
		 for($i=0;$i<$FL;$i++)				### for fl6 -> $i<=5 ; for fl8 -> $i<=7
			{if(($a[$i+$start]<=90)&&($a[$i+$start]>= -90))   ### for fl6 -> $i+18; for fl8 -> $i+22
				{push @cispos, $i;}	#print $i;
			}
		 @AA = ();@AA = split '',$a[1];
		 print OUT "$F\t$pdb$ch\t$res\t$seq\t$sse\t"; 
		 if($#cispos == 0)
		 {foreach $i (@cispos)
		    {if($i<$fl1)	#fl6 -> $i<5; fl8 -> $i<7
			{if($AA[$i+1] eq 'P') {print OUT " $a[$i+$start]\_prolylcis\_$i\_$AA[$i+1]\n";}	 ### for fl6 -> $i+18; for fl8 -> $i+22
		 	else {print OUT " $a[$i+$start]\_nonprolyl\_$i\_$AA[$i+1]\n";}	 ### for fl6 -> $i+18; for fl8 -> $i+22
			}
		    if($i==$fl1)	#fl6 -> $i==5; fl8 -> $==7
			{open FILE,"../rin/pdb$pdb.rin" or die "cant open rin file";
			 @dat = <FILE>; close FILE;
			foreach $z(@dat)
				{$resnum =  substr($z,9,4);$chid = substr($z,8,1);$AMINO = substr($z,4,3);
				 if(($chid eq $ch)&&($resnum == $res+$FL))	### for fl6 -> $res+6; for fl8 -> $res+8
					{if($AMINO eq 'PRO') {print OUT " $a[$i+$start]\_prolylcis\_$i\_$three2one{$AMINO}\n";}	 ### for fl6 -> $i+18; for fl8 -> $i+22
		 			 else {print OUT " $a[$i+$start]\_nonprolyl\_$i\_$three2one{$AMINO}\n";}		 ### for fl6 -> $i+18; for fl8 -> $i+22
					}
				}
			}
		     }
		 }
		 if($#cispos > 0)
		 {foreach $i (@cispos)
		    {if($i<$fl1)	#fl6 -> $i<5; fl8 -> $i<7
			{if($AA[$i+1] eq 'P') {print OUT " $a[$i+$start]\_prolylcis\_$i\_$AA[$i+1]";}	 ### for fl6 -> $i+18; for fl8 -> $i+22
		 	else {print OUT " $a[$i+$start]\_nonprolyl\_$i\_$AA[$i+1]";}	 ### for fl6 -> $i+18; for fl8 -> $i+22
			}
		    if($i==$fl1)	#fl6 -> $i==5; fl8 -> $==7
			{open FILE,"../rin/pdb$pdb.rin" or die "cant open rin file";
			 @dat = <FILE>; close FILE;
			foreach $z(@dat)
				{$resnum =  substr($z,9,4);$chid = substr($z,8,1);$AMINO = substr($z,4,3);
				 if(($chid eq $ch)&&($resnum == $res+$FL))	### for fl6 -> $res+6; for fl8 -> $res+8
					{if($AMINO eq 'PRO') {print OUT " $a[$i+$start]\_prolylcis\_$i\_$three2one{$AMINO}";}	 ### for fl6 -> $i+18; for fl8 -> $i+22
		 			 else {print OUT " $a[$i+$start]\_nonprolyl\_$i\_$three2one{$AMINO}";}		 ### for fl6 -> $i+18; for fl8 -> $i+22
					}
				}
			}
		     }
		  print OUT "\n";
		 }
		}
	}
