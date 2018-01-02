#!/usr/bin/perl -w
# program to prepare pdbseq file from fasta file downloaded from PISCES ( pdb seq. at variable seq identity)
@p = (0.05); #,0.04,0.02,0.01,0.008,0.006,0.005,0.004,0.002,0.001);	#0.0008,0.0005,0.0001
@seq_cut = (100); #(90,60,40,25);
%cispdb = %seq = %num = %go = ();

open RIN,"../pisces_cisinfo_corrected" or die "cant open pisces cis info";
while (<RIN>)
	{chomp $_; ($id,$cis,$AA,$t) = split '\t+',$_;
	 $cispdb{$id} = $cis;	# stores info of cispep in PISCES
	 $seq{$id} = $AA; $num{$id} = $t;
	}
close RIN;

open GO,"../final_pdb_to_GO" or die "cant open GO file";
while (<GO>)
	{chomp $_;
	 $go{substr($_,0,5)} = substr($_,6);	# GO info of all PDBs
	}
close GO;

foreach $r (@seq_cut)
	{$infile1 = "piscesPDB_".$r;
	open IN,"../$infile1" or die "cant open PISCES file";
	%pdbseq = ();
	while(<IN>)
		{chomp $_;
		 $pdbseq{substr($_,0,5)} ++;	# stores the pdb ids from PISCES fasta file
		}
	close IN;
	foreach $q(@p)
		{%PDB = ();
		 $infile2 = "p_le_".$q;
		open INPUT,"$infile2" or die "cant open";
		while (<INPUT>)
			{@a = split "_", $_;
			 $PDB{$a[4].$a[6]}++;	# stores PDB names from important frag file
			}
		close INPUT; 

		$outfile1 = "seq_".$r."_".$q;
		open OUT1,">$outfile1";
		foreach $id (sort keys %pdbseq)		### keys are pdbs from PISCES
			{if(!defined $PDB{$id})		### avoid self hits; take pdbs not present in imp frag list
				{if(defined $cispdb{$id})	# if the pdb has cis peptide
					{if(defined $go{$id})	# if the pdb has go mf
						{print OUT1 "\>$id\t$go{$id}\t$cispdb{$id}\t$seq{$id}\t$num{$id}\n";}
					 else {print OUT1 "\>$id\tf9999999\t$cispdb{$id}\t$seq{$id}\t$num{$id}\n";}
					}
				 else 	# if the pdb does not have cis peptide
					{if(defined $go{$id})
						{print OUT1 "\>$id\t$go{$id}\txx\t$seq{$id}\t$num{$id}\n";}
					else {print OUT1 "\>$id\tf9999999\txx\t$seq{$id}\t$num{$id}\n";}
					}
				}
			}
		}
	}

