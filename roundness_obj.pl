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
$vertx_count = 0;

while($index < $num_points){
	($vertex, $x, $y, $z) = split(/ /, $points[$index++]);
	print ("\n$index vertex# $vertex $temp\nx=$x \ty=$y \tz=$z\n");
	if ($vertex =~ /v/){
		$radius[$index1++] = sqrt (($x**2) + ($y**2) + ($z**2));		
		print OFile1 ("\n$index $temp\nx=$x \ty=$y \tz=$z\n Radius = $radius[($index1 - 1)]\n");
	}
}

$num_points = $vertx_count;
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
print OFile1 ("\n\n\t$relation\n");

close(File1);
close(OFile1);
