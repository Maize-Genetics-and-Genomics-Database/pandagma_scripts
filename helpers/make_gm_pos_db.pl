# file: make_gm_pos_db.pl
# 
# purpose: load bed files into an SQLite database
# 
# To run on Ceres:
#   salloc
#   ml miniconda
#   conda activate post-process
# 
# history
#   07/24/24  eskc  created
 
use strict;
use DBI;
use Data::Dumper;

my $usage = <<EOS

    usage: 
      perl make_gm_pos.pl [bed-file-directory]
      
    example:
      perl make_gm_pos.pl pandagma/data
    
EOS
;

  
  my ($bed_dir) = @ARGV;
  if (!$bed_dir) {
    die $usage;
  }

  my $dbh = get_db_connection();

  # Used all over
  my ($ret, $sql, $sth);
  my $table_name = 'gene_model_positions';

  # Create table if it doesn't exist
  make_table($dbh);
  
  my @bed_files = glob($bed_dir . '/*.bed*');
  print "Found " . (scalar @bed_files) . " files in $bed_dir.\n";
  my $file_count = 0;
  foreach my $file (@bed_files) {
    if (-z $file) {  
      # File is empty
      print "\nWARNING: $file is empty.\n\n";
      next;
    }
    
    my $count = 0;
    print "$file_count: load positions in $file\n";
    if ($file =~ /.gz$/) {
      `gunzip $file`;
      print "file un-gzipped.\n";
      $file =~ s/(.*).gz$/$1/;
    }
    
    $sql= "BEGIN TRANSACTION;";
    $sth = $dbh->prepare($sql);
    $ret = $sth->execute();
    print "Start transaction...\n";
    
    print "Read from '$file'\n";
    open BED, "<$file" or die "\nUnable to open $1: $!\n\n";
print "Opened $file.\n";
    while (<BED>) {
      chomp;
      my @fields = split /\t/;
      #$fields[0] =~ s/.*?\.(chr\d+)/$1/;
      $fields[3] =~ /(.*)_T\d+/;
      my $gene_model = $1;
      add_record($gene_model, $fields[3], $fields[0], $fields[1], $fields[2], $fields[5], $dbh);
      $count++;
#last if ($count > 2);
    }#each line in bed file
    close BED;
    
    $sql= "COMMIT;";
    $sth = $dbh->prepare($sql);
    $ret = $sth->execute();
    print "...committed transaction with $count records.\n";
    
    `gzip $file`;
    print "gzipped file.\n\n";
#last;
    $file_count++;
  }#each file
  
  $dbh->disconnect();
  
  print "\n\n\nDONE\nProcessed $file_count files.\n\n";
  


#########################################################################################
#########################################################################################
#########################################################################################

sub add_record {
  my ($gene_model, $transcript, $chr, $start, $end, $strand, $dbh) = @_;
  my ($sql, $sth, $ret);

#print "Add record with:\nadd_record($gene_model, $transcript, $chr, $start, $end, $strand)\n";
  $sql = qq(
    INSERT INTO $table_name
      (gene_model, transcript, chr, start, end, strand)
    VALUES
      ('$gene_model', '$transcript', '$chr', $start, $end, '$strand'););
#print "\n$sql\n\n";
  $sth = $dbh->prepare($sql);
  $ret = $sth->execute();
}#add_record


sub get_db_connection {
  my $driver   = "SQLite"; 
  my $database = "gene_model_positions.db";
  my $dsn = "DBI:$driver:dbname=$database";
  my $userid = "";
  my $password = "";
  my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) 
     or die $DBI::errstr;

  print "Opened database successfully\n";
  return $dbh;
}#get_db_connection


sub make_table {
  my $dbh = $_[0];
  my ($sql, $sth, $ret, @row);
  
  $sql = "SELECT name FROM sqlite_master WHERE type='table' AND name='$table_name'";
  $sth = $dbh->prepare($sql);
  $ret = $sth->execute();
  if ($ret < 0) {
    print $DBI::errstr . "\n";
    exit;
  }
  elsif (@row = $sth->fetchrow_array()) {
    $sql = "DELETE FROM $table_name;";
    $sth = $dbh->prepare($sql);
    $ret = $sth->execute();
    if ($ret < 0) {
      print $DBI::errstr . "\n";
      exit;
    }
    print "Table $table_name exits. Truncated table\n";
  }
  else {
    $sql = qq(
      CREATE TABLE $table_name (
       transcript TEXT PRIMARY KEY NOT NULL,
       gene_model TEXT NOT NULL,
       chr TEXT NOT NULL,
       start TEXT NOT NULL,
       end TEXT NOT NULL,
       strand CHAR);
    );

    $ret = $dbh->do($sql);
    if ($ret < 0) {
       print $DBI::errstr . "\n";
    } 
    else {
       print "Table gene_model_positions was created successfully\n";
    }
  }
}#make_table

