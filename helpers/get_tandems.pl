# file: get_tandems.pl
#
# purpose: Create a table of tandem arrays
# 
# input: 18_syn_pan_aug_extra.table.tsv from Pandagma
#
# output columns (space-deliminated):
#   tandem_id gene models
#
# history:
#  01/07/24  eksc created

use strict;
use Cwd;
use Data::Dumper;

my $usage = <<EOS

    usage: 
      perl get_tandems.pl [prefix] [pandagma-table-file]
      
    example:
      perl get_tandems.pl 'tandem.v2.' [path]18_syn_pan_aug_extra.table.tsv
    
EOS
;

  
  my ($prefix, $infile) = @ARGV;
  if (!$infile) {
    die $usage;
  }

  my %heads;
  my $count = 0;
  open IN, "<$infile" or die "\nUnable to open $infile: $!\n\n";
  while (<IN>) {
    chomp;chomp;
    my @fields = split /\t/;
    if (/^#/ && !%heads) {
      s/^#//;
      my $head_count = 0;
      foreach my $f (@fields) {
        $heads{$head_count} = $f;
        $head_count++;
      }
    }
    else {
      # Get tandem array in each column, if any
      for (my $i=1; $i<scalar(@fields); $i++) {
        next if ($fields[$i] =~ /NONE/);
        if ($fields[$i] =~ /,/) {
          # tandem array exists
          my $name = sprintf("$prefix%05d", $count);
          my $array = $fields[$i];
          $array =~ s/,/ /g;
          print "$name $array\n";
          $count++;
        }
      }
    }
  }#each line
  close IN;
    