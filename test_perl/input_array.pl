#!/root/sreetama/perl -w
#take input as array and print it
for($i=0;$i<5;$i++)
  {
    $a[$i] = <STDIN>;
   # @a[$i] = <STDIN>;
  }
print "input array = @a\n";
print "array size = ",$#a+1,"\n";
exit;

# for reading individual array elements use $a[$i] and not @a[$i]
