# file:
# 
# purpose: one-off script to extract high-quality gene models from the oat 1.1 annotation.
#
# history:
#   02/28/24  eksc  created

use strict;
use Data::Dumper;

my ($inGFF) = @ARGV;

my %hc_genes;
my %hc_transcripts;

# Get identifiers for the high-quality genes and transcripts
open IN, "<$inGFF";
my $count = 0;
while (<IN>) {
  next if (/^#/);
  my @fields = split("\t");
  if ($fields[8] =~ /primconf=HC/) {
    $fields[8] =~ /ID=(.*?);/;
    my $id = $1;
    if ($fields[2] =~/gene/) {
      $hc_genes{$id} = 1;
    }
    elsif ($fields[2] =~ /mRNA/) {
      $hc_transcripts{$id} = 1;
    }
  }
  $count++;
  #last if ($count >10);
}#each line
#print "HC genes:\n" . Dumper(@hc_genes);
#print "HC transcripts:\n" . Dumper(@hc_transcripts);
close IN;

# Print gene, mRNA, and CDS records for the high-quality gene models
open IN, "<$inGFF";
$count = 0;
while (<IN>) {
  next if (/^#/);
  my @fields = split("\t");
  $fields[8] =~ /ID=(.*?);/;
  my $id = $1;
  if ($fields[2] eq 'gene' && $hc_genes{$id}) {
    print;
  }
  elsif ($fields[2] eq 'mRNA' && $hc_transcripts{$id}) {
    print;
  }
  elsif ($fields[2] eq 'CDS') {
    /Parent=(.*?);/;
    if ($hc_transcripts{$1}) {
      print;
    }
  }
  $count++;
#last if ($count > 10);
}#each line
close IN;
