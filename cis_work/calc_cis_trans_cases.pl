#!/usr/bin/perl -w
# to select similar datasizes for calculation of TP & FP

open FILE,"filename" or die "cant open list of files";
@file = <FILE>; close FILE;
open OUT,">tp_fp_modified";
print OUT "seq%\tp-val\tcismatch\tcisGOmatch\tcisGOnomatch\ttrans\ttransGOmatch\ttransGOnomatch\n";
foreach $infile(@file)
   {@CISGOMATCH = @CISGONOMATCH = @TRANSGOMATCH = @TRANSGONOMATCH = ();
    print "$infile";
    for($x=0; $x <30; $x++)	## calculate 30 times
	{@cis = @noncis = (); # noncis includes cis_MISmatch & trans
	 chomp $infile;
	 open IN,"$infile" or die "cant open file";
	 while (<IN>)
		{if($_ =~ /cis_MISmatch/ || $_ =~ /trans/) {push @noncis,$_;}
		 if($_ =~ /cis_posmatch/) {push @cis,$_;}
		}
	 close IN;
	 if($#noncis <= $#cis) {$size = $#noncis+1;}
	 else {$size = $#cis+1;}
	 $cisgomatch = $cisgonomatch = $transgomatch = $transgonomatch = 0;
	 for ($k = 0; $k < $size; $k++)		#while ($size > 0) # (scalar @cis > 0)
		{my $f = int(rand(scalar @noncis));	# int(rand($size))
		#push @localnoncis, $noncis[$f];
		 ($whole,$imp,$type) = split '\t',$noncis[$f];
		  @go_whole = split "-",(split "_",$whole)[0];	### CHECK HERE FOT NEW FPRMAT OF INPUT FILE
		  shift (@go_whole);	# removes 1st element of array, here the pdb id
		  $go_imp = (split "_", $imp)[2];
		  $flag = 0;
		  foreach $i (@go_whole)
			{if($i eq $go_imp) {$flag++;}	### if there is GO match $flag > 0
			}
		 if($flag > 0) {$transgomatch++;}
		 else {$transgonomatch++;}
		 if(scalar @noncis > 1)
       			{@noncis = ( @noncis[0..($f-1)], @noncis[($f+1)..$#noncis] );}
		 else
       			{shift @noncis;}
		}
	 for ($k = 0; $k < $size; $k++)	#while ($size > 0)	# (scalar @cis > 0)
		{my $f = int(rand(scalar @cis));	# int(rand($size))
		#push @localcis, $cis[$f];
		($whole,$imp,$type) = split '\t',$cis[$f];
		  @go_whole = split "-",(split "_",$whole)[0];
		  shift (@go_whole);	# removes 1st element of array, here the pdb id
		  $go_imp = (split "_", $imp)[2];
		  $flag = 0;
		  foreach $i (@go_whole)
			{if($i eq $go_imp) {$flag++;}	### if there is GO match $flag > 0
			}
		 if($flag > 0) {$cisgomatch++;}
		 else {$cisgonomatch++;}
		 if(scalar @cis > 1)
       			{@cis = ( @cis[0..($f-1)], @cis[($f+1)..$#cis] );}
		 else
       			{shift @cis;}
		}
	 push @CISGOMATCH, $cisgomatch; push @CISGONOMATCH, $cisgonomatch; push @TRANSGOMATCH, $transgomatch; push @TRANSGONOMATCH, $transgonomatch;
	}
	$cisgomatch = $cisgonomatch = $transgomatch = $transgonomatch = 0;
	for $j (0..$#CISGOMATCH)
		{$cisgomatch = $cisgomatch + $CISGOMATCH[$j];
		 $cisgonomatch = $cisgonomatch + $CISGONOMATCH[$j];
		 $transgomatch = $transgomatch + $TRANSGOMATCH[$j];
		 $transgonomatch = $transgonomatch + $TRANSGONOMATCH[$j];
		}
	 $cisgomatch = $cisgomatch/($#CISGOMATCH + 1);
	 $cisgonomatch = $cisgonomatch/($#CISGOMATCH + 1);
	 $transgomatch = $transgomatch/($#CISGOMATCH + 1);
	 $transgonomatch = $transgonomatch/($#CISGOMATCH + 1);
	 print OUT "",(split "_",$infile)[3],"\t",(split "_",$infile)[4],"\t",$size,"\t$cisgomatch\t$cisgonomatch\t",$size,"\t$transgomatch\t$transgonomatch\n";
   }
