#!/usr/bin/perl -w
# check match position

$aa = 'adfgkjhg'; $ba = 'dfgk';	# length of frag = 4
while($aa =~m/$ba/g) {$init = pos($aa)-4+1; print "start pos: $init\n";}

# start pos: 2
