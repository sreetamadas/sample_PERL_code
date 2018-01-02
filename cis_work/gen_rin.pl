#!/usr/bin/perl -w
# to create rin files for pisces pdbs
#=pod
%pdb = ();
open In,"pisces_list" or die "cant open main list";
@list = <In>; close In;
foreach $file (@list)
	{chomp $file;
	 open IN,"$file" or die "cant open pisces file";
	 while (<IN>)
		{#$pdb{substr($_,0,4)}++; ### to be used for generating rin files
		 $pdb{substr($_,0,5)}++; ### to be used gor generating cis & seq. info 
		}
	 close IN;
	}
#open OUT,">list";	### to be used for generating rin files
open OUT,">rin_list";	### to be used for generating cis & seq. info from rin files
foreach $i(sort keys %pdb)
	{print OUT "$i\n";}
#=cut
=pod
open IN,"list" or die "cant open list of pisces pdbs\n";
while(<IN>)
{chomp $_;
#$i = '9pcy.pdb';
$i = $_.".pdb";
$fil = rand(10000)+10000;
open TMP, ">$fil" or die "Cannot open file\n";
printf TMP ("./a.out << EOF\n%s\nEOF\n",$i);
close TMP;
`chmod +x $fil; ./$fil; rm -f $fil`; #print "$i\n";
}
close IN;
#`< $i`;
=cut
