#!/usr/bin/env perl
#use warnings;
use Math::Trig;
$pi = 3.141592654;
$angle = -$pi/12;
$totalstarttime = time();
$date = join(':', ((localtime(time))[5])+1900,((localtime(time))[4]+1), (localtime(time))[3,2,1,0]);

open (Olog, ">>histlog.txt");
#open (debug, ">debug.txt");
$inputfile1 = shift (@ARGV);
open (File1, "$inputfile1");#prototype 
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
while ($inputfile2 = shift (@ARGV)){
$starttime = time();
@t = split (/\./, $inputfile2);
open (File2, "$inputfile2") or die("$inputfile2 could not be found!\n");#file being compared
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
	if ( abs(($indentifer - $curvature) / $indentifer ) < 0.01 ){#begin comparison
		$index1 = $index;
		$index2 = 0;
		$total = 0;
		$sum = 0;
		while ($index2 < @prototype){
			$sum += 1 - abs( ($test[($index1 % @test)] - $prototype[$index2]) / $prototype[$index2] );#allow for loop back
			$total++;
			$index1++;
			$index2++;
		}
		push (@match , sprintf("%.3f",($sum / $total)));
	}
}
@match = sort {$a <=> $b} @match;
while ($match[0] < 0){shift(@match);}#thorws out negative overall matches
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
$totalfinishtime = time();
$totaltimeinterval = $totalfinishtime - $totalstarttime;
$sec = int($totaltimeinterval % 60);
$min = int(($totaltimeinterval % 3600) / 60);
$hours = int($totaltimeinterval / 3600);
print ("All files processed in $hours:$min:$sec\n\nThe final results are:\n");
print Olog ("All files processed in $hours:$min:$sec\n\nThe final results are:\n");
foreach $line (@results){
	($i1, $i2, $b, $w) = split(/ /, $line);
	print ("$i1 to $i2 best: $b\tworst: $w\n");
	print Olog ("$i1 to $i2 best: $b\tworst: $w\n");
}
#close (debug);
close (Olog);
close (File1);
print ("\a");
exit;