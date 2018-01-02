#!/usr/bin/perl -w
#use of split and join ; push functions
print "type something separated by commas ('quit' to finish):";
while(<>)
	{
	   chomp $_;
	   last if $_ eq 'quit';
	   @field = split ',',$_;
	   @type = join "\t",@field;
	   push @input,@field;
	   $full = join "\n",@input;	   
	}
print "you entered :\n", $full,"\n";
print "type = @type\n";
print "input = @input\n";
exit;
