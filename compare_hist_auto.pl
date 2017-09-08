#!/usr/bin/env perl
#use warnings;
$totalstarttime = time();
$date = join(':', ((localtime(time))[5])+1900,((localtime(time))[4]+1), (localtime(time))[3,2,1,0]);

open (Olog, ">>histlog.txt");
print ("compare_hist_auto.pl start time:\n $date\n");
print Olog ("compare_hist_auto.pl start time:\n $date\n");
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
			$sum += 1 - abs( ($test[($index1 % @test)] - $prototype[$index2]) / $prototype[$index2] );#allow for loop back
			$total++;
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
	if ($i1 !~ /$i1_2/){
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
#foreach $line (@finalresults){
	#($c, $i1, $i2) = split(/ /, $line);
	#print ("$i1 belongs to $i2 confidence: $c\n");
	#print ("$i1 belongs to $i2 confidence: $c\n");
#}	
close (debug);
close (Olog);
print ("\a");
exit;