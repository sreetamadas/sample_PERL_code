#!/usr/bin/perl
# This script will rearrange the go_codes and eliminate all duplicate codes in the file.
$files = "gene_ontology_ext.obo.1";
@output = ("ontology_paths.dat.func","ontology_paths.dat.proc","ontology_paths.dat.celloc");
	%go_code = ();
open go_file, "$files" or die "Cannot open file $files\n";
open out_file1, ">$output[0]" or die "Cannot open file $output[0]\n";
open out_file2, ">$output[1]" or die "Cannot open file $output[1]\n";
open out_file3, ">$output[2]" or die "Cannot open file $output[2]\n";
$i = 0;
while (<go_file>) {
	chomp;
	if (/^id: GO:/) {$child = $';}
	if (/alt_id: GO:/) {$alt_id{$child} .= $'.",";}
	if (/namespace:/ && /molecular_function/) {$namespace{$child} = 0;}
	if (/namespace:/ && /biological_process/) {$namespace{$child} = 1;}
	if (/namespace:/ && /cellular_component/) {$namespace{$child} = 2;}
	if (/is_a: GO:/) {
		$is = (split)[1];
		$is_a = (split /:/,$is)[1];
		push @{$link{$child}}, $child.":".$is_a;
		@alternate = split /,/, $alt_id{$child};
		foreach $alternate (@alternate) {
			if ($alternate ne "" ) {push @{$link{$alternate}}, $alternate.":".$is_a;}
		}}
}
close go_file;
foreach $key (keys %link) {
        foreach $i (0 .. $#{$link{$key}}) {
        print "${$link{$key}}[$i]\n";
}}
for $x (0 .. 25) {		#this value is set arbitrarily
foreach $key (keys %link) {
	foreach $i (0 .. $#{$link{$key}}) {
		@last = split /:/,${$link{$key}}[$i];
		if (exists($link{$last[-1]})) {
			foreach $j (0 .. $#{$link{$last[-1]}}) {
				$truncated = "";
				@array = split /:/,${$link{$last[-1]}}[$j];
					for $k (1 .. $#array) {
						$truncated .= $array[$k].":";
					}
				chop($truncated);
			$new = ${$link{$key}}[$i].":".$truncated;
			$ok = 0;
			foreach $l (0 .. $#{$link{$key}}) {
				if (${$link{$key}}[$l] eq $new) {$ok = 1;}
			}
			if ($ok == 0) {push @{$link{$key}}, $new;}
		}}
     }
}}
foreach $key (keys %link) {
	foreach $i (0 .. $#{$link{$key}}) {printf STDOUT ("${$link{$key}}[$i]\n");}
}
foreach $key (keys %link) {
	foreach $i (0 .. $#{$link{$key}}) {
	@last = split /:/,${$link{$key}}[$i];
     		if ($last[-1] eq "0003674") {printf out_file1 ("${$link{$key}}[$i]\n");}
     		if ($last[-1] eq "0008150") {printf out_file2 ("${$link{$key}}[$i]\n");}
     		if ($last[-1] eq "0005575") {printf out_file3 ("${$link{$key}}[$i]\n");}
}}
close out_file1;
close out_file2;
close out_file3;
