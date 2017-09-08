#!/usr/bin/env perl
#These are tests
#use warnings;

$sheetsize = 10;
$index = $index2 = 0;
while($index < $sheetsize){	
	$index2 = 0;
	while($index2 < $sheetsize){
		$sheet[$sheetsize*$index + $index2] = 0;
		$index2++;
	}
	$index++;
}
$index = $index2 = 0;
while($index < $sheetsize){	
	$index2 = 0;
	while($index2 < $sheetsize){
		print("$sheet[$sheetsize*$index + $index2] ");
		$index2++;
	}
	print("\n");
	$index++;
}
die("That's the sheet\n");

$pi = 3.141592654;
($x1, $y1) =(50, 0); 
$rad = 0;
 while($rad < 2*$pi){
	$rad += $pi/72;
	$SI = sin($rad);
	$CS = cos($rad);
	$index = $start;
	($x1, $y1) = ( ($x1*$CS + $y1*$SI) , (-$x1*$SI + $y1*$CS) );
	print ("sin($rad) = $SI\n");
}
die("Stop here\n");

$curvature_total = 0;
while ($inputfile = $ARGV[0]){
@outfile = split (/\./, $ARGV[0]);
shift (@ARGV);
print ("Opening $inputfile please wait...\n");
open (File1, "$inputfile");
chomp (@lines = <File1>);
$index = 0;
until ($index == @lines){
($i, $curvature) = split(/ /, $lines[$index++]); 
$curvature_total += $curvature;
$avg = $curvature_total;
}
}
$num = @lines;
print("$avg\n $num\n");
die("Stop here\n");

$a = int(rand(6));
print ($a,"\b\b\n");
die("Stop here\n");

@a[0] = "1 2 3";
@a[1] = "4 5 6";
@a[2] = "7 8 9";
@b[0] = "10 11 12";
@b[1] = "13 14 15";
@b[2] = "16 17 18";
 
@c = (@a, @b);
$i=0;
while($c[$i]){
	print("$c[$i++]\n");
}
die("$i2 Stop here\n");

@input = split (/\./, $ARGV[0]);
print ("$ARGV[0]\n");
print ("$input[0]\n");
print ("$input[1]\n");



$index = 0;
while ($input[$index++] = $ARGV[0]){
shift (@ARGV);
}
$index = @input;
print ("$index elements\n");
$index = 0;
while($index < @input){
	$index++;
	print ("$index\n");
}

die("done\n");


#use Date::Format;
#use Date::Parse;
foreach my $date ('28-09-2006', '28-sep-2006') {
	my $newDate = $oldDate;
    $newDate =~ s/^(\d{2})-(\d{2})-(\d{4})$/$2-$1-$3/; # Only include this line if you are assuming european style dates.  Ie, the day of the month number comes before the month number
	my @dateArray = strptime($newDate);
	$newDate = strftime("%m-%d-%Y", @dateArray);
print "Old Date = '$date' .... New Date = '$newDate'\n";
}

($sec,$min,$hour,$mday,$mon,$year,$wday,
$yday,$isdst)=localtime(time);
print ("($sec,$min,$hour,$mday,$mon,$year,$wday,
$yday,$isdst)=localtime(time);\n");
die("up here\n");

print ("x1\n");
chomp ($x1 = <STDIN>);
print ("y1\n");
chomp ($y1 = <STDIN>);
print ("x2\n");
chomp ($x2 = <STDIN>);
print ("y2\n");
chomp ($y2 = <STDIN>);
print ("x3\n");
chomp ($x3 = <STDIN>);
print ("y3\n");
chomp ($y3 = <STDIN>);



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
	
print ("$Midpt1_x $Midpt1_y\n $slope_L1\n $Midpt2_x $Midpt2_y\n $slope_L2\n");

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
		if ((abs($new_offset - $old_offset)< 0.001)){
			($inter_x, $inter_y) = ($Gx, $L1y_temp);
			print ("$inter_x $inter_y\n");
			$distance = sqrt( ($x2 - $inter_x)**2 + ($y2 - $inter_y)**2 );
			if ($distance == 0){
				$curvature = 999999;
				print OFile1 ("$curvature\t");
			}else{
				$curvature = 1 / $distance;
			print OFile1 ("$curvature\t");
			}	
			$c = 0;#stop the loop
		}
		if ( (abs ($new_offset)) > (abs($old_offset))){#we have passed the intersection
			print ("turn around!\n");
			$jump = -0.1*$jump;
		}
		$old_offset = $new_offset;
}
print ("$inter_x $inter_y\n");
print ("$curvature\n");
die("Stop\n");
