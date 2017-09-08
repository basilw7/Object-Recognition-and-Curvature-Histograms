#http://www.softlookup.com/tutorial/Perl/ch6.asp

#!/usr/local/bin/perl

$inputfile = $ARGV[0];
$outputfile = $ARGV[1];

unless (open(INFILE, "$inputfile")) {
	die ("cannot open input file file1\n");
}
unless (open(OUTFILE, ">$outputfile")) {
	die ("cannot open output file outfile\n");
}
$line = <INFILE>;
$index = 0;
while (($line ne "") && ($index < 1e4)) {
	print OUTFILE ($line);
	$line = <INFILE>;
	$index++;
}