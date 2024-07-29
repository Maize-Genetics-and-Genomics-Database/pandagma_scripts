# file: find_overlapping_gene_models.pl
#
# purpose: Create a list of overlapping gene models
# 
# To run on Ceres:
#   salloc
#   ml miniconda
#   conda activate post-process
# 
# Input: positions from temporary SQLite data created by make_gm_pos_db.pl
#
# history:
#  07/25/24  eksc created

use strict;
use DBI;
use Cwd;
use Data::Dumper;

my $usage = <<EOS

    usage: 
      perl find_overlaping_gene_models.pl 
      
EOS
;
  
  my $dbh = get_db_connection();

  my $table_name = 'gene_model_positions';

#  my $sql = "SELECT gene_model, MIN(start), MAX(end) FROM $table_name ORDER BY chr, start";
  my $sql = "
    SELECT gene_model, chr, 
           MIN(CAST(start AS INTEGER)) AS minstart, 
           MAX(CAST(end AS INTEGER)) AS maxend
    FROM (
      SELECT gene_model, chr, start, end FROM gene_model_positions
    ) GROUP BY gene_model
    ORDER BY chr, CAST(minstart AS INTEGER)";
  my $sth = $dbh->prepare($sql);
  my $ret = $sth->execute();
  
  # prime the process
  my $row = $sth->fetchrow_hashref();
#print Dumper($row);
  my $gm = $row->{'gene_model'};
  my $chr = $row->{'chr'};
  my $start = $row->{'minstart'};
  my $end = $row->{'maxend'};
#print "\ngene_model=$gm, chr=$chr, start=$start, end=$end\n";
  
  my %overlaps;
  my $count = 1;
  while ($row = $sth->fetchrow_hashref()) {
#print Dumper($row);
    if ($row->{'maxend'} < $row->{'minstart'}) {
      print "\nyes, it can happen!\n" . Dumper($row) . "\n\n";
      exit;
    }
    if ($chr ne $row->{'chr'}) {
#print "New chr\n";
      $gm = $row->{'gene_model'};
      $chr = $row->{'chr'};
      $start = $row->{'minstart'};
      $end = $row->{'end'};
#print "\ngene_model=$gm, chr=$chr, start=$start, end=$end\n";
    }
    else {
#print "Compare " . $row->{'minstart'} . " and $end\n";
      if ($gm ne $row->{'gene_model'}) {
        if ($row->{'minstart'} < $end) {
          if (!$overlaps{$gm}) {
            $overlaps{$gm} = [$row->{'gene_model'}];
          } 
          else {
            push @{$overlaps{$gm}}, $row->{'gene_model'};
          }
#          print "$gm and " . $row->{'gene_model'}. " overlap.\n";
        }
        else {
          # reset to check next one
          $gm = $row->{'gene_model'};
          $chr = $row->{'chr'};
          $start = $row->{'minstart'};
          $end = $row->{'maxend'};
#print "\ngene_model=$gm, chr=$chr, start=$start, end=$end\n";
        }
      }#not a transcript for comparison gene model
    }#no chr change
    $count++;
#last if ($count > 1000000);
  }#each row
#print Dumper(%overlaps) . "\n";

  for my $gm (keys %overlaps) {
    print "$gm\t" . join(',', @{$overlaps{$gm}}) . "\n";
  }
  


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


