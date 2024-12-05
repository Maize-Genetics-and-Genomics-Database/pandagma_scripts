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
      perl restore_v3_ids [options] <xref-file> <file>
      
    options:
      -c: [OPTIONAL] column for gene model name in FASTA defline
      -d: [OPTIONAL] directory, in which case -g gives the file pattern
      -g: [OPTIONAL] glob pattern for files, sans directory
      -o: [OPTIONAL] directory for output files, if operating on a directory
      -p: [OPTIONAL] prefix to add to file names
      -t: table/FASTA/tree/generic [DEFAULT=table]
      
    <file> is required unless -d and -g
      
    examples:
      perl restore_v3_ids.pl -t table data/v3_sref.txt 22_syn_pan_aug_extra_pctl25_posn.hsh.extended.header.tsv
      perl restore_v3_ids.pl -d . -g pan.* -o mod -p pan-zea.v1. -t FASTA data/v3_xref.txt
    
EOS
;

  my $defline_col = 1;
  my $dir = '';
  my $glob = '';
  my $outdir = '';
  my $prefix = '';
  my $file_type = 'table';
  my %cmd_opts;
  getopts("c:d:g:o:p:t:", \%cmd_opts);
  if (defined($cmd_opts{'c'})) { $defline_col = $cmd_opts{'c'}; } 
  if (defined($cmd_opts{'d'})) { $dir = $cmd_opts{'d'}; } 
  if (defined($cmd_opts{'g'})) { $glob = $cmd_opts{'g'}; } 
  if (defined($cmd_opts{'o'})) { $outdir = $cmd_opts{'o'}; } 
  if (defined($cmd_opts{'p'})) { $prefix = $cmd_opts{'p'}; } 
  if (defined($cmd_opts{'t'})) { $file_type = $cmd_opts{'t'}; }
  
  my ($xreffile, $infile) = @ARGV;
  if (!$xreffile || (!$dir && !$infile)) {
    die $usage;
  }
print "file_type: [$file_type], dir: [$dir], glob: [$glob], outdir: [$outdir]\,\n";
print "prefix: [$prefix], file_type: [$file_type],\nxreffile: [$xreffile],\ninfile: [$infile]\n\n";

  my %xref;
  open XREF, "<$xreffile" or die "\nUnable to open $xreffile: $1\n\n";
  while (<XREF>) {
    chomp;chomp;
    my @fields = split /\t/;
    $xref{$fields[1]} = $fields[0];
  }
  close XREF;

  if ($file_type eq 'table') {
    processTable($infile, %xref);
  }
  elsif ($file_type eq 'FASTA') {
    if ($infile && $infile ne '' && $dir eq '') {
print "Process one file.\n";
      processOneFASTA($infile, '', %xref);
    }
    else {
print "Process all files in directory [$dir] that match [$glob].\n";
      processFASTA($dir, $outdir, $prefix, $glob, %xref);
    }
  }
  elsif ($file_type eq 'tree') {
    if ($infile && $dir eq '') {
      processOneTree($infile, '', %xref);
    }
    else {
      processTrees($dir, $outdir, $prefix, $glob, %xref);
    }
  }
  elsif ($file_type eq 'generic') {
    if ($dir ne '') {
      print "\n\nNOT IMPLEMENTED FOR DIRECTORIES\n\n";
      exit;
    }
    processGenericFile($infile, %xref);
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
print "Found " . (scalar @files) . " in $dir matching $glob.\n";
  
#print "All files:\n" . Dumper(@files);
  my $count = 1;
  for my $file (@files) {
    print "\n>>>> $count process file $dir/$file.\n";
    my $outfile = "$outdir/$prefix$file";
    processOneFASTA("$dir/$file", $outfile, %xref);
    $count++;
last if ($count > 0);
  }
}#processFASTA


sub processGenericFile {
  my ($infile, %xref) = @_;

  my ($old_id, $old_gm, $new_id, $new_gm, $tr);
  
  open IN, "<$infile" or die "\nUnable to open $infile: $1\n\n";
  while (<IN>) {
    my $line = $_;
    
    # Handle transcripts
    while ($line =~ /(Zm00001ca\d+)_T(\d+)/g) {
      $old_gm = $1;
      $tr = $2;
      $old_id = $old_gm . "_T$2";
#print "Found v3 gm $old_id";
      if ($xref{$old_gm}) {
        if ($xref{$old_gm} =~ /GRMZM/) {
          $new_id = $xref{$old_gm} . "_T$tr";
#print "  translate to $new_id\n";
          $line =~ s/$old_id/$new_id/g;
        }
        else {
          $new_id = $xref{$old_gm};
          $new_id =~ s/FG/FTG/;
#print "  translate to FGenesH $new_id\n";
          $line =~ s/$old_id/$new_id/g;
#print "translated line: $line";
        }
      }
    }#each transcript match
    
    # Handle gene models
    while ($line =~ /(Zm00001ca\d+)/g) {
      $old_gm = $1;
#print "Found v3 gm $old_gm";
      if ($xref{$old_gm}) {
        $new_gm= $xref{$old_gm};
#print "  translate to $new_gm\n";
        $line =~ s/$old_gm/$new_gm/g;
      }
    }#each gene model match

    print $line;
  }
  close IN;
}#processGenericFile


sub processOneFASTA {
  my ($infile, $outfile, %xref) = @_;
print "Process file $infile.\n";
  
  my $re = ($defline_col == 1) ? qr/>(\w+)/ : qr/>.*?\s+(.*)/;
  
  if ($outfile) {
    print "Write to $outfile\n";
    open OUT, ">$outfile";
  }
  my ($old_id, $old_gm);
  open IN, "<$infile" or die "\nUnable to open $infile: $1\n\n";
  while (<IN>) {
#print $_;
    if (m/$re/) {
      $old_id = $1;
      $old_gm = $1;
      $old_gm =~ s/(_T.*)//;
#print "transcript: $old_id, gm name: $old_gm\n";
      if ($xref{$old_gm}) {
#print "Translate $old_gm to $xref{$old_gm}$1\n";
        s/$old_gm/$xref{$old_gm}/;
        if (!($xref{$old_gm} =~ /GRMZM/)) {
          s/FG/FTG/;
        }
      }
      
      if ($defline_col == 2 && $prefix ne '') {
        # Add prefix to pan-gene id in first column
        s/>(.*?)(\s+.*)/>$prefix$1$2/;
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
  open IN, "<$dir/$infile" or die "\nUnable to open $infile: $1\n\n";
  while (<IN>) {
    while (/(Zm00001ca\d+)_T(\d+)/g) {
      $old_gm = $1;
      $tr = $2;
      $old_id = $old_gm . "_T$2";
#print "Found v3 gm $old_id\n";
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
    if ($gm1 =~ /Zm00001c/ && $xref{$gm1}) {
      s/$gm1/$xref{$gm1}/g;
      s/_FG/_FGT/;  # in case an FgenesH identifier
    }
    if ($gm2 =~ /Zm00001c/ && $xref{$gm2}) {
      s/$gm2/$xref{$gm2}/g;
      s/_FG/_FGT/;  # in case an FgenesH identifier
    }
    print "$_\n";
  }
  close IN;
}#processTable


sub processTrees {
  my ($dir, $outdir, $prefix, $glob, %xref) = @_;
#print "glob: $glob\n";

  opendir(my $dh, $dir) || die "Can't open directory $dir: $!";
  my @files = sort(grep { /pan/ && -f "$dir/$_" } readdir($dh));
  closedir $dh;
  
#print "All files:\n" . Dumper(@files);
  my $count = 1;
  for my $file (@files) {
    print "\n>>>> $count process file $dir/$file\n";
    my $outfile = "$outdir/$prefix$file";
    processOneTree($file, $outfile, %xref);
    $count++;
#last if ($count > 0);
  }
}#processTree


