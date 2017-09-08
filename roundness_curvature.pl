#!/usr/bin/env perl
#This file reads curvature histogram files
#this doesn't work correct curvature algorithim is in create_hist.pl

use warnings;

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


($vertex, $x1, $y1) = split(/ /, $points[$index++]); #the first point
while($index < $num_points){
	($vertex, $x2, $y2) = split(/ /, $points[$index++]); #the second point if not a vertex start over
	if ($vertex =~ /v/){
			($vertex, $x3, $y3) = split(/ /, $points[$index++]);
			($Midpt1_x, $Midpt1_y) = (($x2 + $x1) / 2), (($y2 + $y1) / 2 );
			if ( ($x2 - $x1) == 0){
				$slope = 999999;
			}else{
				$slope = ($y2 - $y1) / ($x2 - $x1);
			}
			$slope_L1 = -$slope;
			($Midpt2_x, $Midpt2_y) = (($x3 + $x2) / 2), (($y3 + $y2) / 2 );
			if ( ($x3 - $x2) == 0){
				$slope = 999999;
			}else{
				$slope = ($y3 - $y2) / ($x3 - $x2);
			}
			$slope_L2 = -$slope;
			
			#Creating conditions for while statement
			$L1y_temp = $Midpt1_y - $slope_L1*($Midpt1_x);
			$L2y_temp = $Midpt2_y - $slope_L1*($Midpt2_x);
			$old_offset = ($L1y_temp - $L1y_temp)
			$jump =1000;
				while(true){
					$Gx += rand($jump);
					$L1y_temp = $Midpt1_y - $slope_L1*($Gx - $Midpt1_x);
					$L2y_temp = $Midpt2_y - $slope_L1*($Gx - $Midpt2_x);
					$new_offset = ($L1y_temp - $L1y_temp)
					if ((abs($new_offset - $old_offset)< 0.001)){
						($inter_x, $inter_y) = ($L1y_temp, $Gx);
						print ("$inter_x $inter_y\n");
						$radius = sqrt( ($x1 - $inter_x)**2 + ($y1 - $inter_y)**2 )
						if ( $distance == 0){
							$curvature = 999999;
							print OFile1 ("$curvature\t");
						}else{
							$curvature = 1 / $distance;
						print OFile1 ("$curvature\t");
						}	
						exit;
					}
					if (($old_offset*$new_offset) < 0){#we have passed the intersection
						$jump = -0.1*$jump;
					}
					$old_offset = $new_offset;
				}
			#moving point for next iliteration
			($x1, $y1) = ($x2, $y2);
			($x2, $y2) = ($x3, $y3);
	}
	($x1, $y1) = ($x2, $y2);
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
