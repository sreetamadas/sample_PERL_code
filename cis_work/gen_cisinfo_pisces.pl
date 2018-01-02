#!/usr/bin/perl -w
# to generate seq & cispep info for pisces files
%AA = ('ALA' => 'A', 'ARG' => 'R', 'ASN' => 'N', 'ASP' => 'D', 'CYS' => 'C', 'GLN' => 'Q', 'GLU' => 'E', 'GLY' => 'G', 'HIS' => 'H', 'ILE' => 'I',
       'LEU' => 'L', 'LYS' => 'K', 'MET' => 'M', 'PHE' => 'F', 'PRO' => 'P', 'SER' => 'S', 'THR' => 'T', 'TRP' => 'W', 'TYR' => 'Y', 'VAL' => 'V', 'MSE' => 'M');

open IN,"out" or die "cant open list of pisces rin files"; # rin_list  test_list
open OUT,">out_cisinfo";	# pisces_cisinfo  test
@list = <IN>; close IN;
foreach $term (@list)
	{chomp $term;
	 $pdb = substr($term,0,4); $ch = substr($term,4,1);
	 open RIN,"./rin/$pdb.rin" or die "cant open rin file";
	 @angle = (); $aa = ''; @seq = @info = (); $num = '';
	 while(<RIN>)
		{$CH = substr($_,8,1);
		 if($CH eq $ch) 
		 {$omega = trim (substr($_,29,7));
		 if(substr($_,7,1) eq '!')		### save seq and angle info
			{if($omega == 999.90) {$aa .= '!'; push @angle, 'break'; $num .= ','.trim(substr($_,9,4));} # res where break starts
			 elsif(abs($omega)<= 90)	# res after break
				{push @angle, 'cis'; $num .= ','.trim(substr($_,9,4));
				 if(defined $AA{substr($_,4,3)}) {$aa .= $AA{substr($_,4,3)};}
				 else {$aa .= 'X';}
				}
			 else {push @angle, 'trans'; $num .= ','.trim(substr($_,9,4));	# res after break
				 if(defined $AA{substr($_,4,3)}) {$aa .= $AA{substr($_,4,3)};}
				 else {$aa .= 'X';}
			      }
			}
		 else
			{if(abs($omega)<= 90)
				{push @angle, 'cis'; $num .= ','.trim(substr($_,9,4));
				 if(defined $AA{substr($_,4,3)}) {$aa .= $AA{substr($_,4,3)};}
				 else {$aa .= 'X';}
				}
			 else {push @angle, 'trans'; $num .= ','.trim(substr($_,9,4));
				 if(defined $AA{substr($_,4,3)}) {$aa .= $AA{substr($_,4,3)};}
				 else {$aa .= 'X';}
			      }
			}
		 }
		}
	 close RIN;
	 @seq = split '',$aa; $flg = 0;
	 foreach $i(0..$#angle)
		{if($angle[$i] =~ /cis/) {my $pos; $pos = $i+1; push @info, $seq[$i].$seq[$i+1]."_".$pos;$flg++;}  # residues forming cispep
		}
	 print OUT "$term\t";
	 if($flg > 0)   {foreach $j(0..$#info) {print OUT " $info[$j]";}
			}
	 else {print OUT " xx";}
	 print OUT "\t$aa\t$num\n";
	}


sub trim
{
my $str = $_[0];
$str=~s/^\s*(.*)/$1/;
$str=~s/\s*$//;
return $str;
}
