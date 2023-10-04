# file: fix_grasses.pl
#
# purpose: One-off script to clean up grass data for pandagma-fam
# 
# Data downloaded from https://ensembl.gramene.org/ and https://phytozome-next.jgi.doe.gov/
#
# File name progression:
#    1. Remove organelle records --> *.no_organelles
#    2. Remove MAKER id prefixes --> *.trimmed
#    3. Create transcript identifiers where they don't match new[gff3/cds/pep]  (only some)
#      3a. normalize to *.fixed.trimmed and remove *.trimmed
#    4. rename all files to more standardized names
#
# history:
#  09/27/23  eksc created

use strict;
use Cwd;
use Data::Dumper;

my $usage = <<EOS

    usage: 
      perl fix_grasses.pl [work-directory]
      
    example:
      perl fix_grasses.pl grasses
    
EOS
;

  
  my ($workdir) = @ARGV;
  if (!$workdir) {
    die $usage;
  }

  # Used all over
  my ($f, %xref, $cmd, $orig_id, $cdsfile, $cdsfile_new, $gfffile, $gfffile_new, $proteinfile, $proteinfile_new);

  my $cur_dir = getcwd();
  chdir $workdir;

  my @cdsfiles     = glob("*.cds.*");
  my @gfffiles     = glob("*.gff3*");
  my @proteinfiles = (glob("*.protein*"), glob("*.pep*"));

  # Remove all *.trimmed and *.prefixed files (THIS FAILS!)
#  print "\nClean up leftovers from previous run\n";
#  $cmd = 'rm *.trimmed *.prefixed *.fixed *.no_organelles';
#  print "$cmd\n";
#  `$cmd`;


#=cut  
  #### Step 1: Remove organelle gene models ####
  print "\nStep1: remove organelle gene models\n";
  my %organelles;
  for $f (@gfffiles) {
    $cmd = "cat $f | awk '{if(!(\$1~/Pt/&&\$1~Mt)){print}}' > $f.no_organelles";
    print "$cmd\n";
    `$cmd`;
  }
#=cut
  

#=cut
  #### Step 2: Get rid of 'gene:' et cetera ####
  print "\nStep 2: Remove MAKER's id prefixes from GFF files...\n";
  for $f (@gfffiles) {
    $cmd = "cat $f.no_organelles | perl -nle 's/=(.*?):/=/g; print' > $f.trimmed";
    print "$cmd\n";
    `$cmd`;
  }#each GFF file
#=cut 
  
  
  #### Step 3: Fix files with transcript ids that are unrelated to gene ids ####
  print "\n\nStep 3: Fix datasets with transcript ids that are unrelated to gene ids.\n";
  my @species = ('Brachypodium_distachyon', 'Setaria_italica', 'Setaria_viridis', 'Sorghum_bicolor');
  for my $sp (@species) {
    print "\nHandle files for $sp\n";
    
    # Make x-ref hash
    print "Make x-ref hash for $sp...\n";
    $cmd = "
      cat $sp*gff3.trimmed | grep -v \"#\" | awk '\$3~/mRNA/ {print \$9}' | perl -pe 's/=\\w+:/=/g' | 
      perl -pe 's/ID=(\\w+);Parent=(\\w+);.+/\$1\\t\$2/' |
      awk -v OFS=\"\\t\" '{if(\$2==prev){print \$1, \$2 \".\" ct; prev=\$2; ct++} 
                       if(\$2!=prev){ct=1; print \$1, \$2 \".\" ct; prev=\$2}}'";
    my @lines = `$cmd`;
    %xref = map{ chomp; my @t=split"\t"; $t[0] => $t[1] } @lines;

    # Convert GFF (.trimmed from step 1 above is temporary)
    my @t = grep { /$sp.*gff3/ } @gfffiles;
    $gfffile = $t[0] . '.trimmed';
    $gfffile =~ /(.*)\.gff3/;
    $gfffile_new = "$1.gff3.fixed.trimmed";
    print "Translate identifiers in GFF file $gfffile and write to $gfffile_new\n";
    open GFF, "<$gfffile" or die "\nUnable to open $gfffile: $!\n\n";
    open GFFNEW, ">$gfffile_new" or die "\nUnable to open $gfffile_new for writing: $!\n\n";
    while (<GFF>) {
      next if (m/##/);
      if (/\tmRNA\t/) {
        if (/ID=(.*?);/) {
          $orig_id = $1;
        }
        else {
          print "\nCan't find id for\n$_\n\n";
          exit;
        }
      
        if (!$xref{$orig_id}) {
          print "\nUnable to find a translation for $orig_id.\n\n";
          exit;
        }
        s/$orig_id/$xref{$orig_id}/;
      }#mRNA record
      print GFFNEW $_;
    }#each gff record
    close GFF;
    close GFFNEW;
    
    print "Delete temporary file $gfffile\n";
    `rm $gfffile`;
    
    # Convert CDS
    my @t = grep { /$sp.*\.cds\./ } @cdsfiles;
    $cdsfile =$t[0];
    $cdsfile =~ /(.*)\.cds/;
    $cdsfile_new = "$1.cds.fa.fixed";
    print "Translate identifiers in CDS file $cdsfile and write to $cdsfile_new\n";
    open CDS, "<$cdsfile" or die "\nUnable to open $cdsfile: $!\n\n";
    open CDSNEW, ">$cdsfile_new" or die "\nUnable to open $cdsfile_new for writing: $!\n\n";
    while (<CDS>) {
      if (/>/) {
        />(.*?)\s/;
        $orig_id = $1;
        if (!$xref{$orig_id}) {
          print "\nUnable to find a translation for $orig_id.\n\n";
          exit;
        } 
        s/$orig_id/$xref{$orig_id}/;
      }
      
      print CDSNEW $_;
    }
    close CDS;
    close CDSNEW;

    # Convert protein fasta
    my @t = grep { /$sp.*\.pep\./ } @proteinfiles;
    my $proteinfile = $t[0];
    $proteinfile =~ /(.*)\.pep/;
    $proteinfile_new = "$1.pep.fa.fixed";
    print "Translate identifiers in protein file $proteinfile and write to $proteinfile_new\n";
    open PROT, "<$proteinfile" or die "\nUnable to open $proteinfile: $!\n\n";
    open PROTNEW, ">$proteinfile_new" or die "\nUnable to open $proteinfile_new for writing: $!\n\n";
    while (<PROT>) {
      if (/>/) {
        />(.*?)\s/;
        $orig_id = $1;
        if (!$xref{$orig_id}) {
          print "\nUnable to find a protein for $orig_id.\n\n";
          exit;
        } 
        s/$orig_id.*/$xref{$orig_id}/;
      }
      
      print PROTNEW $_;
    }
    close PROT;
    close PROTNEW;
  }#each species
#=cut


  # Add zea-style annotation prefixes to all ids
  print "\nAdd annotation prefixes to all ids\n";
  my %species_prefix = (
    'Brachypodium_distachyon' => 'Bd99999aa', 
    'Eragrostis_tef'          => 'Et99999aa', 
    'Hordeum_vulgare'         => 'Hv99999aa',
    'Oryza_sativa'            => 'Os99999aa', 
    'PhalliiHAL'              => 'Ph99998aa', 
    'Phallii_590'             => 'Ph99999aa',
    'Saccharum_spontaneum'    => 'Ss99999aa', 
    'Setaria_italica'         => 'Si99999aa', 
    'Setaria_viridis'         => 'Sv99999aa', 
    'Sorghum_bicolor'         => 'Sb99999aa',
    'Triticum_aestivum'       => 'Ta99999aa',
  );

  # Update file arrays
  @cdsfiles     = glob("*.cds.*");
  @gfffiles     = glob("*.gff3*");
  @proteinfiles = (glob("*.protein*"), glob("*.pep*"));
#print "CDS files:\n" . Dumper(@cdsfiles) . "\nGFF files:\n" . Dumper(@gfffiles) . "\nProtein files:\n" . Dumper(@proteinfiles) . "\n";
  
  my @t;
  for my $sp (keys %species_prefix) {
    my $prefix = $species_prefix{$sp};
    
    # add prefix to GFF files
    print "\n$sp\n";
    my @t = grep { /$sp.*gff3*.trimmed/ } @gfffiles;
    $gfffile = $t[0];
    print "GFF file: $gfffile\n";
    $cmd = "cat $gfffile | perl -nle 'if(!/chromosome/){s/ID=(.*?);/ID=$prefix.\$1;/g;} print' > $gfffile.prefixed";
    print "$cmd\n";
    `$cmd`;

    # Add prefix to cds files and remove trailing information on def lines
    @t = grep { /$sp.*\.cds.*/ } @cdsfiles;
    if (scalar @t > 1) {
      my @t1 = grep { /fixed/ } @t;
      $cdsfile = $t1[0];
    }
    else {
      $cdsfile = $t[0];
    }
    print "CDS file: $cdsfile\n";
    $cmd = "cat $cdsfile | ";
    $cmd .= "perl -nle 'if(/\\s/){s/>(.*?)\\s.*/>$prefix.\$1/}else{s/>(.*)/>$prefix.\$1/g;} print' ";
    $cmd .= "> $cdsfile.prefixed";
    print "$cmd\n";
    `$cmd`;

    @t = grep { /$sp.*\.pep.*/ } @proteinfiles;
    if (scalar @t > 1) {
      my @t1 = grep { /fixed/ } @t;
      $proteinfile = $t1[0];
    }
    else {
      $proteinfile = $t[0];
    }
    print "Protein file: $proteinfile\n";
    $cmd = "cat $proteinfile | ";
    $cmd .= "perl -nle 'if(/\\s/){s/>(.*?)\\s.*/>$prefix.\$1/}else{s/>(.*)/>$prefix.\$1/g;} print' ";
    $cmd .= "> $proteinfile.prefixed";
    print "$cmd\n";
    `$cmd`;
  }#each species
#=cut
exit;

  # Rename everything
  print "\nStep 3: Rename files and tar-gzip 'em ...\n";
  `mv Brachypodium_distachyon.Brachypodium_distachyon_v3.0.57.gff3.fixed.prefixed Brachypodium_distachyon-3.0.gff3`;
  `mv Brachypodium_distachyon.Brachypodium_distachyon_v3.0.cds.fa.fixed.prefixed Brachypodium_distachyon-3.0.cds.fa`;
  `mv Brachypodium_distachyon.Brachypodium_distachyon_v3.0.pep.fa.fixed.prefixed Brachypodium_distachyon-3.0.protein.fa`;
  `mv Eragrostis_tef.Salk_teff_dabbi_3.0.57.gff3.trimmed.prefixed Eragrostis_tef_Salk_teff_dabbi-3.0.gff3`;
  `mv Eragrostis_tef.Salk_teff_dabbi_3.0.cds.all.fa.prefixed Eragrostis_tef_Salk_teff_dabbi-3.0.cds.fa`;
  `mv Eragrostis_tef.Salk_teff_dabbi_3.0.pep.all.fa.prefixed Eragrostis_tef_Salk_teff_dabbi-3.0.protein.fa`;
  `mv Hordeum_vulgare.MorexV3_pseudomolecules_assembly.57.gff3.trimmed.prefixed Hordeum_vulgare_Morex-3.0.gff3`;
  `mv Hordeum_vulgare.MorexV3_pseudomolecules_assembly.cds.all.fa.prefixed Hordeum_vulgare_Morex-3.0.cds.fa`;
  `mv Hordeum_vulgare.MorexV3_pseudomolecules_assembly.pep.all.fa.prefixed Hordeum_vulgare_Morex-3.0.protein.fa`;
  `mv Oryza_sativa.IRGSP-1.0.57.gff3.trimmed.prefixed Oryza_sativa_IRGSP-1.0.gff3`;
  `mv Oryza_sativa.IRGSP-1.0.cds.all.fa.prefixed Oryza_sativa_IRGSP-1.0.cds.fa`;
  `mv Oryza_sativa.IRGSP-1.0.pep.all.fa.prefixed Oryza_sativa_IRGSP-1.0.protein.fa`;
  `mv Phallii_590_v3.2.cds.fa.prefixed Panicum_hallii_590-3.2.cds.fa`;
  `mv Phallii_590_v3.2.gene.gff3.trimmed.prefixed Panicum_hallii_590-3.2.gff3`;
  `mv Phallii_590_v3.2.pep.fa.prefixed Panicum_hallii_590-3.2.protein.fa`;
  `mv PhalliiHAL_591_v2.2.cds.fa.prefixed Panicum_hallii_591-2.2.cds.fa`;
  `mv PhalliiHAL_591_v2.2.gene.gff3.trimmed.prefixed Panicum_hallii_591-2.2.gff3`;
  `mv PhalliiHAL_591_v2.2.pep.fa.prefixed Panicum_hallii_591-2.2.protein.fa`;
  `mv Saccharum_spontaneum.Sspon.HiC_chr_asm.55.gff3.trimmed.prefixed Saccharum_spontaneum_Sspon.gff3`;
  `mv Saccharum_spontaneum.Sspon.HiC_chr_asm.cds.all.fa.prefixed Saccharum_spontaneum_Sspon.cds.fa`;
  `mv Saccharum_spontaneum.Sspon.HiC_chr_asm.pep.all.fa.prefixed Saccharum_spontaneum_Sspon.protein.fa`;
  `mv Setaria_italica.Setaria_italica_v2.0.57.gff3.fixed.prefixed Setaria_italica-2.0.gff3`;
  `mv Setaria_italica.Setaria_italica_v2.0.cds.fa.fixed.prefixed Setaria_italica-2.0.cds.fa`;
  `mv Setaria_italica.Setaria_italica_v2.0.pep.fa.fixed.prefixed Setaria_italica-2.0.protein.fa`;
  `mv Setaria_viridis.Setaria_viridis_v2.0.57.gff3.fixed.prefixed Setaria_viridis-2.0.gff3`;
  `mv Setaria_viridis.Setaria_viridis_v2.0.cds.fa.fixed.prefixed Setaria_viridis-2.0.cds.fa`;
  `mv Setaria_viridis.Setaria_viridis_v2.0.pep.fa.fixed.prefixed Setaria_viridis-2.0.protein.fa`;
  `mv Sorghum_bicolor.Sorghum_bicolor_NCBIv3.57.gff3.fixed.prefixed Sorghum_bicolor_NCBI-3.0.gff3`;
  `mv Sorghum_bicolor.Sorghum_bicolor_NCBIv3.cds.fa.fixed.prefixed Sorghum_bicolor_NCBI-3.0.cds.fa`;
  `mv Sorghum_bicolor.Sorghum_bicolor_NCBIv3.pep.fa.fixed.prefixed Sorghum_bicolor_NCBI-3.0.protein.fa`;
  `mv Triticum_aestivum.IWGSC.57.gff3.trimmed.prefixed Triticum_aestivum_IWGSC.gff3`;
  `mv Triticum_aestivum.IWGSC.cds.all.fa.prefixed Triticum_aestivum_IWGSC.cds.fa`;
  `mv Triticum_aestivum.IWGSC.pep.all.fa.prefixed Triticum_aestivum_IWGSC.protein.fa`;
  
  print "Remove old tarfile, if any...\n";
  `rm grasses.tar.gz`;
  
  print "Tar up the new files.\n";
  $cmd = "tar -cvf grasses.tar ";
  $cmd .= "Brachypodium_distachyon-3.0* Eragrostis_tef_Salk_teff_dabbi-3.0* Hordeum_vulgare_Morex-3.0* ";
  $cmd .= "Oryza_sativa_IRGSP-1.0* Panicum_hallii_590-3.2* Panicum_hallii_591-2.2* ";
  $cmd .= "Saccharum_spontaneum_Sspon.* Setaria_italica-2.0* Setaria_viridis-2.0* ";
  $cmd .= "Sorghum_bicolor_NCBI-3.0* Triticum_aestivum_IWGSC*";
  print $cmd;
  
  print "... and gzip\n";
  `gzip grasses.tar`;

  print "\n\nDONE\n\n";





