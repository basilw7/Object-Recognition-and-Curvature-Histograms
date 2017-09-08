#!/usr/bin/env perl
#use warnings;
$overallstarttime = time();
$resolution = 30; #set the resolution of the program here. 100 is the maximum from the obj files
use Math::Trig;
$pi = 3.141592654;
#http://www.perl.com/doc/FAQs/FAQ/oldfaq-html/Q4.13.html
sub round {
    my($number) = shift;
    return int($number + .5 * ($number <=> 0));
}
$rotate = $pi/72; #sets the resolution of the rotations, default $pi/72
@parts = (0,0,1);#( create prototype histogram files , create piece histogram files, compare created files)



print ("Tasks:\n");
if($parts[0]){print ("create prototype histogram files\n");}
if($parts[1]){print ("create piece histogram files\n");}
if($parts[2]){print ("compare created files\n");}
print ("Correct? ");
if (<> =~ /n/){die("Please correct tasks\n");}



if($parts[0]){
$totalstarttime = time();
opendir (folder, ".") or die ("Could not find data directory\n");
@files = readdir(folder);
foreach $line (@files){
	($n,$x) = split (/\./ , $line);
	if ($x =~ /prototype/){push (@prt, $line);}
}
closedir(folder);
print ("The data folder contains ".@files." files\n".@prt." are prototype obj files\n");
print Olog ("The data folder contains ".@files." files\n".@prt." are prototype obj files\n");
undef @files;
$num_files = @prt;

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
while ($inputfile = $prt[0]){
$filestarttime = time();
$starttime = time();
@outfile = split (/\./, $ARGV[0]);
shift (@prt);
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
open (OFile1, ">data/$outF");
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

#rotate object #(x,y,z) -> (x,y) 
@sheet = ();
foreach $line (@points) {#??? I don't think so.... Now I'm not sure... might be. Works now
	($vertex, $x1, $y1, $z1) = split(/ /, $line); 
	#print debug ("($vertex, $x1, $y1, $z1)Rotated becomes\n");
	($x1, $y1) = (( ($sheetsize/2) + ($resolution*$x1) ) , ( ($sheetsize/2) + ($resolution*$y1) ));#! change ($resolution*$x2) to ($resolution*$x1) to stop rotation
	($x1, $y1) = (int($x1), int($y1));
	#print debug ("($vertex, $x1, $y1, $z1)\nBecomes\t");
	if (($x1 < 0) or ($y1 < 0)){die("negative coordinate in sheet!!!\n $line\n($x1, $y1)\n")};
	$i = $sheetsize*$y1 + $x1;
	#print debug (" $i\n");
	push (@sheet, $i);
}
@sheet = sort {$a <=> $b} @sheet;#contiue here! make index based caluations
undef @points;
#print out sheet here?
if (0){
$x = $y = $index1 = $index2 = 0;
while($y < $sheetsize){
	$x = 0;
	while ($x < $sheetsize){
		$index1 = ($y*$sheetsize) + $x;
		if ($index1 == $sheet[$index2]){
			print debug ("*");
			$index2++;
			while ($sheet[$index2] == $sheet[($index2 + 1)]){$index2++;}#don't repeat!
		}else{
			print debug (" ");
		}
		$x++;
	}
	print debug ("\n");
	$y++;
}
}
$index = 1;
while($index <= $sheetsize){
	@temp = ();
	while (($sheet[0] < ($index*$sheetsize)) and (@sheet)){#loads one line of sheet object
		push (@temp, shift(@sheet));
	}
	if (!(@temp)){
		$index++;
		next;
	}
	$min = shift (@temp);
	$x1 = int ($min / $sheetsize) - ($sheetsize/2);
	$y1 = int ($min % $sheetsize) - ($sheetsize/2);
	if ($x1 == 0){
		$angle_rad = ($pi/2);
	if ($y1 < 0){$angle_rad = $angle_rad + 2*$pi;}
	}else{
		$angle_rad = atan($y1 / $x1);
	}	
	if($x1 < 0){
		$angle_rad = $angle_rad + ($pi);
	}elsif(($x1 >= 0) and ($y1 < 0)){
		$angle_rad = $angle_rad + (2*$pi);
	}	
	push(@edges,"$angle_rad $x1 $y1");#The angle is from the center of the sheet or centroid
	if (@temp){
		$max = pop (@temp);
				$x2 = int ($max / $sheetsize) - ($sheetsize/2);
		$y2 = int ($max % $sheetsize) - ($sheetsize/2);
		if ($x2 == 0){
			$angle_rad = ($pi/2);
		if ($y2 < 0){$angle_rad = $angle_rad + 2*$pi;}
		}else{
			$angle_rad = atan($y2 / $x2);
		}
		if($x2 < 0){
			$angle_rad = $angle_rad + ($pi);
		}elsif(($x2 >= 0) and ($y2 < 0)){
			$angle_rad = $angle_rad + (2*$pi);
		}				
		push(@edges,"$angle_rad $x2 $y2");#The angle is from the center of the sheet or centroid
	}
	undef @temp;
	$index++;
}
undef @sheet;
@edges = sort {$a <=> $b} @edges;

#calulate curvature
$index = 0;
while ($index < @edges){
	($angle_rad, $x1, $y1) = split (/ /, $edges[(($index + 0) % @edges)]); #modulo connects the last point to the first
	($angle_rad, $x2, $y2) = split (/ /, $edges[(($index + 1) % @edges)]);
	($angle_rad, $x3, $y3) = split (/ /, $edges[(($index + 2) % @edges)]);
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
}

if($parts[1]){

$totalstarttime = time();
opendir (folder, ".") or die ("Could not find data directory\n");
@files = readdir(folder);
foreach $line (@files){
	($n,$x) = split (/\./ , $line);
	if ($x =~ /piece/){push (@piece, $line);}
}
closedir(folder);
print ("The data folder contains ".@files." files\n".@piece." are piece hst files\n");
print Olog ("The data folder contains ".@files." files\n".@piece." are piece hst files\n");
undef @files;
$num_files = @piece;

#http://www.dreamincode.net/forums/showtopic16545.htm
$date = join(':', ((localtime(time))[5])+1900,((localtime(time))[4]+1), (localtime(time))[3,2,1,0]);

open (Olog, ">>histlog.txt");
open (debug, ">debug.txt");
#print debug ("\n\n\nDebug started $date\nresolution = $resolution rotate = $rotate\n");
print Olog ("\n\n\nresolution = $resolution rotate = $rotate\nThis entry started $date\n");

#open files
while ($inputfile = $piece[0]){
$filestarttime = time();
$starttime = time();
@outfile = split (/\./, $piece[0]);
shift (@piece);
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
			#print debug ("$lines[$index1]\n");
	}
	$index1++
}
$num_lines = @lines;
$index1 = $index2= 0;
#$interval = $num_lines / 10;
$outF = "$outfile[0]".".hst";
open (OFile1, ">data/$outF");
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
	my $tempx = $x1 - $x; #print ("$x1 to $tempx. Moved $x units\n");
	my $tempy = $y1 - $y; #print ("$xy to $tempy. Moved $y units\n");
	my $tempz = $z1 - $z; #print ("$xz to $tempz. Moved $z units\n");
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
#print ("completed in $timeinterval \bsec\nStarting x-z plane rotation\t");
#print Olog ("completed in $timeinterval \bsec\nStarting x-z plane rotation\t");
print ("completed in $timeinterval \bsec\nStarting plane rotations\t");
print Olog ("completed in $timeinterval \bsec\nStarting plane rotations\t");

#rotate object #(x,y,z) -> (x,y) 
$plane = 0;
$starttime = time();
while ($plane < 2){
	$rad = 0;
	while($rad < 2*$pi){
		$rad += $rotate;
		$SI = sin($rad);
		$CS = cos($rad);
		$index = 0;
		@sheet = ();
		print OFile1 ("R $plane $rad\n");#write histogram to file
		print debug ("R $plane $rad\n\n");
		foreach $line (@points) {#??? I don't think so.... Now I'm not sure... might be. Works now
			($vertex, $x1, $y1, $z1) = split(/ /, $line); 
			#print debug ("($vertex, $x1, $y1, $z1)Rotated becomes\n");
			if ($plane == 0) {$x1 = ($x1*$SI + $z1*$CS);}#x-z plane rotation ($x2, $y2) = ( round($x1*$CS - $z1*$SI) , round($x1*$SI + $z1*$CS) ); from test script
			if ($plane == 1) {$y1 = ($y1*$SI + $z1*$CS);}#rotate points ( only the y points are needed for the calulation) ($x1, $y1) = ( ($y1*$CS - $z1*$SI) , (($y1*$SI + $z1*$CS) ) <- equ. for y-z plane
			($x1, $y1) = (( ($sheetsize/2) + ($resolution*$x1) ) , ( ($sheetsize/2) + ($resolution*$y1) ));#! change ($resolution*$x2) to ($resolution*$x1) to stop rotation
			($x1, $y1) = (int($x1), int($y1));
			if ($plane == 1){ #matches the axis to the rotation so that average amount of edges stay about the same
				($y1,$x1) = ($x1,$y1);
				($y2,$x2) = ($x2,$y2);
				($y3,$x3) = ($x3,$y3);
			}
			#print debug ("($vertex, $x1, $y1, $z1)\nBecomes\t");
			if (($x1 < 0) or ($y1 < 0)){die("negative coordinate in sheet!!!\n $line\n($x1, $y1)\n")};
			$i = $sheetsize*$y1 + $x1;
			#print debug (" $i\n");
			push (@sheet, $i);
		}
		@sheet = sort {$a <=> $b} @sheet;#contiue here! make index based caluations
		#print debug (@sheet."\n");
#		foreach $line (@sheet){
			#print ("$line\n")
#		}
		#finding edges from the @sheet object
		$index = 1;
		while($index <= $sheetsize){
			@temp = ();
			#print debug ("$index $sheetsize\n\n");
			#print debug ("$sheet[0] ".($index*$sheetsize));
			#print debug ("Index=$index $sheet[0] <".($index*$sheetsize)."\n");
			while (($sheet[0] < ($index*$sheetsize)) and (@sheet)){#loads one line of sheet object
				push (@temp, shift(@sheet));
			}
			#print debug ("points loaded ".@temp."\n");
			if (!(@temp)){
				$index++;
				next;
			}
			$min = shift (@temp);
			$x1 = int ($min / $sheetsize) - ($sheetsize/2);
			$y1 = int ($min % $sheetsize) - ($sheetsize/2);
			if ($x1 == 0){
				$angle_rad = ($pi/2);
			if ($y1 < 0){$angle_rad = $angle_rad + 2*$pi;}
			}else{
				$angle_rad = atan($y1 / $x1);
			}	
			if($x1 < 0){
				$angle_rad = $angle_rad + ($pi);
			}elsif(($x1 >= 0) and ($y1 < 0)){
				$angle_rad = $angle_rad + (2*$pi);
			}	
			push(@edges,"$angle_rad $x1 $y1");#The angle is from the center of the sheet or centroid
			if (@temp){
				$max = pop (@temp);
				#print debug ("Min=$min Max=$max\n");
	
				$x2 = int ($max / $sheetsize) - ($sheetsize/2);
				$y2 = int ($max % $sheetsize) - ($sheetsize/2);
				#print debug ("$x1 $y1 $x2 $y2\n");
				if ($x2 == 0){
					$angle_rad = ($pi/2);
				if ($y2 < 0){$angle_rad = $angle_rad + 2*$pi;}
				}else{
					$angle_rad = atan($y2 / $x2);
				}
				if($x2 < 0){
					$angle_rad = $angle_rad + ($pi);
				}elsif(($x2 >= 0) and ($y2 < 0)){
					$angle_rad = $angle_rad + (2*$pi);
				}				
				push(@edges,"$angle_rad $x2 $y2");#The angle is from the center of the sheet or centroid
			}
			undef @temp;
			$index++;
		}
		undef @sheet;
		@edges = sort {$a <=> $b} @edges;
		#foreach $line (@edges){
			#print debug ("$line\n");
		#}
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
			print debug ("$index Dis= $distance Curve= $curvature\n");
			$index++;
		}
		undef @edges;	
	}
	$plane++;
}
undef @points;
close(File1);
close(OFile1);
$finishtime = time();
$timeinterval = $finishtime - $starttime;
print ("completed in $timeinterval \bsec\n");
print Olog ("completed in $timeinterval \bsec\n");
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
print ("Total running time was $hours:$min:$sec\n\n");
print Olog ("Total running time was $hours:$min:$sec\n");
close(Olog);
close(debug);
exit;



}

if($parts[2]){
$totalstarttime = time();
$date = join(':', ((localtime(time))[5])+1900,((localtime(time))[4]+1), (localtime(time))[3,2,1,0]);

open (Olog, ">>histlog.txt");
print ("compare hist auto start time:\n $date\n");
print Olog ("compare hist auto start time:\n $date\n");
open (debug, ">debug.txt");
opendir (folder, "data") or die ("Could not find data directory\n");
@files = readdir(folder);
foreach $line (@files){
	($n,$x) = split (/\./ , $line);
	if ($x =~ /prt/){push (@prt, $line);}
	if ($x =~ /hst/){push (@hst, $line);}
}
closedir(folder);
print ("The data folder contains ".@files." files\n".@prt." are prototype files\n".@hst." are histogram files\n");
print Olog ("The data folder contains ".@files." files\n".@prt." are prototype files\n".@hst." are histogram files\n");
undef @files;
$num_files = @prt + @hst;

while ($inputfile1 = shift (@prt)){
$hst_index = 0;
open (File1, "data/$inputfile1");#prototype 
print ("Opening $inputfile1 please wait...\n");
print Olog ("Opening $inputfile1 please wait...\n");
@test = split (/\./, $inputfile1);
if ($test[1] =~ /prt/){
	chomp (@prototype = <File1>);
}else{
	print Olog ("$inputfile1 is not a .prt\nPlease place prototype file first and the files to be compared following\n");
	die("$inputfile1 is not a .prt\nPlease place prototype file first and the files to be compared following\n");
}
shift (@prototype);#gets rid of the indentifing information of the .prt file
pop(@prototype);#gets rid of the blank last line
($i , $indentifer) = split(/ /, $prototype[0]); 
undef $i;
while ($hst_index < @hst){
$inputfile2 = $hst[$hst_index++];
$starttime = time();
@t = split (/\./, $inputfile2);
open (File2, "data/$inputfile2") or die("$inputfile2 could not be found!\n");#file being compared
if ($t[1] =~ /hst/){
	chomp(@temp = <File2>);
}else{
	print ("$inputfile2 is not a .hst\nPlease place histogram after the first file \n");
	print Olog ("$inputfile2 is not a .hst\nPlease place histogram after the first file \n");
	next;
}
undef @t;
@test = ();
pop(@temp);
foreach $line (@temp){
	if ($line =~ /R/){
		shift (@temp);
	}else{
		push (@test, shift(@temp));
	}
}
undef @temp;
$finishtime = time();
$timeinterval = $finishtime - $starttime;
print ("Data from $inputfile2 prepared in $timeinterval \bsec\nStarting comparison of  $inputfile1 and $inputfile2\n");
print Olog ("Data from $inputfile2 prepared in $timeinterval \bsec\nStarting comparison of  $inputfile1 and $inputfile2\n");
$starttime = time();
$index = 0;
while ($index < @test){
	($i , $curvature) = split(/ /, $test[$index++]); 
	undef $i;
	if ( abs(($indentifer - $curvature) / $indentifer ) == 0 ){#begin comparison
		$index1 = $index;
		$index2 = 0;
		$total = 0;
		$sum = 0;
		while ($index2 < @prototype){
			$sum += $prototype[$index2]*(1 - abs( ($test[($index1 % @test)] - $prototype[$index2]) / $prototype[$index2] ));#allow for loop back
			$total += $prototype[$index2];#weights the amount of curvature into the calulation (Straight lines have less weight)
			$index1++;
			$index2++;
		}
		push (@match , sprintf("%.3f",($sum / $total)));
	}
}
@match = sort {$a <=> $b} @match;
#while ($match[0] < 0){shift(@match);}#thorws out negative overall matches
$best = pop(@match);
$worst = shift(@match);
undef @match;
$finishtime = time();
$timeinterval = $finishtime - $starttime;
print ("completed in $timeinterval \bsec\nCorrelation: Best = $best Worst = $worst\n");
print Olog ("completed in $timeinterval \bsec\nCorrelation: Best = $best Worst = $worst\n");
push (@results, "$inputfile1 $inputfile2 $best $worst");
close(File2);
}
close (File1);
}
$index = 0;
while  ($index < @results){#puts the pieces first, prt second
	($i1, $i2, $b, $w) = split(/ /, $results[$index]);
	#$results[$index] = "$i2 $i1 $b";
	$results[$index] = "$i2 $i1 ".($b + $w);
	$index++;
}
@results = sort (@results);
open (res, ">data/results.txt");
foreach $line (@results){
	print res ($line."\n");
}
close (res);
while ($line = shift(@results)){#fix
	print debug ($line."\n");
	($i1, $i2, $confidence) = split(/ /, $line);
	($i1_2, $i2_2, $confidence) = split(/ /, $results[0]);
	push (@temp, "$confidence $i1 $i2");
	if (($i1 !~ /$i1_2/) or !@results){
		print debug ("the above is the last piece ($i1, $i1_2)\n");
		@temp = sort {$a <=> $b} @temp;
		push (@finalresults, pop(@temp));
		undef @temp;
	}
}
$totalfinishtime = time();
$totaltimeinterval = $totalfinishtime - $totalstarttime;
$sec = int($totaltimeinterval % 60);
$min = int(($totaltimeinterval % 3600) / 60);
$hours = int($totaltimeinterval / 3600);
#print ("$num_files files processed in $hours:$min:$sec\n\nThe results are:\n");
#print Olog ("$num_files files processed in $hours:$min:$sec\n\nThe results are:\n");
print ("$num_files files processed in $hours:$min:$sec\n\nThe results are in results.txt\n");
print Olog ("$num_files files processed in $hours:$min:$sec\n\nThe results are in results.txt\n");
open (res, ">data/results.txt");
print ("\n\tFinal Results\n\n");
foreach $line (@finalresults){
	($c, $i1, $i2) = split(/ /, $line);
	print ("$i1 belongs to $i2 confidence: $c\n");
	print res ("$i1 belongs to $i2 confidence: $c\n");
	#print ("$i1 belongs to $i2 confidence: $c\n");
}	
close (res);
close (debug);
close (Olog);
print ("\a");
}
$overallfinishtime = time();
$overalltimeinterval = $overallfinishtime - $overallstarttime;
$sec = int($overalltimeinterval % 60);
$min = int(($overalltimeinterval % 3600) / 60);
$hours = int($overalltimeinterval / 3600);
#print ("$num_files files processed in $hours:$min:$sec\n\nThe results are:\n");
#print Olog ("$num_files files processed in $hours:$min:$sec\n\nThe results are:\n");
print ("$Overall runtime $hours:$min:$sec\n\n");
print Olog ("$Overall runtime $hours:$min:$sec\n\n");

exit;