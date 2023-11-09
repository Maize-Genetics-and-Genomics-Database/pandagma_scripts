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
use Getopt::Std;
use Data::Dumper;

my $usage = <<EOS
    usage: 
      perl [options] restore_v3_ids <xref-file> <file>
      
    options:
      -d: [OPTIONAL] directory, in which case <file> is the file name pattern
      -g: [OPTIONAL] glob pattern for files, sans directory
      -o: [OPTIONAL] directory for output files
      -p: [OPTIONAL] prefix to add to file names
      -t: table/FASTA/tree [DEFAULT=table]
      
    examples:
      perl restore_v3_ids.pl -t table data/v3_sref.txt 22_syn_pan_aug_extra_pctl25_posn.hsh.extended.header.tsv
      restore_v3_ids.pl -d . -g pan.* -o mod -p pan-zea.v1. -t FASTA data/v3_xref.txt
    
EOS
;

  my $file_type = 'table';
  my $dir = '';
  my $outdir = '';
  my $prefix = '';
  my $glob = '';
  my %cmd_opts;
  getopts("d:g:o:p:t:", \%cmd_opts);
  if (defined($cmd_opts{'d'})) { $dir = $cmd_opts{'d'}; } 
  if (defined($cmd_opts{'g'})) { $glob = $cmd_opts{'g'}; } 
  if (defined($cmd_opts{'o'})) { $outdir = $cmd_opts{'o'}; } 
  if (defined($cmd_opts{'p'})) { $prefix = $cmd_opts{'p'}; } 
  if (defined($cmd_opts{'t'})) { $file_type = $cmd_opts{'t'}; } 
  
  my ($xreffile, $infile) = @ARGV;
  if (!$xreffile || (!$dir && !$infile)) {
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
print "File type: $file_type, directory: $dir, output directory: $outdir, prefix: $prefix\n";

  if ($file_type eq 'table') {
print "processTable()\n";
exit;
    processTable($infile, %xref);
  }
  elsif ($file_type eq 'FASTA') {
print "processFASTA()\n";
    if ($infile && $dir eq '') {
      processOneFASTA($infile, '', %xref);
    }
    else {
      processFASTA($dir, $outdir, $prefix, $glob, %xref);
    }
  }
  elsif ($file_type eq 'tree') {
print "processTree()\n";
    if ($infile && $dir eq '') {
      processOneTree($infile, '', %xref);
    }
    else {
      processTrees($dir, $outdir, $prefix, $glob, %xref);
    }
  }
  else {
    print "\nERROR: unknown file type: $file_type\n\n";
    exit;
  }
  

##########################################################################################
##########################################################################################
##########################################################################################


sub processFASTA {
  my ($dir, $outdir, $prefix, $glob, %xref) = @_;

  opendir(my $dh, $dir) || die "Can't open directory $dir: $!";
  my @files = sort(grep { /$glob/ && -f "$dir/$_" } readdir($dh));
  closedir $dh;
  
#print "All files:\n" . Dumper(@files);
  my $count = 0;
  for my $file (@files) {
    print "\n>>>> $count process file $dir/$file.\n";
    my $outfile = "$outdir/$prefix$file";
    processOneFASTA($file, $outfile, %xref);
    $count++;
#last if ($count > 0);
  }
}#processFASTA


sub processOneFASTA {
  my ($infile, $outfile, %xref) = @_;
  
  if ($outfile) {
    print "Write to $outfile\n";
    open OUT, ">$outfile";
  }
  my ($old_id, $old_gm);
  open IN, "<$infile" or die "\nUnable to open $infile: $1\n\n";
  while (<IN>) {
#    if (/>\w+\s+(\w+)/) {
    if (/>(\w+)/) {
      $old_id = $1;
      $old_gm = $1;
      $old_gm=~ s/(_T.*)//;
#print "gm name: $old_gm\n";
      if ($xref{$old_gm}) {
        if ($xref{$old_gm} =~ /GRMZM/) {
#print "Translate $old_gm to $xref{$old_gm}$1\n";
          s/$old_gm/$xref{$old_gm}/;
        }
        else {
#print "Translate $old_gm to FGenesH name $xref{$old_gm}\n";
          s/$old_id/$xref{$old_gm}/;
          s/FG/FTG/;
        }
      }
    }
    if ($outfile eq '') {
      # Write to standard out
      print;
    }
    else {
      print OUT;
    }
  }
  close IN;

  if ($outfile) {
    close OUT;
  }
}#processOneFASTA


sub processOneTree {
  my ($infile, $outfile, %xref) = @_;

  if ($outfile) {
    print "Write to $outfile\n";
    open OUT, ">$outfile";
  }
  
  my ($old_id, $old_gm, $new_id, $tr);
  open IN, "<$infile" or die "\nUnable to open $infile: $1\n\n";
  while (<IN>) {
    while (/(Zm00001ca\d+)_T(\d+)/g) {
      $old_gm = $1;
      $tr = $2;
      $old_id = $old_gm . "_T$2";
#print "Found v3 gm $old_id";
      if ($xref{$old_gm}) {
        if ($xref{$old_gm} =~ /GRMZM/) {
          $new_id = $xref{$old_gm} . "_T$tr";
#print "  translate to $new_id\n";
          s/$old_id/$new_id/;
        }
        else {
          $new_id = $xref{$old_gm};
          $new_id =~ s/FG/FTG/;
#print "  translate to FGenesH $new_id\n";
          s/$old_id/$new_id/;
        }
      }
    }#each match
    if (!$outfile) {
      print;
    }
    else {
      print OUT;
    }
  }
  close IN;

  if ($outfile) {
    close OUT;
  }
}#processTree


sub processTable {
  my ($infile, $outdir, $prefix, %xref) = @_;
  
  my $f1 = 1;
  my $f2 = 10;
  open IN, "<$infile" or die "\nUnable to open $infile: $1\n\n";
  while (<IN>) {
    chomp;chomp;
    if (/panID/) {  # header row
      print;
      next;
    }
    my @fields = split /\t/;
    my $gm1 = $fields[$f1];
    $gm1 =~ s/_T\d+//;
    my $gm2 = $fields[$f2];
    $gm2 =~ s/_T\d+//;
    if ($xref{$gm1} =~ /GRMZM/) {
      if ($xref{$gm1}) {
        s/$gm1/$xref{$gm1}/g;
      }
      if ($xref{$gm2}) {
        s/$gm2/$xref{$gm2}/g;
      }
    }
    else {
      # This is an FgenesH identifier
      if ($xref{$gm1}) {
        s/$gm1/$xref{$gm1}/g;
      }
      if ($xref{$gm2}) {
        s/$gm2/$xref{$gm2}/g;
      }
      s/_FG/_FGT/;
    }
    print "$_\n";
  }
  close IN;
}#processTable


sub processTrees {
  my ($dir, $outdir, $prefix, $glob, %xref) = @_;
print "glob: $glob\n";

  opendir(my $dh, $dir) || die "Can't open directory $dir: $!";
  my @files = sort(grep { /pan/ && -f "$dir/$_" } readdir($dh));
  closedir $dh;
  
#print "All files:\n" . Dumper(@files);
  my $count = 1;
  for my $file (@files) {
    print "\n>>>> $count process file $dir/$file.\n";
    my $outfile = "$outdir/$prefix$file";
    processOneTree($file, $outfile, %xref);
    $count++;
#last if ($count > 0);
  }
}#processTree


