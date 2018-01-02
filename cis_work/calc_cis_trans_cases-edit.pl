#!/usr/bin/perl -w
# to select similar datasizes for calculation of TP & FP
# tried on 25_1e-07

open FILE,"newfile" or die "cant open list of files"; # filename
@file = <FILE>; close FILE;
open OUT,">>tp_fp_modified";
print OUT "seq%\tp-val\tcismatch\tcisGOmatch\tcisGOnomatch\ttrans\ttransGOmatch\ttransGOnomatch\n";
foreach $infile(@file)
   {@CISGOMATCH = @CISGONOMATCH = @TRANSGOMATCH = @TRANSGONOMATCH = ();
    print "$infile";
    for($x=0; $x <30; $x++){	## calculate 30 times
	$stime = localtime();
	print "$x\t$stime\t";

	@cis = @noncis = (); # noncis includes cis_MISmatch & trans
	chomp $infile;
	@noncis = split '\n',`grep -n 'trans\\|cis_MISmatch' < $infile |cut -f1 -d:`;
	@cis = split '\n',`grep -n 'cis_posmatch' $infile |cut -f1 -d:`;

	#$noncis = `grep 'cis_MISmatch\|trans' $infile | wc -l`;
	#$cis = `grep 'cis_posmatch' $infile | wc -l`;
	#open IN,"$infile" or die "cant open file";
	#while (<IN>)
	#	{if($_ =~ /cis_MISmatch/ || $_ =~ /trans/) {push @noncis,$_;}
	#	 if($_ =~ /cis_posmatch/) {push @cis,$_;}
	#	}
	# close IN;

	 if($#noncis <= $#cis) {$size = $#noncis+1;}
	 else {$size = $#cis+1;}
	 #if($noncis <= $cis) {$size = $noncis;}
	 #else {$size = $cis;}
	#print "size: $size\n";
	 $cisgomatch = $cisgonomatch = $transgomatch = $transgonomatch = 0;

	 for ($k = 0; $k < $size; $k++)	#while ($size > 0)	# (scalar @cis > 0)
		{
		 my $f = int(rand(scalar @cis));
		 $command = "sed -n $cis[$f],$cis[$f]"."p $infile";
		($whole,$imp,$type) = split '\t',`$command`; #system("sed -n $cis[$f],$cis[$f]"."p $infile");
		#($whole,$imp,$type) = split '\t',$cis[$f];
		 #print "$whole  *  $imp  * $type\n";
		  @go_whole = split "-",(split "_",$whole)[0];
		  shift (@go_whole);	# removes 1st element of array, here the pdb id
		  @go_imp = split '-',(split '_',$imp)[1]; #$go_imp = (split "_", $imp)[2];
		  shift (@go_imp);
		  %IMP = (); foreach $nn(@go_imp) {$IMP{$nn}++;}
		  $flag = 0;
		  foreach $i (@go_whole)
			{#if($i eq $go_imp) {$flag++;}	### if there is GO match $flag > 0
			 if(defined $IMP{$i}) {$flag++;}
			}
		 if($flag > 0) {$cisgomatch++;}
		 else {$cisgonomatch++;}
		 if(scalar @cis > 1)
       			{@cis = ( @cis[0..($f-1)], @cis[($f+1)..$#cis] );}
		 else
       			{shift @cis;}
		}

	 for ($k = 0; $k < $size; $k++)		#while ($size > 0) # (scalar @cis > 0)
		{my $f = int(rand(scalar @noncis));	# int(rand($size))
		#push @localnoncis, $noncis[$f];
		$command = "sed -n $noncis[$f],$noncis[$f]"."p $infile";
		 ($whole,$imp,$type) = split '\t',`$command`;
		 #($whole,$imp,$type) = split '\t',$noncis[$f];
		 #print "$whole  *  $imp  * $type\n";
		  @go_whole = split "-",(split "_",$whole)[0];	### CHECK HERE FOT NEW FPRMAT OF INPUT FILE
		  shift (@go_whole);	# removes 1st element of array, here the pdb id
		  @go_imp = split '-',(split '_',$imp)[1]; shift (@go_imp);#$go_imp = (split "_", $imp)[2];
		  %IMP = (); foreach $nn(@go_imp) {$IMP{$nn}++;}
		  $flag = 0;
		  foreach $i (@go_whole)
			{#if($i eq $go_imp) {$flag++;}	### if there is GO match $flag > 0
			 if(defined $IMP{$i}) {$flag++;}
			}
		 if($flag > 0) {$transgomatch++;}
		 else {$transgonomatch++;}
		 if(scalar @noncis > 1)
       			{@noncis = ( @noncis[0..($f-1)], @noncis[($f+1)..$#noncis] );}
		 else
       			{shift @noncis;}
		}

	 print "$cisgomatch\t$cisgonomatch\t$transgomatch\t$transgonomatch\n";
	 push @CISGOMATCH, $cisgomatch; push @CISGONOMATCH, $cisgonomatch; push @TRANSGOMATCH, $transgomatch; push @TRANSGONOMATCH, $transgonomatch;
	# to make filehandle hot
	 select((select(STDOUT), $|=1)[0]);
	 select((select(STDERR), $|=1)[0]);
	 select((select(OUT), $|=1)[0]);
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
  	 $stime = localtime(); print "$stime\tGO matches calculated\n";
	 print OUT "",(split "_",$infile)[1],"\t",(split "_",$infile)[2],"\t",$size,"\t$cisgomatch\t$cisgonomatch\t",$size,"\t$transgomatch\t$transgonomatch\n";
   }
