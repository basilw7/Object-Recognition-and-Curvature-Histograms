#!/usr/bin/env perl
#These are tests
$totalstarttime = time();
$resolution = 1.5; #set the resolution of the program here. 100 is the maximum from the obj files
#use warnings;
use Math::Trig;

#http://www.dreamincode.net/forums/showtopic16545.htm
$date = join(':', ((localtime(time))[5])+1900,((localtime(time))[4]+1), (localtime(time))[3,2,1,0]);

#http://www.perl.com/doc/FAQs/FAQ/oldfaq-html/Q4.13.html
sub round {
    my($number) = shift;
    return int($number + .5 * ($number <=> 0));
}
open (Olog, ">>histlog.txt");
print Olog ("\n\n\Makeing prototype histogram\nThis entry started $date\n");

#open files
while ($inputfile = $ARGV[0]){
$filestarttime = time();
$starttime = time();
@outfile = split (/\./, $ARGV[0]);
shift (@ARGV);
print ("Opening $inputfile please wait...\n");
print Olog ("Opening $inputfile please wait...\n");
open (File1, "$inputfile");
$art =  "$outfile[0]".".art";
open (debug, ">$art");
#load pts
chomp (@lines = <File1>);
$index1 = 0;
while ($index1 < 20){
	($vertex, $x1, $y1, $z1) = split(/ /, $lines[$index1]); 
	if ($vertex =~ /\#/){
			print ("$lines[$index1]\n");
			print Olog ("$lines[$index1]\n");
	}
	$index1++
}
$num_lines = @lines;
$index1 = $index2= 0;
#$interval = $num_lines / 10;
$outF = "$outfile[0]".".prt";
open (OFile1, ">$outF");
print ("$outF will be created\n");
print Olog ("$outF will be created\n");
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
undef @lines; #delete initial information loaded from file 
$finishtime = time();
$timeinterval = $finishtime - $starttime;
$num_points = @points;
print ("completed in $timeinterval \bsec\n$inputfile has $num_lines lines and $num_points of those are vertices\n");
print Olog ("completed in $timeinterval \bsec\n$inputfile has $num_lines lines and $num_points of those are vertices\n");
$starttime = time();

#find centroid
{
my $index = 0;
my $x_total = 0;
my $y_total = 0;
my $z_total = 0;
while ($index < @points) {
	($vertex, $x1, $y1, $z1) = split(/ /, $points[$index]); 
	$x_total += $x1;
	$y_total += $y1;
	$z_total += $z1;
	$index++;
}
$x = $x_total / @points;
$y = $y_total / @points;
$z = $z_total / @points;
$x = sprintf("%.3f",$x );
$y = sprintf("%.3f",$y );
$z = sprintf("%.3f",$z );
print ("The Centroid is located at:\n$x $y $z\nMoving centroid to origin\t");
print Olog ("The Centroid is located at:\nn$x $y $z\nMoving centroid to origin\t");
}
#translate points (moving origin to the centoid)
$index = $farthest = 0;
while ($index < @points) {
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
$precision = int((log ($sheetsize) / log(10)) + 1); #converts to base 10
print ("creating surface\nsheetsize = $sheetsize x $sheetsize\n"); 
print Olog ("creating surface\nsheetsize = $sheetsize x $sheetsize\n"); 
$finishtime = time();
$timeinterval = $finishtime - $starttime;
print ("completed in $timeinterval \bsec\nStarting plane rotations\n");
print Olog ("completed in $timeinterval \bsec\nStarting plane rotations\n");
print OFile1 ("R P\n");#write histogram to file
$index = 0;
while ($index < @points) {#??? I don't think so.... Now I'm not sure... might be. Works now
	($vertex, $x1, $y1, $z1) = split(/ /, $points[$index++]); 
	($x1, $y1) = (( ($sheetsize/2) + ($resolution*$x1) ) , ( ($sheetsize/2) + ($resolution*$y1) ));#! change ($resolution*$x2) to ($resolution*$x1) to stop rotation
	($x1, $y1) = (int($x1), int($y1));
	print debug ("($vertex, $x1, $y1, $z1) - > ($x1, $y1)\n ");
	if (($x1 < 0) or ($y1 < 0)){die("negative coordinate in sheet!!!\n")};
	$i = $sheetsize*$y1 + $x1;
	$sheet[$i] = 1;
}

#print out sheet here
$x = $y = 0;
while($y < $sheetsize){
	$x = 0;
	while ($x < $sheetsize){
		$index = ($y*$sheetsize) + $x;
		$i = int($sheet[$index]);
		print debug ("$i");
		$x++;
	}
	print debug ("\n");
	$y++;
}


#finding edges from the @sheet object
$index_x = $index_y = 0;
$temp1 = int($sheet[0]);
while($index_y < $sheetsize){
	$index_x = 0;
	$first = $last = 0;
	while($index_x < $sheetsize ){
		$x = $index_x - ($sheetsize/2);
		$y = $index_y - ($sheetsize/2);
		$index = $sheetsize*$index_y + $index_x;
		$temp2 = int($sheet[$index]);
		#first condition leading edge
		if ( ($first == 0) and ($temp1 == 0) and ($temp2 == 1)) {
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
			push(@edges,"$angle_rad $x $y");#The angle is from the center of the sheet or centroid
			$first = 1;
		}	
		#second condition trailling edge
		if ( ($first == 1) and ($temp1 == 1) and ($temp2 == 0) ) {# ($first == 1) should be possible to remove this code
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
			if ($last == 1){pop(@edges);}
			push(@edges,"$angle_rad $x $y");#The angle is from the center of the sheet
			$last = 1;
		}
		$temp1 = $temp2;
		$index_x++;	
	}
	$index_y++;
}
undef @points;
undef @sheet;
@edges = sort {$a <=> $b} @edges;

#calulate curvature
$index = 0;
while ($index < @edges){
	($angle_rad, $x1, $y1) = split (/ /, $edges[(($index + 0) % @edges)]); #modulo connects the last point to the first
	($angle_rad, $x2, $y2) = split (/ /, $edges[(($index + 1) % @edges)]);
	($angle_rad, $x3, $y3) = split (/ /, $edges[(($index + 2) % @edges)]);
	$index++;	
	#print debug ("($x1,$y1) ($x2, $y2) ($x3, $y3)\n");
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
			$curvature = 999999;
			print OFile1 ("$index $curvature\n");#write histogram to file
		}else{
			$curvature = 1 / $distance;
			$curvature = sprintf("%.".$precision."f",$curvature ); 
			print OFile1 ("$index $curvature\n");#write histogram to file
		}	
		$c = 0;#stop the loop
		}
		if ((abs ($new_offset)) > (abs($old_offset))){#we have passed the intersection
			$jump = -0.1*$jump;
		}
		$old_offset = $new_offset;
	}
	#print debug ("$index Dis= $distance Curve= $curvature\n");
	$index++;
}
undef @edges;
close(File1);
close(OFile1);
$filefinishtime = time();
$filetimeinterval = $filefinishtime - $filestarttime;
$sec = int($filetimeinterval % 60);
$min = int(($filetimeinterval % 3600) / 60);
$hours = int($filetimeinterval / 3600);
print("The time to process $inputfile\nand create $outF and $art was\n$hours:$min:$sec \n");
print(Olog "The time to process $inputfile\nand create $outF and $art was\n$hours:$min:$sec \n");
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
close(debug);
exit;

