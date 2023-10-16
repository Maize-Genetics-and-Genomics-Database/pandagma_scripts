# file: restore_v3_ids.pl
#
# purpose: one-off script to restore temporary v3 ids back to the original ids
#
# Input file format: 
#   panID trans transChr transStart transEnd transStrand longPanID panChr panStart panEnd panStrand exemplar
#
# history:
#  10/12/23  eksc  created

use strict;
use Data::Dumper;

my $usage = <<EOS
    usage: 
      perl  restore_v3_ids <xref-file> <gff-file>
      
    example:
      perl restore_v3_ids.pl data/v3_sref.txt 22_syn_pan_aug_extra_pctl25_posn.hsh.extended.header.tsv
    
EOS
;

  my ($xreffile, $infile) = @ARGV;
  if (!$infile) {
    die $usage;
  }

  my %xref;
  open XREF, "<$xreffile" or die "\nUnable to open $xreffile: $1\n\n";
  while (<XREF>) {
    chomp;chomp;
    my @fields = split /\t/;
    $xref{$fields[1]} = $fields[0];
  }
  close XREF;
#print Dumper(%xref);

  open IN, "<$infile" or die "\nUnable to open $infile: $1\n\n";
  while (<IN>) {
    if (/panID/) {  # header row
      print;
      next;
    }
    my @fields = split /\t/;
    $fields[1] =~ s/_T\d+//;
    $fields[11] =~ s/_T\d+//;
    if ($xref{$fields[1]} =~ /GRMZM/) {
      if ($xref{$fields[1]}) {
        s/$fields[1]/$xref{$fields[1]}/g;
      }
      if ($xref{$fields[11]}) {
        s/$fields[11]/$xref{$fields[11]}/g;
      }
    }
    else {
      if ($xref{$fields[1]}) {
        s/$fields[1]_T\d+/$xref{$fields[1]}/g;
      }
      if ($xref{$fields[11]}) {
        s/$fields[11]_T\d+/$xref{$fields[11]}/g;
      }
      s/_FG/_FGT/;
    }
    print;
  }
  close IN;