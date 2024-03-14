# file: fix_prefixes.pl
#
# purpose: Remove annotation prefixes that were added to enable Pandagma to interpret
#          gene model names. Change file prefixes to match MaizeGDB analysis version.
#
#          Assumes the added gene model prefix looks like: /\w\w\d{5}\w\w\..*/
#
# history:
#  03/13/24  eksc  created

use strict;
use Getopt::Std;
use Data::Dumper;

my $usage = <<EOS

    usage: 
      perl fix_prefixes.pl [opts] in-dir out-dir old-prefix new-file-prefix external-annotations
      
    options:
      -t   if set, input is a Newick-like file containing phylogenetic trees
      
    example:
      perl fix_prefixes.pl 20_align 20_align_mod "grass.fam" "grass.fam.v1" data/external_annotations.txt
      perl fix_prefixes.pl -t 20_trees 20_trees_mod "grass.fam" "grass.fam.v1" data/external_annotations.txt
    
EOS
;

my $newick = 0;
my %cmd_opts;
getopts("t", \%cmd_opts);
if (defined($cmd_opts{'t'})) { $newick = 1; } 

my ($indir, $outdir, $oldprefix, $newprefix, $external_annots) = @ARGV;
if (!$external_annots) {
  die $usage;
}
print "Read file names from $indir, then copy with new gene model names to $outdir ";
print "$oldprefix -> $newprefix.\n\n";

my %annot_prefixes;
open IN, "<$external_annots" or die "\nUnable to open $external_annots for reading: $!\n\n";
while (<IN>) {
  chomp;
  next if (/^#/ || /^\s*$/);
  $annot_prefixes{$_} = 1;
}
close IN;
#print Dumper(%annot_prefixes);

my $count = 0;
while (my $file = <"$indir/*">) {
  print "\n";
  $file =~ /$oldprefix\.(\d+)/;
  my $newfile = "$outdir/grass.fam.v1.$1";
  print "$count: $file --> $newfile\n";
  open IN, "<$file";
  open OUT, ">$newfile" or die "\nUnable to open $newfile for writing: $!\n\n";
  while (<IN>) {
    my $line = $_;
    if (!$newick) {
      $line =~ /(\w\w\d{5}\w\w)\..*/;
      if ($annot_prefixes{$1}) {
        $line =~s/\w\w\d{5}\w\w\.(.*)/$1/;
      }
      else {
        $line =~s/(\w\w\d{5}\w\w)\.(.*)/$1$2/;
      }
    }
    else {
      # Remove all made-up outside annotation prefixes
      foreach my $annot (keys %annot_prefixes) {
        $line =~ s/$annot\.//g;
      }
      # Remove all dots from internal gene model names
      $line =~ s/(\w\w\d{5}\w\w)\.(\d{6}_T\d{3}[^\d])/$1$2/g;
    }
    print OUT $line;
#    print $line;
  }#each row
  close IN;
  close OUT;
  
  $count++;
#last if ($count > 0);
}

print "\nDONE\n\n";
