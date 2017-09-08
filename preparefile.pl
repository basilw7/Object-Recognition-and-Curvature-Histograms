#!/usr/bin/env perl
#use warnings;

$inputfile = $ARGV[0];
$outputfile = $ARGV[1];

open (File1, "$inputfile");
open (OFile1, ">$outputfile");

chomp (@points = <File1>);
$num_points = @points;
print ("$length\n");

$index = 0;
$index1 = 0;
@radius = 0;

while($index < $num_points){
	$x = $points[$index++];
	$y = $points[$index++];
	$z = $points[$index++];
	$radius[$index1++] = sqrt (($x*$x) + ($y*$y) + ($z*$z));
	print OFile1 ("\n$x \t$y \t$z\n Radius = $radius[($index1 - 1)]\n");
}


$radius_length = @radius;
$index = 0;

while($index < $radius_length){
	$total += $radius[$index++];
	print OFile1 ("$radius[$index] was added. Total = $total\n");
}

$average = ($total/$radius_length);
print OFile1 ("The average radius is $average\n");
$relation = 1;
$index = 0;
while($index < $radius_length){
	$temp = abs (($average - $radius[$index++]) / $average) / $radius_length;
	print OFile1 ("Weighted Percent difference = $temp\n");
	$relation -= $temp;
}

print ("\n\n\t$relation\n");

close(File1);
close(OFile1);
