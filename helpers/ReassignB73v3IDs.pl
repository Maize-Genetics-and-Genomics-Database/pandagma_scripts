# file: ReassignB73v3IDs.pl
#
# purpose: reassign ids in a GFF file. Keep original id
#
# History:
#  08/02/23  eksc  created

  use strict;
  use DBI;
  use Data::Dumper;


my $usage = <<EOS
    usage: 
      perl  ReassignB73v3IDs <xref-file> <gff-file>
      
    example:
      perl ReassignB73v3IDs.pl v3_sref.txt Zea_mays.AGPv3.22.no_repeats.mod.gff3
    
EOS
;

my ($xreffile, $gfffile) = @ARGV;

if (!$gfffile) {
  die $usage;
}

my %xref;
open XREF, "<$xreffile" or die "\nUnable to open $xreffile: $!\n\n";
while (<XREF>) {
  chomp;
  my @fields = split /\t/;
#print Dumper(@fields);
  $xref{$fields[0]} = $fields[1];
}
close XREF;
#print 'Translate GRMZM2G040843 to ' . $xref{'GRMZM2G040843'} . "\n";

open GFF, "<$gfffile" or die "\nUnable to open $gfffile: $!\n\n";
while (<GFF>) {
  chomp;
  next if (m/##/);
  next if (m/\tchromosome\t/);
  my $line = $_;
  
  my $orig_id;
  if ($line =~ /ID=(.*?);/) {
    $orig_id = $1;
  }
  elsif ($line =~ /Name=(.*?);/) {
    $orig_id = $1;
  }
  elsif ($line =~ /Parent=(.*)/) {
    $orig_id = $1;
  }
  else {
    print "Can't find id for\n$line\n\n";
    exit;
  }
#print "\nID=$orig_id\n$line\n";

#Name=AC195240.4_FG002.exon1;Parent=AC195240.4_FGT002
#Name=Zm00001ca000176.exon1;Parent=AC195240.4_FGT002
  if (my @ret=translate_id($orig_id)) {
#print "Identifier $orig_id translated:\n" . Dumper(@ret);
    # messy, messy FGensH identifers!
    if ($orig_id =~ m/(.+?_FG)T(\d+)/) {
      $line =~ s/\Q$orig_id/\Q$ret[1]/g;
      $line =~ /Parent=(.*);/;
      my $parent_id = $1;
      my @par_ret = translate_id($parent_id);
#print "Parent $parent_id translated:\n" . Dumper(@par_ret);
      $line =~ s/\Q$parent_id/\Q$par_ret[1]/g;
    }
    elsif ($orig_id =~ m/(.+?_FG)P(\d+)/) {
      $line =~ s/\Q$orig_id/\Q$ret[1]/g;
      $ret[1] =~ /(.*)_T.*/;
      $line =~ /Parent=(.*);/;
      my $parent_id = $1;
      my @par_ret = translate_id($parent_id);
#print "Parent $parent_id translated:\n" . Dumper(@par_ret);
      $line =~ s/\Q$parent_id/\Q$par_ret[1]/g;
    }
    elsif ($orig_id =~ m/(.+?_FG)(\d+)/) {
      $line =~ s/\Q$orig_id/\Q$ret[1]/g;
      $line =~ /Parent=(.*);/;
      my $parent_id = $1;
      my @par_ret = translate_id($parent_id);
#print "Parent $parent_id translated:\n" . Dumper(@par_ret);
      $line =~ s/\Q$parent_id/\Q$par_ret[1]/g;    }
    else {
      $line =~ s/\Q$ret[0]/\Q$ret[1]/g;
    }
    print "$line;original_id:$orig_id\n";
  }  else {
    print "\nERROR ----------> unable to interpret [$orig_id]:\n$line\n\n";
    exit;
  }
  
#exit if ($orig_id eq 'AC195240.4_FG002.exon1');

}#each line
close GFF;



#########################################################################################
#########################################################################################
#########################################################################################

sub translate_id {
  my ($id) = @_;
  
  my ($old_id, $new_id);
  if ($id =~ m/(.+_FG\d+)/) {
    if ($xref{$1}) {
      $old_id = $1;
      $new_id = $xref{$1};
      return ($old_id, $new_id);
    }
  }
  elsif ($id =~ m/(.+?_FG)T(\d+)/) {
    if ($xref{$1.$2}) {
      $old_id = $1.$2;
      $new_id = $xref{$1.$2}."_T$2";
      return ($old_id, $new_id);
    }
  }
  elsif ($id =~ m/(.+?_FG)P(\d+)/) {
    if ($xref{$1.$2}) {
      $old_id = $1.$2;
      $new_id = $xref{$1.$2}."_T$2";
      return ($old_id, $new_id);
    }
  }
  elsif ($id =~ m/(.*?)_/) {
    if ($xref{$1}) {
      $old_id = $1;
      $new_id = $xref{$1};
      return ($old_id, $new_id);
    }
  }
  elsif ($xref{$id}) {
    $old_id = $id;
    $new_id = $xref{$id};
    return ($old_id, $new_id);
  }

  return undef;
}#translate_id


