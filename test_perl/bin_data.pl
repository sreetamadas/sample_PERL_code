#!/usr/bin/perl -w

open IN, "input";
@PROPENSITY = <IN>;
close IN;			

#@freq =();#$total = $#PROPENSITY + 1;
$min = $freq = $freq2 = 0;							#= $i 
$step = 1;
$max = $min+ $step;
$lim = 5;							
#print"array size : $total\n";#print "freq : @freq\n";

for($c=0; $c<=$#PROPENSITY; $c++)
	{if($PROPENSITY[$c]<$lim)
		{if(($PROPENSITY[$c]>=$min) &&($PROPENSITY[$c]< $max))
			{$freq = $freq + 1; }			#print "$min - $max\t$freq[$i]\n";	}			# 00/$total
		else {print "$min - $max\t$freq\n";
		 	  $min = $min +$step; 
		  	  $max = $max +$step; 
			  $freq = 0;
		 	  if(($PROPENSITY[$c]-$min)<$step)
				{$freq = 1;}
			 else{#print "$min - $max\t$freq\n";
				  $min = $min +int (($PROPENSITY[$c]-$min)/$step);
				  $max = $min + $step;
				  $freq = 1;}
			}
		}
	if($PROPENSITY[$c]>=$lim)
		{print "$min - $max\t$freq\n" if ($freq != 0);
		$freq = 0;
		 $freq2 = $freq2 + 1;}
	}
print "> $lim \t$freq2\n";

#	{print "$i\n";}
