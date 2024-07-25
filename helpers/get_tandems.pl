# file: get_tandems.pl
#
# purpose: Create a table of tandem arrays
# 
# input: 18_syn_pan_aug_extra.table.tsv from Pandagma
#
# output columns (space-deliminated):
#   tandem_id gene models
#
# This is how permissible gene model gaps are calculated by Pandagma:
#   ave_gene_gap=$(cat 02_fasta_prot/"$qryfile"."$faa" 02_fasta_prot/"$sbjfile"."$faa" | 
#                    awk '$1~/^>/ {print substr($1,2)}' | perl -pe 's/__/\t/g' | sort -k1,1 -k3n,3n |
#                    awk '$1 == prev1 && $3 > prev4 {sum+=$3-prev4; ct++; prev1=$1; prev3=$3; prev4=$4};
#                         $1 != prev1 || $3 <= prev4 {prev1=$1; prev3=$3; prev4=$4}; 
#                         END{print 100*int(sum/ct/100)}')
#   max_gene_gap=$(( ave_gene_gap * 20 ))
#
# history:
#  01/07/24  eksc created

use strict;
use DBI;
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

  my $dbh = get_db_connection();

  my $max_gap = 300000;
  
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
          # tandem array may exist, check position
          my @tandems = get_tandems($fields[$i], $dbh);
#print "All tandem arrays for this pan-gene:\n" . Dumper(@tandems) . "\n";
          foreach my $tandem (@tandems) {
            my $name = sprintf("$prefix%05d", $count);
            if ((scalar @{$tandem}) > 1) {
              my $tga = join ',', @{$tandem};
              print "$name $tga\n";
              $count++;
            }
          }#each TGA
        }#multiple transcripts
#exit if ($count > 10);
      }#each field in row
    }
  }#each line
  close IN;


#########################################################################################
#########################################################################################
#########################################################################################


sub get_db_connection {
  my $driver   = "SQLite"; 
  my $database = "gene_model_positions.db";
  my $dsn = "DBI:$driver:dbname=$database";
  my $userid = "";
  my $password = "";
  my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) 
     or die $DBI::errstr;

  return $dbh;
}#get_db_connection


sub get_tandems {
  my ($trans_str, $dbh) = @_;
  my ($ret, $sql, $sth, $row);
  
  my @transcripts = split(',', $trans_str);
  $sql = "
    SELECT * FROM gene_model_positions
    WHERE transcript IN ('" . join("','", @transcripts) . "')
    ORDER BY chr, MIN(start, end)";
#print "\n$sql\n";
  $sth = $dbh->prepare($sql);
  $ret = $sth->execute();
  my ($start, $end);
  my @tandems;
  my @tandem;
  my $this_chr;
  while ($row = $sth->fetchrow_hashref()) {
#print Dumper($row) . "\n";
    # starting a new tandem array?
    if ((scalar @tandems) == 0 || $row->{'chr'} ne $this_chr
        || ($end && $row->{'end'} > $end+$max_gap)) {
#print "\n$count: New TGA\n";
      if ((scalar @tandem) > 0) {
#print "Finished with this TGA, add it to the list.\n";
        push @tandems, [@tandem];
      }
#print "Start with " . $row->{'gene_model'} . "\n";
      $this_chr = $row->{'chr'};
      @tandem = ($row->{'gene_model'});
      $start = $row->{'start'};
      $end = $row->{'end'};
    }
    else {
#print "Add " . $row->{'gene_model'} . "\n";
      push @tandem, $row->{'gene_model'};
    }
  }#each gene model
  
  # Pick up the last TGA
#print "Add final TGA to list.\n";
  push @tandems, [@tandem];
  
  return @tandems;
}#get_tandems


