#!/usr/bin/env perl
#These are tests
#use warnings;
$totalstarttime = time();
use Math::Trig;
$resolution = 1; #set the resolution of the program here. 100 is the maximum from the obj files
$pi = 3.141592654;
$rotate = $pi/4; #sets the resolution of the rotations, default $pi/72

#http://www.dreamincode.net/forums/showtopic16545.htm
$date = join(':', ((localtime(time))[5])+1900,((localtime(time))[4]+1), (localtime(time))[3,2,1,0]);

#http://www.perl.com/doc/FAQs/FAQ/oldfaq-html/Q4.13.html
sub round {
    my($number) = shift;
    return int($number + .5 * ($number <=> 0));
}
open (Olog, ">>histlog.txt");
open (debug, ">debug.txt");
print debug ("\n\n\nDebug started $date\nresolution = $resolution rotate = $rotate\n");
print Olog ("\n\n\nresolution = $resolution rotate = $rotate\nThis entry started $date\n");

#open files
while ($inputfile = $ARGV[0]){
$filestarttime = time();
$starttime = time();
@outfile = split (/\./, $ARGV[0]);
shift (@ARGV);
print ("Opening $inputfile please wait...\n");
print Olog ("Opening $inputfile please wait...\n");
open (File1, "$inputfile");
#load pts
chomp (@lines = <File1>);
$index1 = 0;
while ($index1 < 20){
	($vertex, $x1, $y1, $z1) = split(/ /, $lines[$index1]); 
	if ($vertex =~ /\#/){
			print ("$lines[$index1]\n");
			print Olog ("$lines[$index1]\n");
			print debug ("$lines[$index1]\n");
	}
	$index1++
}
$num_lines = @lines;
$index1 = $index2= 0;
#$interval = $num_lines / 10;
$outF = "$outfile[0]".".hst";
print ("$outF will be created\n");
print Olog ("$outF will be created\n");
open (OFile1, ">$outF");
print ("Looking for verticies\t\t");
print Olog ("Looking for verticies\t\t");
while ($index1 < $num_lines){
	#if (($index1 % $interval) == 0){print ("*");}
	($vertex, $x1, $y1, $z1) = split(/ /, $lines[$index1]); 
	if ($vertex =~ /v/){
		$points[$index2] = $lines[$index1];
		$index2++;
	}	
	$index1++
}	
@lines = (); #delete initial information loaded from file 
$finishtime = time();
$timeinterval = $finishtime - $starttime;
$num_points = @points;
$end = $num_points;
print ("completed in $timeinterval \bsec\n$inputfile has $num_lines lines and $num_points of those are vertices\n");
print Olog ("completed in $timeinterval \bsec\n$inputfile has $num_lines lines and $num_points of those are vertices\n");



$starttime = time();
#find centroid
$index = 0;
$x_total = 0;
$y_total = 0;
$z_total = 0;
while ($index < $num_points) {
	($vertex, $x1, $y1, $z1) = split(/ /, $points[$index]); 
	$x_total += $x1;
	$y_total += $y1;
	$z_total += $z1;
	$index++;
}
$x = $x_total / $num_points;
$y = $y_total / $num_points;
$z = $z_total / $num_points;
$x = sprintf("%.3f",$x );
$y = sprintf("%.3f",$y );
$z = sprintf("%.3f",$z );
$centroid = "$x $y $z";
print ("The Centroid is located at:\n$centroid\nMoving centroid to origin\t");
print Olog ("The Centroid is located at:\n$centroid\nMoving centroid to origin\t");


#translate points (moving origin to the centoid)
$index = $farthest = 0;
while ($index < $num_points) {
	($vertex, $x1, $y1, $z1) = split(/ /, $points[$index]); 
	$tempx = $x1 - $x; #print ("$x1 to $tempx. Moved $x units\n");
	$tempy = $y1 - $y; #print ("$xy to $tempy. Moved $y units\n");
	$tempz = $z1 - $z; #print ("$xz to $tempz. Moved $z units\n");
	$points[$index] = "$vertex $tempx $tempy $tempz";
	$radius = sqrt (($tempx**2) + ($tempy**2) + ($tempz**2));
	if ($radius > $farthest){$farthest = $radius};
	$index++;
}
$sheetsize = int(10 + (2*$farthest*$resolution));
$index_x = $index_y = 0;
while($index_y < $sheetsize ){
	$index_x = 0;
	while($index_x < $sheetsize ){
		$index = $size_x*$index_y + $index_x;
		$sheet[$index] = 0;
		$index_x++;
	}
	$index_y++;
}
	
	#debugging
	$x = $y = 0;
	while($y < $sheetsize){
		$x = 0;
		while ($x < $sheetsize){
			$index = ($y*$size_x) + $x;
#			print debug ("$sheet[$index]");
			$x++;
		}
#	print debug ("\n");
	$y++;
	}
	
	
	
	
print ("creating surface\nsheetsize = $sheetsize x $sheetsize\n"); #this can be removed later confirms level of accuracy
print Olog ("creating surface\nsheetsize = $sheetsize x $sheetsize\n"); #this can be removed later confirms level of accuracy

$finishtime = time();
$timeinterval = $finishtime - $starttime;
print ("completed in $timeinterval \bsec\nStarting x-z plane rotation\t");
print Olog ("completed in $timeinterval \bsec\nStarting x-z plane rotation\t");
$starttime = time();
#rotate object #(x,y,z) -> (x,y) 
$i1 = 0;
$rad = 0;
@edges = ();
while($rad < 2*$pi){
	$rad += $rotate;
	$SI = sin($rad);
	$CS = cos($rad);
	$index = 0;
	#print("$rad\n");
	while ($index < $end) {#??? I don't think so.... Now I'm not sure... might be.
		($vertex, $x1, $y1, $z1) = split(/ /, $points[$index++]); 
#		print debug ("($x1, $y1) rotated became ");
		$x2 = ($x1*$SI + $z1*$CS);#x-z plane rotation ($x2, $y2) = ( round($x1*$CS - $z1*$SI) , round($x1*$SI + $z1*$CS) ); from test script
#		print debug ("($x2, $y1) and the sheet placement is\n");
		($x2, $y1) = (( ($sheetsize/2) + ($resolution*$x2) ) , ( ($sheetsize/2) + ($resolution*$y1) ));#! change ($resolution*$x2) to ($resolution*$x1) to stop rotation
#		print debug ("($x2, $y1) rounded to ");
		($x2, $y1) = (int($x2), int($y1));
#		print debug ("($x2, $y1)");
		if (($x2 < 0) or ($y1 < 0)){die("negative coordinate in sheet!!!\n")};
		$i = $sheetsize*$y1 + $x2;
		$sheet[$i] = 1;
#		print debug ("inserted to index $i\n\n");
	}
	$x = $y = 0;
	while($y < $sheetsize){
		$x = 0;
		while ($x < $sheetsize){
			$index = $sheetsize*$y + $x;
			$i = int($sheet[$index]);
#			print debug ("$i");
			$x++;
		}
#	print debug ("\n");
	$y++;
	}
	
	#finding edges from the @sheet object
	$il = $index_x = $index_y = 0;
	$temp1 = int($sheet[0]);
	while($index_y < $sheetsize){
	$index_x = 0;
	$first = $last = 0;
		while($index_x < $sheetsize ){
			$x = $index_x - ($sheetsize/2);
			$y = $index_y - ($sheetsize/2);
			$index = $sheetsize*$index_y + $index_x;
			$temp2 = int($sheet[$index]);
#			print debug ("Temp values: $temp1 & $temp2 index = $index\n");
			#first condition leading edge
			if ( ($first == 0) and ($temp1 == 0) and ($temp2 == 1)) {
#				print debug ("Leading edge @ $index\n");
				if ($x == 0){
					$angle_rad = ($pi/2);
					if ($y < 0){$angle_rad = $angle_rad + 2*$pi;}
				}else{
					$angle_rad = atan($y / $x);
				}
				if($x < 0){
					$angle_rad = $angle_rad + ($pi);
				}elsif(($x >= 0) and ($y < 0)){
					$angle_rad = $angle_rad + (2*$pi);
				}	
				$new_edges[$i1] = "$angle_rad $x $y";#The angle is from the center of the sheet
				$first = 1;
				$i1++;#sets index for the trailling edge

			}	
			#second condition trailling edge
			if ( ($first == 1) and ($temp1 == 1) and ($temp2 == 0) ) {# ($first == 1) should be possible to remove this code
#				print debug ("Trailling edge @ $index\n");
				if ($x == 0){
					$angle_rad = ($pi/2);
					if ($y < 0){$angle_rad = $angle_rad + 2*$pi;}
				}else{
					$angle_rad = atan($y / $x);
				}
				if($x < 0){
					$angle_rad = $angle_rad + ($pi);
				}elsif(($x >= 0) and ($y < 0)){
					$angle_rad = $angle_rad + (2*$pi);
				}
				$new_edges[$i1] = "$angle_rad $x $y";#The angle is from the center of the sheet
				$last = 1;
			}
		$sheet[$index] = 0;#clears sheet as it is beening read
		$temp1 = $temp2;
		$index_x++;	
		}
	if ($last == 1){$il++}#advances index if trailling edge is found	
	$index_y++;
	}
	$sheet[$index] = 0;
	@new_edges = sort {$a <=> $b} @new_edges;
	@edges = (@edges,@new_edges);
	print debug ("new_edges from sheet\n");
	$x = 0;
	while($x < @new_edges){
		print debug ("$new_edges[$x]\n");
		$x++;
	}
	print debug ("\n\n");
	@new_edges = (); 
	@sheet = ();
	print debug ("old edges with new_edges sorted and from sheet\n");
	$x = 0;
	while($x < @edges){
		print debug ("$edges[$x]\n");
		$x++;
	}
	print debug ("\n\n");
}
$finishtime = time();
$timeinterval = $finishtime - $starttime;
print ("completed in $timeinterval \bsec\nStarting y-z plane rotation\t");
print Olog ("completed in $timeinterval \bsec\nStarting y-z plane rotation\t");
print debug ("The finished product\n");
$x = 0;
while($x < @edges){
	print debug ("$edges[$x]\n");
	$x++;
}

$starttime = time();
$i1 = 0;
$rad = 0;
while($rad < 2*$pi){
	$rad += $rotate;
	$SI = sin($rad);
	$CS = cos($rad);
	$index = 0;
	#print("$rad\n");
	while ($index < $end) {#??? I don't think so.... Now I not sure... might be.
		($vertex, $x1, $y1, $z1) = split(/ /, $points[$index++]); 
		#rotate points ( only the y points are needed for the calulation) ($x1, $y1) = ( ($y1*$CS - $z1*$SI) , (($y1*$SI + $z1*$CS) ) <- equ. for y-z plane
		$y1 = ($y1*$SI + $z1*$CS);	
		($x2, $y1) = (( ($sheetsize/2) + ($resolution*$x2) ) , ( ($sheetsize/2) + ($resolution*$y1) ));
		($x2, $y1) = (round($x2), round($y1));
		if (($x2 < 0) or ($y1 < 0)){die("Error! Negative coordinate in sheet!!!\n")};
		$sheet[$sheetsize*$y1 + $x2] = 1;
	}
	
	#finding edges from the @sheet object
	$il = $index_x = $index_y = 0;
	$temp1 = $sheet[0];
	while($index_y < $sheetsize ){
	$index_x = 0;
		while($index_x < $sheetsize ){
			$first = 0;
			$x = $index_x - ($sheetsize/2);
			$y = $index_y - ($sheetsize/2);
			#print("$x $y\n");
			$index = $size_x*$index_y + $index_x;
			$temp2 = $sheet[$index];
			#first condition leading edge
			if ( ($first == 0) and ($temp1 == 0) and ($temp2 == 1)) {
				if ($x == 0){
					$angle_rad = ($pi/2);
				if ($y < 0){$angle_rad = -$angle_rad;}
				}else{
					$angle_rad = atan($y / $x);
				}
				if(($x < 0) and ($y >= 0)){
					$angle_rad = -$angle_rad + ($pi/2);
				}elsif(($x < 0) and ($y < 0)){
					$angle_rad = $angle_rad + ($pi);
				}elsif(($x >= 0) and ($y < 0)){
					$angle_rad = -$angle_rad + (3*$pi/2);
				}
				$new_edges[$i1] = "$angle_rad $x $y";#The angle is from the center of the sheet
				$first = 1;
				$i1++;#sets index for the trailling edge
				#print("Leading edge @ $index\n");

			}
			#second condition trailling edge
			if ( ($temp1 == 1) and ($temp2 == 0) ) {
					if ($x == 0){
					$angle_rad = ($pi/2);
				if ($y < 0){$angle_rad = -$angle_rad;}
				}else{
					$angle_rad = atan($y / $x);
				}
				if(($x < 0) and ($y >= 0)){
					$angle_rad = -$angle_rad + ($pi/2);
				}elsif(($x < 0) and ($y < 0)){
					$angle_rad = $angle_rad + ($pi);
				}elsif(($x >= 0) and ($y < 0)){
					$angle_rad = -$angle_rad + (3*$pi/2);
				}
				$new_edges[$i1] = "$angle_rad $x $y";#The angle is from the center of the sheet
				#print("Trailling edge @ $index\n");
			}
		$sheet[$index] = 0;
		$temp1 = $temp2;
		$index_x++;
		}
	$index_y++;
	}
	$sheet[$index] = 0;
	$sheet[$index - 1] = 0;
	@new_edges = sort {$a <=> $b} @new_edges;
	@edges = (@edges,@new_edges);
	@new_edges = (); 
$finishtime = time();
$timeinterval = $finishtime - $starttime;
print ("completed in $timeinterval \bsec\n$num_edges edges created\nFinding curvature\n");
print Olog ("completed in $timeinterval \bsec\n$num_edges edges created\nFinding curvature\n");

#find curvature
$starttime = time();
$index = 0;
while ($index < @edges){
	($angle_rad, $x1, $y1) = split (/ /, $edge[(($index + 0) % @edges)]); #modulo connects the last point to the first
	($angle_rad, $x2, $y2) = split (/ /, $edge[(($index + 1) % @edges)]);
	($angle_rad, $x3, $y3) = split (/ /, $edge[(($index + 2) % @edges)]);
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
$finishtime = time();
$timeinterval = $finishtime - $starttime;
print ("Curvature histogram for $inputfile created in $timeinterval \bsec\n Writing data to file\n");
print Olog ("Curvature histogram for $inputfile created in $timeinterval \bsec\n Writing data to file\n");

# create histogram file
$starttime = time();
$index = 0;
while($index < @curvature){
	print OFile1 ("$index $curvature[$index]\n");
	$index++;
}
$finishtime = time();
$timeinterval = $finishtime - $starttime;
print ("$outF created in $timeinterval \bsec\n");
print Olog ("$outF created in $timeinterval \bsec\n");
close(File1);
close(OFile1);
$filefinishtime = time();
$filetimeinterval = $filefinishtime - $filestarttime;
$sec = int($filetimeinterval % 60);
$min = int(($filetimeinterval % 3600) / 60);
$hours = int($filetimeinterval / 3600);
print("The time to process $inputfile and create $outF was $hours:$min:$sec \n");
print(Olog "The time to process $inputfile and create $outF was $hours:$min:$sec \n");
}
print ("\a");
$totalfinishtime = time();
$totaltimeinterval = $totalfinishtime - $totalstarttime;
$sec = int($totaltimeinterval % 60);
$min = int(($totaltimeinterval % 3600) / 60);
$hours = int($totaltimeinterval / 3600);
print ("Total running time was $hours:$min:$sec\n\n\n");
print Olog ("Total running time was $hours:$min:$sec\n");
close(Olog);
exit;
