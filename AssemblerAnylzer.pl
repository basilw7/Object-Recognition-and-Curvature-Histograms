#!/usr/bin/perl -w

no warnings;
$sparc=0;
while(<>){
#       $cmd = "";
#       $label = "";
        chomp;
        ($label,$cmd)=split(/\t/);
        next if ($cmd eq "" || $cmd =~ /^\./);
        next if ($label eq ".section");
        if ($cmd =~ /^!#/){
                $sparc=1;
                next;
                }
        ($cmd,$args)=split(/ /, $cmd);
        $total++;
        if ($cmd =~ /^j/ || $cmd =~ /^b/ || $cmd eq "call" || $cmd eq "ret" || $cmd eq "opcode" || $cmd eq "be" || $cmd eq "cmp" || $cmd eq "jmp"){
                $branches++;
                next;
                }
        if ($cmd eq "ld" || $cmd eq "st" || $cmd eq "ldub" || $cmd eq "ldsb" || $cmd eq "lduh" || $cmd eq "ldsh" || $cmd eq "mov" || $cmd eq "movl" || $cmd eq "pushl" || $cmd eq "popl"){
                $memory++;
                next;
                }
        if ($cmd eq "stb" || $cmd eq "sth" || $cmd eq "ldd" || $cmd eq "std"){
                $memory++;
                next;
                }
        $other++;
        print "$_\n";
        }
$pbr=int (($branches*100)/$total);
$poth=int (($other*100)/$total);
$pmem=int (($memory*100)/$total);
$tot=int ($pbr + $poth + $pmem);
print "$branches	$pbr%	branch intructions\n";
print "$memory	$pmem%	memory intructions\n";
print "$other   	$poth%	other intructions\n";
print "$total	$tot%	total intructions\n";
print "Type=$sparc\n\n";



