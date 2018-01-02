#!/usr/bin/perl -w
#to check how single and double quotes work

print ' enter a no. ? ';
$x = <>;
print "(dbl qt) value of $x is $x \n ";
print '(singl qt) val of $x is $x \n ',"\n";
print "(dbl qt+slash) val of \$x is $x \n";
print "(qt in qt) val of \$x is \"$x\"\n";
print "(sing qt inside dbl) val of \$x is '$x'\n";
exit ;

