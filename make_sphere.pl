#!/usr/bin/env perl
use warnings;

open (OutFile1, ">sphere.obj");
#	print ("Outstream created succesfully\n");
#}else{
#	die("File stream error\n");
#)
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;

print OutFile1 ("#  Sun Jan 16 $hour:$min:$sec $year\n\n# Object name : Sphere\n# \ng\n");
$index = 0;
$radius = 200;
while ($index <= 100){
	$index++;
	$x = rand($radius);
	if (rand(2) > 1){$x = -$x;}
	$y = rand(sqrt(($radius**2) - $x**2));
	if (rand(2) > 1){$y = -$y;}
	$z = sqrt($radius**2 - $x**2 - $y**2);
	if (rand(2) > 1){$z = -$z;}
	print ("v $x $y $z\n");
	
	print OutFile1 ("v $x $y $z\n");
}

close(OutFile1);

