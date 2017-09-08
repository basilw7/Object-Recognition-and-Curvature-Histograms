#!/usr/bin/env perl
#use warnings;


use Math::Trig;
$pi = 3.141592654;
$angle = -$pi/12;


opendir (folder,".") or die ("Could not find data directory\n");
@files = readdir(folder);
closedir(folder);

$total = 0;
foreach $line (@files){
	($n,$x) = split (/\./ , $line);
	if ($n =~ /file/){
		$total++;
	}
}
undef @files;
open (out, ">files".++$total.".txt") or die ("Could not make files".++$total."\n");;
close (out);
die();



print ("\260\n");
die();

opendir (folder,".") or die ("Could not find data directory\n");
@files = readdir(folder);
closedir(folder);
print ("prototype files\n");
foreach $line (@files){

	print ($line."\n");
}
undef @files;
open (out, "file/files.txt") or die ("Could not make file.txt\n");;
foreach $line (@files){
	print out ($line."\n");
}
close (out);
die();


$i1 = "yep";
@results = ("yep 5 5", "no 3 5", "maybe 90 7");
$i1_2 = "yep";
$val = $il =~ /$i1_2/;
print ("$i1 $i1 $val\n");
if ($i1 !~ /$i1_2/){
	print ("Yes\n");
}else{
	print ("No\n");
}
die();


opendir (folder, "/My Programs") or die ("Could not find data directory\n");
@files = readdir(folder);
foreach $line (@files){
	($n,$x) = split (/\./ , $line);
	if ($x =~ /prt/){push (@prt, $line);}
	if ($x =~ /hst/){push (@hst, $line);}
}
undef @files;
closedir(folder);
print ("prototype files\n");
foreach $line (@prt){
	print ($line."\n");
}
print ("histogram files\n");
foreach $line (@hst){
	print ($line."\n");
}
die();

print (abs (-1)."\n");
die();

open (debug, ">debug.txt");
while ($inputfile = shift (@ARGV)){
open (File1, "$inputfile");
$total = 0;
foreach $line (<File1>){
	if ($line =~ /R/){
		push (@list, $total);
		push (@list, $line);
		$total = 0;
	}else{
		$total++;
	}
}
push (@list, $total);
$print = join ("\n",@list);
print debug ($print);
}
close (debug);
die();


($x,$y) = (2, 4);
print ("($x,$y)\n");
($y,$x) = ($x,$y);
print ("($x,$y)\n");

die();

@test = (1,2,4,5,7);
@test2 = (1,2,4,5,7);
push (@test, 8);
push (@test2, shift (@test));
print ("@test2\n");

die();



$totalstarttime = time();
while ($inputfile = $ARGV[0]){
@outfile = split (/\./, $ARGV[0]);
shift (@ARGV);
open (File1, "$inputfile") or die("$inputfile could not be found!");
$outF = "$outfile[0]"."-m.hst";
print ("Moving $inputfile \b's origin to centroid\n");
open (OFile1, ">$outF");
$total = $x_total = $y_total = $z_total = 0;
foreach $lines (<File1>){
	($vertex, $x1, $y1, $z1) = split(/ /, $lines); 
	if ($vertex =~ /v/){
		$total++;
		$x_total += $x1;
		$y_total += $y1;
		$z_total += $z1;
	}

}
if ($total == 0){die("$inputfile has no vertices! $outF could not be created\n")};
$x = sprintf("%.3f", ($x_total / $total) );
$y = sprintf("%.3f", ($y_total / $total) );
$z = sprintf("%.3f", ($z_total / $total) );
seek (File1, 0, 0);
foreach $lines (<File1>){
	($vertex, $x1, $y1, $z1) = split(/ /, $lines); 
	if ($vertex =~ /v/){
		sprintf("%.3f", ($tempx = $x1 - $x) ); #print ("$x1 to $tempx. Moved $x units\n");
		sprintf("%.3f", ($tempy = $y1 - $y) ); #print ("$xy to $tempy. Moved $y units\n");
		sprintf("%.3f", ($tempz = $z1 - $z) ); #print ("$xz to $tempz. Moved $z units\n");
		print OFile1 ("$vertex $tempx $tempy $tempz\n");
	}else{
		print OFile1 ($lines."\n");
	}
}
close (File1);
close (OFile1);
print ("$outF created successfully\n");
}
$totalfinishtime = time();
$totaltimeinterval = $totalfinishtime - $totalstarttime;
$sec = int($totaltimeinterval % 60);
$min = int(($totaltimeinterval % 3600) / 60);
$hours = int($totaltimeinterval / 3600);
print("The time to process $inputfile and create $outF. $hours:$min:$sec \n");






die();




while ($inputfile = $ARGV[0]){
shift (@ARGV);
open (File1, "$inputfile");
$total = 0;
foreach $line (<File1>){
	print ("1 ".$line."\n")
}
seek (File1, 0, 0);# to the beginning
seek (File1, 0, 2);# to the end
$total = $x_total = $y_total = $z_total = 0;
foreach $line (<File1>){
	print ("2 ".$line."\n")
}
}
die();





while ($inputfile = $ARGV[0]){
@outfile = split (/\./, $ARGV[0]);
shift (@ARGV);
print ("Opening $inputfile please wait...\n");
open (File1, "$inputfile");
chomp (@lines = <File1>);
print ("File has ".@lines." entries\n");
$il = int( (@lines / 32000) + 1 );#32000 is the maximum number of points that excel graphs can handle
print ("$il\n");
$outF = "$outfile[0]".".hxl";
open (OFile1, ">$outF");
$x = 0;
while ($x < @lines){
	if(!($x % $il)){print OFile1 ("$lines[$x]\n");}
	$x++;
}
print ("$outF created\n");
close(File1);
close(OFile1);
}
exit;


$z = 1242323.23412341234;
$precision = int((log (233) / log(10)) + 1); #converts to base 10 
$z = sprintf("%.".$precision."f",$z ); 
print ("$precision $z\n");

die();

while  ($angle < (2*$pi)){
	$angle += $pi/12;
	$x = cos($angle);
	$y = sin($angle);
	if ($x != 0) {$new_angle = atan ($y/$x);}
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
	$angle = sprintf("%.3f",$angle );
	$new_angle = sprintf("%.3f",$new_angle );
	$angle_rad = sprintf("%.3f",$angle_rad );
	print ("$angle ->\t $new_angle ->\t $angle_rad\n");
}

die();


$date = join(':', ((localtime(time))[5])+1900,((localtime(time))[4]+1), (localtime(time))[3,2,1,0]);
print("$date\n");
die();

$totalstarttime = time();
print ("$totalstarttime\n");
die();

$totalfinishtime = time();
$totaltimeinterval = $totalfinishtime - $totalstarttime;
$totaltimeinterval = 1223445;
$sec = int($totaltimeinterval % 60);
$min = int(($totaltimeinterval % 3600) / 60);
$hours = int($totaltimeinterval / 3600);
print("The time to process __ and create ___. $hours:$min:$sec \n");
die();

@sheet = (0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

$size_x = 13;
$size_y = 10;

$x = $y = 0;
while($y < $size_y){
	$x = 0;
	while ($x < $size_x){
		$index = ($y*$size_x) + $x;
		print("$sheet[$index] ");
		$x++;
	}
	print("\n");
	$y++;
}
print("\n\n\n\n\n");
$x = $y = 0;
while($y < $size_y){
	$x = 0;
	while ($x < $size_x){
		$index = ($y*$size_x) + $x;
		print("$index ");
		$x++;
	}
	print("\n");
	$y++;
}

$il = $index_x = $index_y = 0;
$temp1 = $sheet[0];

while($index_y < $size_y){
	$index_x = 0;
	while($index_x < $size_x){
		$first = 0;
		$index = $size_x*$index_y + $index_x;
		$temp2 = $sheet[$index];
		#first condition leading edge
		if ( ($first == 0) and ($temp1 == 0) and ($temp2 == 1)) {
			$edges[$i1] = $index;
			$first = 1;
			$i1++;#sets index for the trailling edge
			#print("Leading edge @ $index\n");
		}
		
		#second condition trailling edge
		if ( ($temp1 == 1) and ($temp2 == 0) ) {
			$edges[$i1] = $index;
			#print("Trailling edge @ $index\n");
		}
		$index_x++;
		$temp1 = $temp2;
	}
	$index_y++;
}
die();



@new_edges = sort {$a <=> $b} @new_edges;
@edges = (@edges,@new_edges);
my @new_edges = ();
die();

sub round {
    my($number) = shift;
    return int($number + .5 * ($number <=> 0));
}
$pi = 3.141592654;
$convert = 180/$pi;
$rad = 0;
($x1, $y1) = (0, 100);


print("($x1, $y1)\n");
while($rad < 2*$pi){
	$rad += $pi/72;
	$SI = sin($rad);
	$CS = cos($rad);
	$index = 0;
	($x2, $y2) = ( round($x1*$CS - $y1*$SI) , round($x1*$SI + $y1*$CS) );
	$angle = round($convert*$rad);
	print("($x2, $y2)\t$angle\n");
	
}
die();


$size = 3;
$x = $y = 0;

while($x < $size){
	$y = 0;
	while ($y < $size){
		$index = ($x*$size) + ($y % $size);
		$sheet[($x*$size) + $y] = 1;
		print("$x\t$y\nsheet[$index] = $sheet[$index]\n");
		$y++;
	}
	$x++;
}

$index = 0;
while($index < ($size**2)){
	if (!($index % $size)){print ("\n")};
	print("$sheet[$index] ");
	$index++;
} 

die("26\n");


open (OutFile1, ">hemisphere.obj");
#	print ("Outstream created succesfully\n");
#}else{
#	die("File stream error\n");
#)
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;

print OutFile1 ("#  Sun Jan 16 $hour:$min:$sec $year\n\n# Object name : Hemisphere\n# \ng\n");
$index = 0;
while ($index <= 2000){
	$index++;
	$x = rand(94);
	$y = rand(sqrt((94**2) - $x**2));
	$z = sqrt(94**2 - $x**2 - $y**2);
	print ("v $x $y $z\n");
	
	print OutFile1 ("v $x $y $z\n");
}
close(OutFile1);

