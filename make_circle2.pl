#!/usr/bin/env perl
use warnings;
use Math::Trig;
$pi = 3.141592654;

open (OutFile1, ">circle.obj");
#	print ("Outstream created succesfully\n");
#}else{
#	die("File stream error\n");
#)
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;

print OutFile1 ("#  Sun Mar 2 $hour:$min:$sec $year\n\n# Object name : Circle\n# \ng\n");
$pi = 3.141592654;
$rad= 0;
$radius = 100;
$points = 10000;
while ($rad <= (2*$pi)){
	$rad += 2*$pi/$points;
	$x = $radius*(sin($rad));
	$y = $radius*(cos($rad));
	$z = 0;
	$x = sprintf("%.3f",$x );
	$y = sprintf("%.3f",$y );
	$z = sprintf("%.3f",$z );
	print ("v $x $y $z\n");
	
	print OutFile1 ("v $x $y $z\n");
}
close(OutFile1);
exit;

