#!/usr/bin/perl -w

$sparc=0;
while(<>){
	chomp;
      ($label,$cmd,$arg)=split(/\t/);
	next if ($cmd eq "" || $cmd =~ /^\./);
#	next if ($label eq ".section");
	print "$_\n";
}