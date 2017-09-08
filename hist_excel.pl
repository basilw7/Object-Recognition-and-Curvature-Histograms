while ($inputfile = $ARGV[0]){
@outfile = split (/\./, $ARGV[0]);
shift (@ARGV);
print ("Opening $inputfile please wait...\n");
open (File1, "$inputfile");
chomp (@lines = <File1>);
print ("File has ".@lines." entries\n");
$il = int( (@lines / 32000) + 1 );#32000 is the maximum number of points that excel graphs can handle

$outF = "$outfile[0]".".hxl";
open (OFile1, ">$outF");
$x = 0;
foreach $entry (@lines){
	if ($entry =~ /R/){next;}
	if(!($x % $il)){print OFile1 ("$entry\n");}
	$x++;
}
print ("$outF created\n");
print ("$il:1\n");
close(File1);
close(OFile1);
}
exit;