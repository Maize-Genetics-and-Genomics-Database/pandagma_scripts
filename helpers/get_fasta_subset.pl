#!/usr/bin/perl

# PROGRAM: get_fasta_subset.pl
# VERSION: 0.02;  see version notes at bottom of file.
# S. Cannon 2005
# see description under Usage

use strict;
use warnings;
use Bio::SeqIO;
use Getopt::Long;

####### File IO ########

my ($input_fas, $list_IDs, $help, $verbose, $output_fas);
my $xclude = 0;

GetOptions (
  "input_fas=s" =>  \$input_fas,   # required
  "output_fas=s" => \$output_fas,   # required
  "list_IDs=s" =>   \$list_IDs,   # required
  "xclude" =>       \$xclude, 
  "verbose+" =>     \$verbose,
  "help:s" =>       \$help
);

my $usage = <<EOS;
  Usage: perl $0 [-options]
  
  Read a list of fasta IDs and a fasta file and either exclude or include those
  sequences into a new fasta file.
   
   -input_fas: input fasta file **
   -output_fas: output fasta file **
   -list_IDs: list of IDs to include or exclude **
   -xclude: boolean 
      -x (True) means exclude seqs in list 
         (False; default) means include sequences in the list 
   -verbose    (boolean) for more stuff to terminal; may call multiple times
   -help       for more info
   
   ** = required
EOS

die "\n$usage\n" 
  if ($help or !defined($input_fas) or !defined($output_fas) or !defined($list_IDs) );

####### The program ########
# read hash in
open( my $LIST_FH, '<', $list_IDs ) or die "can't open list_IDs $list_IDs: $!";
open( my $OUT_FH, '>', $output_fas ) or die "can't open output_fas $output_fas: $!";

# put elements of LIST into hash
my %hash;
while (<$LIST_FH>) {
  chomp;
  $hash{$_} = $_; 
  if ($verbose){print "[", $_, "] "}
}
if ($verbose){print "\n"}

# Read in the sequence using the Bioperl SeqIO;
my $in  = Bio::SeqIO->new(-file => $input_fas , '-format' => 'Fasta');

# Load the sequence into a Bio::Seq object
while ( my $seq = $in->next_seq ) {

  # get parts of the fasta seq
  my $display_id = $seq->display_id();
  if ($verbose) { print "Test ID [$display_id]\n"; }
  my $desc = $seq->desc();
  my $sequence = $seq->seq();
  
  if ($xclude) {
    # print "{$display_id} ";
    unless (defined($hash{$display_id})) {
      print $OUT_FH ">$display_id $desc\n$sequence\n";
    }
  }
  else { # $xclude is false; therefore, include seqs in the list
    # print "{$display_id} ";
    if (defined($hash{$display_id})) {
      if (defined($desc)) {
        print $OUT_FH ">$display_id $desc\n$sequence\n";
      }
      else { print $OUT_FH ">$display_id\n$sequence\n" }
    }
  }
}



__END__
VERSIONS

v0.01 2005 S. Cannon. 
v0.02 May05'07 SC Add getopts; clean up a bit
