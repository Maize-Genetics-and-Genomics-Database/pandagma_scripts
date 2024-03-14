# file: format_loading_table.pl
#
# purpose: Create a table for loading into chado
# 
# input:
#
# output columns:
#   panID	trans	transChr	transStart	transEnd	transStrand	panChr panStart	panEnd	panStrand	exemplar
#
# history:
#  10/25/23  eksc created

use strict;
use Cwd;
use Getopt::Std;

use Data::Dumper;

my $usage = <<EOS

    usage: 
      perl format_pandagma_table.pl [options] [prefix] [working-directory]
    options:
      -t pan-gene [default]/gene-fam
      
    example:
      perl format_pandagma_table.pl -t gene-fam 'grass-fam.v1' grass-fam
    
EOS
;

  my $data_type = 'pan-gene';
  my %cmd_opts;
  getopts("t:", \%cmd_opts);
  if (defined($cmd_opts{'t'})) { $data_type = $cmd_opts{'t'}; } 
  
  my ($prefix, $workdir) = @ARGV;
  if (!$workdir || ($data_type ne 'pan-gene' && $data_type ne 'gene-fam')) {
    die $usage;
  }

  # Used all over
  my ($filename, @fields, $count);

  # Get position for each gene model
  print "\nGET POSITIONS\n";
  my @bedfiles = glob("$workdir/bed/*.bed");
  my %positions;
  for $filename (@bedfiles) {
    print "$filename\n";
    open IN, "<$filename" or die "\nUnable to open $filename: $!\n\n";
    $count = 1;
    while (<IN>) {
      chomp;chomp;
      @fields = split /\t/;
#print $fields[3] . "\n";
      $positions{$fields[3]} = {
        'chromosome' => $fields[0],
        'start' => $fields[1],
        'end' => $fields[2],
        'strand' => $fields[5],
      };
      $count++;
#last if ($count > 10);
    }
    close IN;
#last;
  }
  print "Loaded " . scalar (keys %positions) . " positions\n";
#print Dumper(%positions);
#print "\n\npositions for Zd00001aa038416_T001:\n" . Dumper($positions{'Zd00001aa038416_T001'});
#print "\n\npositions for Zd00001aa032704_T001:\n" . Dumper($positions{'Zd00001aa032704_T001'});

  # Get exemplar for each pan-gene (no exemplars for gene families)
  if ($data_type eq 'pan-gene') {
    print "\nGET EXEMPLARS\n";
    my %pan_gene_exemplars;
    $filename = "$workdir/21_pan_fasta_clust_rep_cds.fna";
    open IN, "<$filename" or die "\nUnable to open $filename: $!\n\n";
    while (<IN>) {
      chomp;chomp;
      next if (!/>/);
      />(\w+)\s(.*)/;
      my $pan_gene = $prefix . $1;
      $pan_gene_exemplars{$pan_gene} = $2;
    }
    close IN;
  }
#print Dumper(%pan_gene_exemplars);

  # Build loading table from 18_syn_pan_aug_extra.hsh.tsv (panID, trans)
  # panID	trans	transChr transStart	transEnd transStrand panChr panStart panEnd	panStrand	exemplar
  print "\nWRITE TABLE $workdir/pandagma_load.txt\n";
  $filename = "$workdir/18_syn_pan_aug_extra.hsh.tsv\n";
  open IN, "<$filename" or die "\nUnable to open $filename: $!\n\n";
  open OUT, ">$workdir/pandagma_load.txt";
  
  if ($data_type eq 'pan-gene') {
    print OUT "panID\ttrans\ttransChr\ttransStart\ttransEnd\ttransStrand\tpanChr\tpanStart\tpanEnd\tpanStrand\texemplar\n";
  }
  else {
    print OUT "famID\ttrans\n";
  }
  
  $count = 0;
  while (<IN>) {
    chomp;chomp;
    @fields = split /\t/;
    my $pan_gene = $prefix . $fields[0];
    $pan_gene =~ s/\s//g;
    my $trans = $fields[1];
    $trans =~ s/\s//g;
    if ($data_type eq 'pan-gene') {
      my $pan_chr = $positions{$exemplar}{'chromosome'};
      $pan_chr =~ s/.*(chr\d+)/$1/;
      my $exemplar = $pan_gene_exemplars{$pan_gene};
      $exemplar =~ s/\s//g;
      my @rec = (
        $pan_gene, 
        $fields[1], 
        $positions{$trans}{'chromosome'}, 
        $positions{$trans}{'start'},
        $positions{$trans}{'end'},
        $positions{$trans}{'strand'},
        $pan_chr,
        $positions{$exemplar}{'start'},
        $positions{$exemplar}{'end'},
        $positions{$exemplar}{'strand'},
        $exemplar,
      );
    }
    else {
      my @rec = (
        $pan_gene, 
        $fields[1], 
      );
    }
    print OUT join("\t", @rec) . "\n";
    $count++;
#last if ($count > 10);
  }
  close IN;
  close OUT;

  print "\n\nDone\n\n";
