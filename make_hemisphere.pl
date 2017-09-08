#!/usr/bin/env perl
use warnings;

open (OutFile1, ">hemisphere.obj");
#	print ("Outstream created succesfully\n");
#}else{
#	die("File stream error\n");
#)
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;

print OutFile1 ("#  Mon Feb 25 $hour:$min:$sec $year\n\n# Object name : Hemisphere\n# \ng\n");
$index = 0;
while ($index <= 10000){
	$index++;
	$x = rand(94);
	$y = rand(sqrt((94**2) - $x**2));
	$z = sqrt(94**2 - $x**2 - $y**2);
	$x = sprintf("%.3f",$x );
	$y = sprintf("%.3f",$y );
	$z = sprintf("%.3f",$z );
	print ("v $x $y $z\n");
	print OutFile1 ("v $x $y $z\n");
}
close(OutFile1);

