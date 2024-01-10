#!/usr/bin/env perl

# file: make_gfa.pl
#
# purpose: Make "GFA" files for the Genome Context Viewer from Pandagma output.
#          "GFA" spec: https://github.com/legumeinfo/datastore-specifications/blob/main/Genus/species/annotations/gfa.md
#
# input: 22_syn_pan_aug_extra_pctl25_posn.hsh.tsv
#
# output: "GFA" for each annotation
#
# history:
#  01/10/24 eksc updated

use strict;
use English;
use Getopt::Std;

my $usage = <<EOS
    usage: 
      perl [options] make_gfa.pl
      
    options:
      -d: [REQUIRED] output directory
      -f: [REQUIRED] file containing names of all annotations
      -p: [OPTIONAL] pan gene identifier prefix; if set, prefix in input file is replace with this.
      
    example:
      perl make_gfa.pl -d gfa -f annotations.txt -p 'pan-zea.v2.'
      
EOS
;

  my (%cmd_opts, $dir, $annotfile, $prefix);
  getopts("d:f:p:", \%cmd_opts);
  if (defined($cmd_opts{'d'})) { $dir       = $cmd_opts{'d'}; } 
  if (defined($cmd_opts{'f'})) { $annotfile = $cmd_opts{'f'}; } 
  if (defined($cmd_opts{'p'})) { $prefix    = $cmd_opts{'p'}; } 

  if (!$dir || !$annotfile) {
    die $usage;
  }
  
  open ANNOT, "<$annotfile" or die "\nUnable to open $annotfile\n\n";
  my $count = 0;
  while (<ANNOT>) {
    chomp;
    #Zd-Gigi-REFERENCE-PanAnd-1.0_Zd00001aa.1
    /(.*)_(\w\w\d+.*)\./;
    my $assembly   = $1;
    my $annotation = $2;
#print "Assembly: $assembly, Annotation: $annotation\n";
    my $outfile = "$dir/$assembly" . '_pandagma.gfa';
    my $cmd = "cat 22_syn_pan_aug_extra_pctl25_posn.hsh.tsv ";
    $cmd .= "| grep \"$annotation\" ";
    $cmd .= '| awk -v OFS="\t" \'BEGIN {print "#gene","family","protein","e-value","score"}';
    $cmd .= " {print \$2,\"$prefix\"\$1,\$2,\"0.0\",\"1000\"}' ";
    $cmd .= '| awk -v OFS="\t" \'{gsub(/_T[0-9]*/,"", $1);print}\' ';
    $cmd .= "> $outfile";
#print "$cmd\n";
    `$cmd`;
    
    $count++;
#last if ($count > 0);
  }#each annotation
  close ANNOT;

# For each annot:
#cat Ethy_Oct-2-23_22_syn_pan_aug_extra_pctl25_posn.hsh.tsv | 
#grep "Zd00001aa" | 
#awk -v OFS="\t" 'BEGIN {print "#gene","family","protein","e-value","score"} {print $2,$1,$2,"0.0","1000"}' | 
#awk -v OFS="\t" '{gsub(/_T[0-9]*/,"", $1);print}' > Zd-Gigi-REFERENCE-PanAnd-1.0_pandagma.gfa


