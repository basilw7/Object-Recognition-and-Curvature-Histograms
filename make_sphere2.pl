#!/usr/bin/env perl
use warnings;

open (OutFile1, ">sphere.obj");
#	print ("Outstream created succesfully\n");
#}else{
#	die("File stream error\n");
#)
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;

print OutFile1 ("#  Mon Feb 25 $hour:$min:$sec $year\n\n# Object name : Sphere\n# \ng\n");
$pi = 3.141592654;
$count = $theta = $phi = 0;
$radius = 25;
$points = 300;

while ($phi <= (2*$pi)){
	$phi += 2*$pi/$points;
	$theta = 0;
	while ($theta <= (2*$pi)){
		$theta += 2*$pi/$points;	
		$x = $radius*(sin($theta))*(sin($phi));
		$y = $radius*(sin($theta))*(cos($phi));
		$z = $radius*(cos($theta));
		$x = sprintf("%.3f",$x );
		$y = sprintf("%.3f",$y );
		$z = sprintf("%.3f",$z );
		print ("v $x $y $z\n");
		print OutFile1 ("v $x $y $z\n");
		$count++;
	}
}
print ($count, " points created\n");
close(OutFile1);

