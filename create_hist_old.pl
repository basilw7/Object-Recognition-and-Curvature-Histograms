#!/usr/bin/env perl
#These are tests
#use warnings;
use Math::Trig;
$pi = 3.141592654;


#open files
while ($inputfile = $ARGV[0]){
@outfile = split (/\./, $ARGV[0]);
shift (@ARGV);
print ("Opening $inputfile please wait...\n");
open (File1, "$inputfile");
$outF = "$outfile[0]".".hst";
print ("$outF will be created\n");
open (OFile1, ">$outF");

#load pts
chomp (@lines = <File1>);
$num_lines = @lines;
$index1 = $index2= 0;
$interval = $num_lines / 10;
print ("Looking for verticies\t\t");
while ($index1 < $num_lines){
	#if (($index1 % $interval) == 0){print ("*");}
	($vertex, $x1, $y1, $z1) = split(/ /, $lines[$index1]); 
	if ($vertex =~ /v/){
		$points[$index2] = $lines[$index1];
		$index2++;
	}	
	$index1++
}
print ("completed\n");
$num_points = @points;
print ("$inputfile has $num_lines of lines and $num_points of those are vertices\n");
$end = $num_points;

#find centroid
$index = 0;
$x_total = 0;
$y_total = 0;
$z_total = 0;
while ($index < $end) {
	($vertex, $x1, $y1, $z1) = split(/ /, $points[$index]); 
	$x_total += $x1;
	$y_total += $y1;
	$z_total += $z1;
	$index++;
}

$x = $x_total / $end;
$y = $y_total / $end;
$z = $z_total / $end;
$centroid = "$x $y $z";
print ("The Centroid is located at:\n$centroid\n");
#translate points (moving origin to the centoid)

print ("Moving centroid to origin\t");
$index = 0;
while ($index < $end) {
	($vertex, $x1, $y1, $z1) = split(/ /, $points[$index]); 
	$tempx = $x1 - $x;
	$tempy = $y1 - $y;
	$tempz = $z1 - $z;
	$points[$index] = "$vertex $tempx $tempy $tempz";
	$index++;
}
print ("completed\n");
#rotate object #(x,y,z) -> (x,y) #find angles
$i1 = 0;
$rad = 0;
print("Starting x-z plane rotation\t");
while($rad < 2*$pi){
	$rad += $pi/72;
	$SI = sin($rad);
	$CS = cos($rad);
	$index = 0;
	print("$rad\n");
	while ($index < $end) {
		($vertex, $x1, $y1, $z1) = split(/ /, $points[$index++]); 
		$x1 = ($x1*$SI + $z1*$CS);#x-z plane rotation
		if ($x1 == 0){
			$angle_rad = ($pi/2);
			if ($y1 < 0){$angle_rad = -$angle_rad;}
		}else{
			$angle_rad = atan($y1 / $x1);
		}
		if(($x1 < 0) and ($y1 >= 0)){
				$angle_rad = -$angle_rad + ($pi/2);
		}elsif(($x1 < 0) and ($y1 < 0)){
				$angle_rad = $angle_rad + ($pi);
		}elsif(($x1 >= 0) and ($y1 < 0)){
				$angle_rad = -$angle_rad + (3*$pi/2);
		}
		$new_projected_object_xz[$i1++] = "$angle_rad $x1 $y1";
	}
	$i1 = 0;
	@new_projected_object_xz = sort {$a <=> $b} @new_projected_object_xz;
	@rotated_projected_object_xz = (@rotated_projected_object_xz,@new_projected_object_xz);
	my @new_projected_object_xz = ();
}
print ("completed\n");
print("Starting y-z plane rotation\t");
$i1 = 0;
$rad = 0;
while($rad < 2*$pi){
	$rad += $pi/72;
	$SI = sin($rad);
	$CS = cos($rad);
	$index = 0;
	print("$rad\n");
	while ($index < $end) {
		($vertex, $x1, $y1, $z1) = split(/ /, $points[$index++]); 
		#rotate points ( only the y points are needed for the calulation) ($x1, $y1) = ( ($y1*$CS - $z1*$SI) , (($y1*$SI + $z1*$SC) ) <- equ. for y-z plane
		$y1 = ($y1*$SI + $z1*$CS);
		if ($x1 == 0){
			$angle_rad = ($pi/2);
			if ($y1 < 0){$angle_rad = -$angle_rad;}
		}else{
		$angle_rad = atan($y1 / $x1);
		}
		if(($x1 < 0) and ($y1 >= 0)){
				$angle_rad = -$angle_rad + ($pi/2);
		}elsif(($x1 < 0) and ($y1 < 0)){
				$angle_rad = $angle_rad + ($pi);
		}elsif(($x1 >= 0) and ($y1 < 0)){
				$angle_rad = -$angle_rad + (3*$pi/2);
		}
		$new_projected_object_yz[$i1++] = "$angle_rad $x1 $y1";
	}
	$i1 = 0;
	@new_projected_object_yz = sort {$a <=> $b} @new_projected_object_yz;
	@rotated_projected_object_yz = (@rotated_projected_object_yz,@new_projected_object_yz);
	my @new_projected_object_yz = ();
}
print ("completed\n");

@rotated_projected_object = (@rotated_projected_object_xz,@rotated_projected_object_yz);
my @rotated_projected_object_xz = ();
my @rotated_projected_object_yz = ();

$i=0;
while($rotated_projected_object[$i]){
	($angle_rad, $x1, $y) = split(/ /, $rotated_projected_object[$i++]); 
	$dist = sqrt($x1**2 + $y**2);
}

#find edges (returns the largest value in the group)
print ("Finding edges\t");
$index = 0;
$i2 = 0;
($x, $y, $z) = split(/ /, $centroid); 
while ($index < @rotated_projected_object){
	($angle_rad, $x1, $y) = split(/ /, $rotated_projected_object[$index++]); 
	$new_angle = $angle_rad;
	my @group = ();
	$group[0] = "$x1 $y1";
	$i1 = 1;
	while (abs($angle_rad - $new_angle) < 0.005){#will always be offset by one point in the rotation 0.0003
		($new_angle, $x1, $y) = split(/ /, $rotated_projected_object[$index++]); 
		$group[$i1++] = "$x1 $y1";
	}
	$i2++;#increment for @edge
	$i1 = 0;
	$old_length = 0;
	while ($i1 < @group) {
		($x1, $y) = split(/ /, $group[$i1++]); 
		$new_length = sqrt( ($x1 - $x)**2 + ($y1 - $y)**2 );
		if ($new_length > $old_length){
			$edge[$i2] = "$x1 y1";
		}
		$old_length = $new_length;
	}
}
print ("completed\n");	

#find curvature
print ("$num_edges edges created\n");

print ("Finding curvature\n");
$index = 0;
while ($index < @edge){
	($x1, $y1) = split (/ /, $edge[(($index + 0) % @edge)]); #modulo connects the last point to the first
	($x2, $y2) = split (/ /, $edge[(($index + 1) % @edge)]);
	($x3, $y3) = split (/ /, $edge[(($index + 2) % @edge)]);
	$index++;
	
	($Midpt1_x, $Midpt1_y) = ((($x2 + $x1) / 2), (($y2 + $y1) / 2 ));
	if ( ($x2 - $x1) == 0){
		$slope = -999999;
	}else{
		$slope = ($y2 - $y1) / ($x2 - $x1);
	}
	$slope_L1 = -$slope;#the slope from pt. 1 to 2
	
	($Midpt2_x, $Midpt2_y) = ((($x3 + $x2) / 2), (($y3 + $y2) / 2 ));
	if ( ($x3 - $x2) == 0){
				$slope = -999999;
	}else{
		$slope = ($y3 - $y2) / ($x3 - $x2);
	}
	$slope_L2 = -$slope;#the slope from pt. 2 to 3


	#Creating conditions for while statement
	$L1y_temp = $Midpt1_y + $slope_L1*($Midpt1_x);
	$L2y_temp = $Midpt2_y + $slope_L2*($Midpt2_x);
	$old_offset = ($L2y_temp - $L1y_temp);
	$jump =1000;
	$c = 1;
	while($c){
		$Gx += rand($jump);
		$L1y_temp = $Midpt1_y + $slope_L1*($Gx - $Midpt1_x);
		$L2y_temp = $Midpt2_y + $slope_L2*($Gx - $Midpt2_x);
		$new_offset = ($L2y_temp - $L1y_temp);
		if ((abs($new_offset - $old_offset)< 0.00001)){
			($inter_x, $inter_y) = ($Gx, $L1y_temp);
			$distance = sqrt( ($x2 - $inter_x)**2 + ($y2 - $inter_y)**2 );
			if ($distance == 0){
				$curvature[$index] = 999999;
			}else{
				$curvature[$index] = 1 / $distance;
			}	
			$c = 0;#stop the loop
		}
		if ((abs ($new_offset)) > (abs($old_offset))){#we have passed the intersection
			$jump = -0.1*$jump;
		}
	$old_offset = $new_offset;
	}
}
print ("Curvature histogram for $inputfile created\n Writing data to file\n");
# create histogram file
$index = 0;
while($index < @curvature){
	print OFile1 ("$index $curvature[$index]\n");
	$index++;
}
print ("$outF created");
close(File1);
close(OFile1);
}
print ("\a");
exit;
