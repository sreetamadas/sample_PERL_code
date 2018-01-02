#!/usr/bin/perl -w
# to find pdb-frags matching with impfrags using seq-similarity based matches from BLAST

$stime = localtime(); print "$stime\n";

$FL = 6; ### fragment length

# read impfrag info
#$dir1 = 'impfrag';
$infile2 = "impfraginfo"; # p_le_0.05  ;p_test
open FRG,"../../$infile2" or die "cant open $infile2\n"; #### info for fixed fragments
#open FRG,"$infile2" or die "cant open imp frag file"; #### info for fixed fragments
%frag = ();
while (<FRG>)
  {chomp $_;
  ($pdbfile,$fragseq,$cis,$go) = split '\t+',$_;
   $frag{$pdbfile.'_'.$go} = $fragseq.' '.$cis; # saves fraginfo: key => pdb.ch-start_GOF; value => fragseq.' '.position-of-res-b4-cis
  }
close FRG;

# read pisces pdb information, these are the moving fragments
$infile1 = "seq_aa"; # seq_100_0.05 # seq_aa
$outfile = "impfrag_100_0.05_aa"; open OUT,">$outfile";
open IN,"$infile1" or die "cant open $infile1\n";
while (<IN>)
	{chomp $_;
	#($pdb,$go,$cisinfo) = split '\t',$_;
	 ($pdb,$go,$cisinfo,$aa,$num) = split '\t+',$_; @NUM = split ',',$num;

	 %cispep = ();
	 if($cisinfo ne ' xx')  # %cispep has info of cispep posn in PDBfile
		{@raw = split ' ',$cisinfo;
	 	foreach $term (@raw) {$cispep{substr($term,3)}=substr($term,3);}
		}
	 $cnt = 0;

	 foreach $j (sort keys%frag)
		{# save impfrag seq
		 @CIS = split " ",$frag{$j}; # cispeptide position in important fragment
		 $fragseq =  shift @CIS; #$chk = 0;

		 print "$pdb  $j\n";

		 # compare frags using seq. similarity matrix
         $op = 12; $ep = 2; #8,6 # choose the GAP PENALTIES to be either equal or ep = op+1
         #$op = 10; $ep = 0.5; # default setting in EMBOSS needle
		 # $op = 11, $ep = 1; # default setting in BLAST

		 $matrix = 'BLOSUM45'; # PAM30,BLOSUM80  ###BLOSUM80 BLOSUM62 BLOSUM50 BLOSUM45 PAM250 BLOSUM62_20 BLOSUM90 PAM30 PAM70
         open TMP1,">1.fasta"; print TMP1 ">1\n$fragseq";  # print TMP "\>1\n$seq1\n\>2\n$seq2\n";
         open TMP2,">2.fasta"; print TMP2 ">2\n$aa"; close TMP1; close TMP2;
		#`/home/ramak/sreetama/Document/blast/bin/bl2seq -p blastp -i 1.fasta -j 2.fasta -W 2 -o blast.out`;
        `/home/ramak/sreetama/Document/blast/bin/bl2seq -p blastp -i 1.fasta -j 2.fasta -W 2 -M $matrix -G $op -E $ep -e 20000 -o blast.out`;
		#`/home/mcqueen/softwares/blast/bin/bl2seq -p blastp -i 1.fasta -j 2.fasta -W 2 -M $matrix -G $op -E $ep -e 20000 -o blast.out`;

         @seqdata = ();
         #open DAT,"out.needle" or die "cant open out.needle\n";
		 open DAT,"blast.out" or die "cant open blast.out\n";
         @seqdata = <DAT>; close DAT;
         #`rm 1.fasta 2.fasta out.needle`;
		 `rm 1.fasta 2.fasta blast.out`;

         # to make filehandle hot
         select((select(STDOUT), $|=1)[0]);
         select((select(STDERR), $|=1)[0]);
         select((select(OUT), $|=1)[0]);
		 #$blaststart = '';
		 #for $loop(0..$#seqdata)
		#	{if($seqdata[$loop] =~ /^>/) {$blaststart = $loop; last;}
			 #else {goto 1;}
		#	}
		 #if(defined $blaststart)
		  #{print "$blaststart\n";
		  for $pp(0..$#seqdata) #for $pp($blaststart..$#seqdata)
			{chomp($seqdata[$pp]);
			 $hit .= $seqdata[$pp]." ";
			 if($seqdata[$pp] =~ /^Sbjct/)
				{chomp($hit); $identity = (split ' ',(split 'Identities = ',$seqdata[$pp-4])[1])[0];
				$similarity = (split ' ',(split 'Positives = ',$seqdata[$pp-4])[1])[0];
				 if($hit =~ /6\/6 \(/ && $hit !~ /Gaps =/ && $identity eq '5/6' && $similarity eq '5/6' || $similarity eq '5/5') # || $hit =~ /5\/6 \(/ || $hit =~ /4\/6 \(/ || $hit =~ /\/5 \(/
					{$init = (split '\s+|\t+',$seqdata[$pp])[1];
					 @AAA = split '',$aa;$pdbseq = '';
					 for $tt(0..$FL-1) {$pdbseq .= $AAA[$tt+$init-1];}
					 #$pdbseq = (split '\s+|\t+',$seqdata[$pp])[2];
					 $similarity = (split ' ',(split 'Positives = ',$seqdata[$pp-4])[1])[0];
					 my $inipep1; my $inipep2;
					 $inipep1 = $init + $CIS[0];
					 if($#CIS > 0) {$inipep2 = $init + $CIS[1];}
					 else {$inipep2 = '';}
					 $flg = 0; 

					 if(exists $cispep{$inipep1} || exists $cispep{$inipep2}) {print OUT "$pdb\-$go\_$NUM[$init]\_$pdbseq\t$j\_$fragseq\tcis_posmatch\t$similarity\t";$flg++;}	#
					 else{
					      foreach $pdbpep(sort keys%cispep)
						{if($pdbpep >= $init && $pdbpep <= $init+$FL-1) {print OUT "$pdb\-$go\_$NUM[$init]\_$pdbseq\t$j\_$fragseq\tcis_MISmatch\t$similarity\t";$flg++;last;} #FL6 <6; FL8 <8	# && (abs($inipep1-$pdbpep)< 6|| abs($inipep2-$pdbpep)< 6)
						}
					      }
					 if($flg == 0) {print OUT "$pdb\-$go\_$NUM[$init]\_$pdbseq\t$j\_$fragseq\ttrans\t$similarity\t";}
					 $cnt++;
					 $start = $init - 1;
					 if(substr($aa,$start,$FL) =~ /!/) {print OUT "break_in_match";}
					 print OUT "\n";
					}
				 $hit = "";
				}
			}
		  #}
		}
		if($cnt == 0) {print OUT "$pdb\-$go\tnoprediction\n";}
	}
close IN;

$stime = localtime(); print "$stime\n";
#############################################################################################################################

sub trim
{
my $str = $_[0];
$str=~s/^\s*(.*)/$1/;
$str=~s/\s*$//;
return $str;
}
