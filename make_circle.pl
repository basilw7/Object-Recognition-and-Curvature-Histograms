#!/usr/bin/env perl
use warnings;

open (OutFile1, ">circle.obj");
#	print ("Outstream created succesfully\n");
#}else{
#	die("File stream error\n");
#)
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;

print OutFile1 ("#  Mon Jan 21 $hour:$min:$sec $year\n\n# Object name : Hemisphere\n# \ng\n");
$pi = 3.141592654;
$index = 0;
$points = 10000;
while ($index <= $points){
	$index++;
	$x = 94 - 2*(rand(94));
	$y = (sqrt((94**2) - $x**2));
	if (rand(2) > 1){$y = -$y;}
	$z = 0;
	print ("v $x $y $z\n");
	
	print OutFile1 ("v $x $y $z\n");
}
close(OutFile1);

