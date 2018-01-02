#!/usr/bin/perl -w
#rearranging input data
open FILE,'table.txt';
@cluster = <FILE>;
#@clust = reverse sort @cluster;
#print "@clust\n";
#foreach(@cluster)				#($i=0;$i<=$#cluster;$i++)	    
#	{  $_ = reverse $_;
	   #print "$data[$i]";
#	}
print "@cluster";
close FILE;
exit;

