# This script retrieves data for a pan-gene calculation, from a remote location (typically https or ftp). 
# Retrieved files are typically nucleotide CDS files and/or protein files, and 
# corresponding annotation files, in GFF3 or BED format.

# Edit this file to identify the base URL for the remote location, and the files to retrieve.

set -o errexit
set -o nounset

if [ ! -d data ]; then mkdir -p data; fi
if [ ! -d data_orig ]; then mkdir -p data_orig; fi
base_dir=$PWD
url_base="https://download.maizegdb.org"

cd data_orig

#: << "END"
# Outside data is in ../../grasses - copy and rename
echo "Copy outside grass data..."
cp ../grasses/Brachypodium_distachyon-3.0.* .
cp ../grasses/Eragrostis_tef_Salk_teff_dabbi-3.0* .
cp ../grasses/Hordeum_vulgare_Morex-3.0.* .
cp ../grasses/Oryza_sativa_IRGSP-1.0.* .
cp ../grasses/Panicum_hallii_590-3.2.* .
cp ../grasses/Panicum_hallii_591-2.2.* .
cp ../grasses/Saccharum_spontaneum_Sspon.* .
cp ../grasses/Setaria_italica-2.0.* .
cp ../grasses/Setaria_viridis-2.0.* .
cp ../grasses/Sorghum_bicolor_NCBI-3.0.* .
cp ../grasses/Triticum_aestivum_IWGSC.* .

# Normalize the files by ensuring they are all gzipped
echo "...and gzip"
for file in *.fa *.gff3; do
  gzip $file &
done
wait
echo


#### GET CDS FILES ####
echo "Get CDS files..."
curl -O $url_base/Av-Kellogg1287_8-REFERENCE-PanAnd-1.0/Av-Kellogg1287_8-REFERENCE-PanAnd-1.0_Av00001aa.1.cds.fa.gz
curl -O $url_base/Td-FL_9056069_6-DRAFT-PanAnd-1.0/Td-FL_9056069_6-DRAFT-PanAnd-1.0_Td00001aa.1.cds.fa.gz
curl -O $url_base/Td-KS_B6_1-DRAFT-PanAnd-1.0/Td-KS_B6_1-DRAFT-PanAnd-1.0_Td00002aa.1.cds.fa.gz
curl -O $url_base/Td-McKain334_5-DRAFT-PanAnd-1.0/Td-McKain334_5-DRAFT-PanAnd-1.0_Td00003aa.1.cds.fa.gz
curl -O $url_base/Zm-B73-REFERENCE-NAM-5.0/Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.cds.fa.gz

# Later:
#curl -O $url_base/Ab-Traiperm_572-DRAFT-PanAnd-1.0/Ab-Traiperm_572-DRAFT-PanAnd-1.0_Ab00001aa.1.cds.fa.gz
#curl -O $url_base/Ac-Pasquet1232-DRAFT-PanAnd-1.0/Ac-Pasquet1232-DRAFT-PanAnd-1.0_Ac00001aa.1.cds.fa.gz
#curl -O $url_base/Ag-CAM1351-DRAFT-PanAnd-1.0/Ag-CAM1351-DRAFT-PanAnd-1.0_Ac00001aa.1.cds.fa.gz
#curl -O $url_base/Bl-K1279B-DRAFT-PanAnd-1.0/Bl-K1279B-DRAFT-PanAnd-1.0_bl00001aa.1.cds.fa.gz
#curl -O $url_base/Cc-PI314907-DRAFT-PanAnd-1.0/Cc-PI314907-DRAFT-PanAnd-1.0_Cc00001aa.1.cds.fa.gz
#curl -O $url_base/Cr-AUB069-DRAFT-PanAnd-1.0/Cr-AUB069-DRAFT-PanAnd-1.0_Cr00001aa.1.cds.fa.gz
#curl -O $url_base/Cs-KelloggPI219580-DRAFT-PanAnd-1.0/Cs-KelloggPI219580-DRAFT-PanAnd-1.0_Cs00001aa.1.cds.fa.gz
#curl -O $url_base/Et-Layton_Zhong168-DRAFT-PanAnd-1.0/Et-Layton_Zhong168-DRAFT-PanAnd-1.0_Et00001aa.1.cds.fa.gz
#curl -O $url_base/Hc-AUB53_1-DRAFT-PanAnd-1.0/Hc-AUB53_1-DRAFT-PanAnd-1.0_Hc00001aa.1.cds.fa.gz
#curl -O $url_base/Hp-KelloggPI404118-DRAFT-PanAnd-1.0/Hp-KelloggPI404118-DRAFT-PanAnd-1.0/Hp00001aa.1.cds.fa.gz
#curl -O $url_base/Ir-Pasquet1136-DRAFT-PanAnd-1.0/Ir-Pasquet1136-DRAFT-PanAnd-1.0_Ir00001aa.1.cds.fa.gz
#curl -O $url_base/Pi-Clark-DRAFT-PanAnd-1.0/Pi-Clark-DRAFT-PanAnd-1.0_Pi00001aa.1.cds.fa.gz
#curl -O $url_base/Pp-Kellogg1297-DRAFT-PanAnd-1.0/Pp-Kellogg1297-DRAFT-PanAnd-1.0_Pp00001aa.1.cds.fa.gz
#curl -O $url_base/Rr-Malcomber3106-DRAFT-PanAnd-1.0/Rr-Malcomber3106-DRAFT-PanAnd-1.0_Rr00001aa.1.cds.fa.gz
#curl -O $url_base/Sm-PI203595-DRAFT-PanAnd-1.0/Sm-PI203595-DRAFT-PanAnd-1.0_Sm00001aa.1.cds.fa.gz
#curl -O $url_base/Sn-CAM1369-DRAFT-PanAnd-1.0/Sn-CAM1369-DRAFT-PanAnd-1.0_Sn00001aa.cds.fa.gz
#curl -O $url_base/Te-Pasquet1246-DRAFT-PanAnd-1.0/Te-Pasquet1246-DRAFT-PanAnd-1.0_Te00001aa.1.cds.fa.gz
#curl -O $url_base/Tz-DC_05_58_3A-DRAFT-PanAnd-1.0/Tz-DC_05_58_3A-DRAFT-PanAnd-1.0_Tz00001aa.1.cds.fa.gz
#curl -O $url_base/Ud-Pasquet1171-DRAFT-PanAnd-1.0/Ud-Pasquet1171-DRAFT-PanAnd-1.0_Ud00001aa.1.cds.fa.gz
#curl -O $url_base/Vc-Pasquet1098-DRAFT-PanAnd-1.0/Vc-Pasquet1098-DRAFT-PanAnd-1.0_Vc00001aa.1.cds.fa.gz


#### GET GFF FILES ####
echo "... GFF files ..."
curl -O $url_base/Av-Kellogg1287_8-REFERENCE-PanAnd-1.0/Av-Kellogg1287_8-REFERENCE-PanAnd-1.0_Av00001aa.1.gff3.gz
curl -O $url_base/Td-FL_9056069_6-DRAFT-PanAnd-1.0/Td-FL_9056069_6-DRAFT-PanAnd-1.0_Td00001aa.1.gff3.gz
curl -O $url_base/Td-KS_B6_1-DRAFT-PanAnd-1.0/Td-KS_B6_1-DRAFT-PanAnd-1.0_Td00002aa.1.gff3.gz
curl -O $url_base/Td-McKain334_5-DRAFT-PanAnd-1.0/Td-McKain334_5-DRAFT-PanAnd-1.0_Td00003aa.1.gff3.gz
curl -O $url_base/Zm-B73-REFERENCE-NAM-5.0/Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.gff3.gz

# Later:
#curl -O $url_base/Ab-Traiperm_572-DRAFT-PanAnd-1.0/Ab-Traiperm_572-DRAFT-PanAnd-1.0_Ab00001aa.1.gff3.gz
#curl -O $url_base/Ac-Pasquet1232-DRAFT-PanAnd-1.0/Ac-Pasquet1232-DRAFT-PanAnd-1.0_Ac00001aa.1.gff3.gz
#curl -O $url_base/Ag-CAM1351-DRAFT-PanAnd-1.0/Ag-CAM1351-DRAFT-PanAnd-1.0_Ac00001aa.1.gff3.gz
#curl -O $url_base/Bl-K1279B-DRAFT-PanAnd-1.0/Bl-K1279B-DRAFT-PanAnd-1.0_bl00001aa.1.gff3.gz
#curl -O $url_base/Cc-PI314907-DRAFT-PanAnd-1.0/Cc-PI314907-DRAFT-PanAnd-1.0_Cc00001aa.1.gff3.gz
#curl -O $url_base/Cr-AUB069-DRAFT-PanAnd-1.0/Cr-AUB069-DRAFT-PanAnd-1.0_Cr00001aa.1.gff3.gz
#curl -O $url_base/Cs-KelloggPI219580-DRAFT-PanAnd-1.0/Cs-KelloggPI219580-DRAFT-PanAnd-1.0_Cs00001aa.1.gff3.gz
#curl -O $url_base/Et-Layton_Zhong168-DRAFT-PanAnd-1.0/Et-Layton_Zhong168-DRAFT-PanAnd-1.0_Et00001aa.1.gff3.gz
#curl -O $url_base/Hc-AUB53_1-DRAFT-PanAnd-1.0/Hc-AUB53_1-DRAFT-PanAnd-1.0_Hc00001aa.1.gff3.gz
#curl -O $url_base/Hp-KelloggPI404118-DRAFT-PanAnd-1.0/Hp-KelloggPI404118-DRAFT-PanAnd-1.0/Hp00001aa.1.gff3.gz
#curl -O $url_base/Ir-Pasquet1136-DRAFT-PanAnd-1.0/Ir-Pasquet1136-DRAFT-PanAnd-1.0_Ir00001aa.1.gff3.gz
#curl -O $url_base/Pi-Clark-DRAFT-PanAnd-1.0/Pi-Clark-DRAFT-PanAnd-1.0_Pi00001aa.1.gff3.gz
#curl -O $url_base/Pp-Kellogg1297-DRAFT-PanAnd-1.0/Pp-Kellogg1297-DRAFT-PanAnd-1.0_Pp00001aa.1.gff3.gz
#curl -O $url_base/Rr-Malcomber3106-DRAFT-PanAnd-1.0/Rr-Malcomber3106-DRAFT-PanAnd-1.0_Rr00001aa.1.gff3.gz
#curl -O $url_base/Sm-PI203595-DRAFT-PanAnd-1.0/Sm-PI203595-DRAFT-PanAnd-1.0_Sm00001aa.1.gff3.gz
#curl -O $url_base/Sn-CAM1369-DRAFT-PanAnd-1.0/Sn-CAM1369-DRAFT-PanAnd-1.0_Sn00001aa.gff3.gz
#curl -O $url_base/Te-Pasquet1246-DRAFT-PanAnd-1.0/Te-Pasquet1246-DRAFT-PanAnd-1.0_Te00001aa.1.gff3.gz
#curl -O $url_base/Tz-DC_05_58_3A-DRAFT-PanAnd-1.0/Tz-DC_05_58_3A-DRAFT-PanAnd-1.0_Tz00001aa.1.gff3.gz
#curl -O $url_base/Ud-Pasquet1171-DRAFT-PanAnd-1.0/Ud-Pasquet1171-DRAFT-PanAnd-1.0_Ud00001aa.1.gff3.gz
#curl -O $url_base/Vc-Pasquet1098-DRAFT-PanAnd-1.0/Vc-Pasquet1098-DRAFT-PanAnd-1.0_Vc00001aa.1.gff3.gz


#### GET PROTEIN FILES ####
echo "... and protein files."
curl -O $url_base/Av-Kellogg1287_8-REFERENCE-PanAnd-1.0/Av-Kellogg1287_8-REFERENCE-PanAnd-1.0_Av00001aa.1.protein.fa.gz
curl -O $url_base/Td-FL_9056069_6-DRAFT-PanAnd-1.0/Td-FL_9056069_6-DRAFT-PanAnd-1.0_Td00001aa.1.protein.fa.gz
curl -O $url_base/Td-KS_B6_1-DRAFT-PanAnd-1.0/Td-KS_B6_1-DRAFT-PanAnd-1.0_Td00002aa.1.protein.fa.gz
curl -O $url_base/Td-McKain334_5-DRAFT-PanAnd-1.0/Td-McKain334_5-DRAFT-PanAnd-1.0_Td00003aa.1.protein.fa.gz
curl -O $url_base/Zm-B73-REFERENCE-NAM-5.0/Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.protein.fa.gz

# Later:
#curl -O $url_base/Ab-Traiperm_572-DRAFT-PanAnd-1.0/Ab-Traiperm_572-DRAFT-PanAnd-1.0_Ab00001aa.1.protein.gz
#curl -O $url_base/Ac-Pasquet1232-DRAFT-PanAnd-1.0/Ac-Pasquet1232-DRAFT-PanAnd-1.0_Ac00001aa.1.protein.gz
#curl -O $url_base/Ag-CAM1351-DRAFT-PanAnd-1.0/Ag-CAM1351-DRAFT-PanAnd-1.0_Ac00001aa.1.protein.gz
#curl -O $url_base/Bl-K1279B-DRAFT-PanAnd-1.0/Bl-K1279B-DRAFT-PanAnd-1.0_bl00001aa.1.protein.gz
#curl -O $url_base/Cc-PI314907-DRAFT-PanAnd-1.0/Cc-PI314907-DRAFT-PanAnd-1.0_Cc00001aa.1.protein.gz
#curl -O $url_base/Cr-AUB069-DRAFT-PanAnd-1.0/Cr-AUB069-DRAFT-PanAnd-1.0_Cr00001aa.1.protein.gz
#curl -O $url_base/Cs-KelloggPI219580-DRAFT-PanAnd-1.0/Cs-KelloggPI219580-DRAFT-PanAnd-1.0_Cs00001aa.1.protein.gz
#curl -O $url_base/Et-Layton_Zhong168-DRAFT-PanAnd-1.0/Et-Layton_Zhong168-DRAFT-PanAnd-1.0_Et00001aa.1.protein.gz
#curl -O $url_base/Hc-AUB53_1-DRAFT-PanAnd-1.0/Hc-AUB53_1-DRAFT-PanAnd-1.0_Hc00001aa.1.protein.gz
#curl -O $url_base/Hp-KelloggPI404118-DRAFT-PanAnd-1.0/Hp-KelloggPI404118-DRAFT-PanAnd-1.0/Hp00001aa.1.protein.gz
#curl -O $url_base/Ir-Pasquet1136-DRAFT-PanAnd-1.0/Ir-Pasquet1136-DRAFT-PanAnd-1.0_Ir00001aa.1.protein.gz
#curl -O $url_base/Pi-Clark-DRAFT-PanAnd-1.0/Pi-Clark-DRAFT-PanAnd-1.0_Pi00001aa.1.protein.gz
#curl -O $url_base/Pp-Kellogg1297-DRAFT-PanAnd-1.0/Pp-Kellogg1297-DRAFT-PanAnd-1.0_Pp00001aa.1.protein.gz
#curl -O $url_base/Rr-Malcomber3106-DRAFT-PanAnd-1.0/Rr-Malcomber3106-DRAFT-PanAnd-1.0_Rr00001aa.1.protein.gz
#curl -O $url_base/Sm-PI203595-DRAFT-PanAnd-1.0/Sm-PI203595-DRAFT-PanAnd-1.0_Sm00001aa.1.protein.gz
#curl -O $url_base/Sn-CAM1369-DRAFT-PanAnd-1.0/Sn-CAM1369-DRAFT-PanAnd-1.0_Sn00001aa.protein.gz
#curl -O $url_base/Te-Pasquet1246-DRAFT-PanAnd-1.0/Te-Pasquet1246-DRAFT-PanAnd-1.0_Te00001aa.1.protein.gz
#curl -O $url_base/Tz-DC_05_58_3A-DRAFT-PanAnd-1.0/Tz-DC_05_58_3A-DRAFT-PanAnd-1.0_Tz00001aa.1.protein.gz
#curl -O $url_base/Ud-Pasquet1171-DRAFT-PanAnd-1.0/Ud-Pasquet1171-DRAFT-PanAnd-1.0_Ud00001aa.1.protein.gz
#curl -O $url_base/Vc-Pasquet1098-DRAFT-PanAnd-1.0/Vc-Pasquet1098-DRAFT-PanAnd-1.0_Vc00001aa.1.protein.gz
#END
exit


### EXTRACT LONGEST AS CANONICAL WHERE NEEDED; CDS ###
echo
echo "Make canonical CDS files if missing"
for file in *.cds.fa.gz; do
  if [[ "$file" != *canonical.cds.fa.gz ]]; then
    base=`basename $file .cds.fa.gz`
    if [[ "$file" =~ REFERENCE || "$file" =~ DRAFT ]]; then
      echo "Handle mgdb-style file; IDs like Zm00001eb128210_T001 ==> Zm00001eb.128210_T001"
      zcat $file | awk '{print $1}' | perl -pe 's/^>(\D+\d+\D+)(\d+\S+)/>$1.$2/' |
        ../bin/fasta_to_table.awk |
        perl -pe 's/(\S+)_T(\d+)\t/$1\tT$2\t/' |
        awk -v FS="\t" -v OFS="\t" '{print $1, length($3), $2, $3}' |
        sort -k1,1 -k2nr,2nr |
        ../bin/top_line.awk | awk -v FS="\t" '{print ">" $1 "_" $3; print $4}' |
        cat > ../data/$base.canonical.cds.fa
    elif [[ "$file" =~ Oryza ]]; then
      echo "Handle Ozyza_sativa file; IDs like Os99999aa.transcript-rps2 or Os99999aa.Os03t0845800-01"
      zcat $file | awk '{print $1}' | ../bin/fasta_to_table.awk |
        perl -pe 's/(Os\S+\.Os\S+)-(\d+)\t(\S+)/$1\t$2\t$3/; 
                  s/(Os\S+\.transcript-\S+)\t(\S+)/$1\t999\t$2/' | 
        awk -v FS="\t" -v OFS="\t" '{print $1, length($3), $2, $3}' |
        sort -k1,1 -k2nr,2nr |
        ../bin/top_line.awk | 
        awk '$1!~/Os01t0235400|Os01t0275300|Os01t0337700|Os01t0782300|Os03t0355900|Os03t0359100|Os03t0776100|Os04t0644950/ && \
             $1!~/Os07t0251200|Os08t0199200|Os09t0347401|Os11t0533550|Os11t0594900|Os12t0113001|-petB|-petD|-rpl16|-rps16/' |
          awk -v FS="\t" '$3!=999 {print ">" $1 "-" $3; print $4} 
                          $3==999 {print ">" $1; print $4}' |
        cat > ../data/$base.canonical.cds.fa
    elif [[ "$file" =~ Eragrostis ]]; then
      echo "Handle Eragrostis file; IDs like Et99999aa.Et_5A_041911.mRNA1 (but only one splicevar per gene)"
      zcat $file | awk '{print $1}' | ../bin/fasta_to_table.awk | 
        awk -v FS="\t" '{print ">" $1; print $2}' |
        cat > ../data/$base.canonical.cds.fa
    elif [[ "$file" =~ Hordeum ]]; then
      echo "Handle Hordeum file; IDs like Hv99999aa.HORVU.MOREX.r3.7HG0737000.1.CDS1"
      zcat $file | awk '{print $1}' | 
        ../bin/fasta_to_table.awk | 
        awk -v FS="\t" '{print ">" $1; print $2}' |
        cat > ../data/$base.canonical.cds.fa
    else
      echo "Handle outside file (not MaizeGDB or the special cases above)"
      zcat $file | awk '{print $1}' | perl -pe 's/^>(\S+)\.p$/>$1/; s/\.cds\d+$//i' |
        ../bin/longest_variant_from_fasta.sh > ../data/$base.canonical.cds.fa
    fi
    printf "  Printed ../data/$base.canonical.cds.fa\n"
  fi
done

### EXTRACT LONGEST AS CANONICAL WHERE NEEDED; PROTEIN ###
echo
echo "Make canonical protein files if missing"
for file in *.protein.fa.gz; do
  if [[ "$file" != *canonical.protein.fa.gz ]]; then
    base=`basename $file .protein.fa.gz`
    if [[ "$file" =~ REFERENCE || "$file" =~ DRAFT ]]; then
      echo "Handle mgdb-style file; IDs like Zm00001eb128210_T001 ==> Zm00001eb.128210_T001"
      zcat $file | awk '{print $1}' | perl -pe 's/^>(\D+\d+\D+)(\d+\S+)/>$1.$2/' | 
        ../bin/fasta_to_table.awk |
        perl -pe 's/(\S+)_[PT](\d+)\t/$1\tT$2\t/' |
        awk -v FS="\t" -v OFS="\t" '{print $1, length($3), $2, $3}' |
        sort -k1,1 -k2nr,2nr |
        ../bin/top_line.awk | awk -v FS="\t" '{print ">" $1 "_" $3; print $4}' |
        cat > ../data/$base.canonical.protein.fa
    elif [[ "$file" =~ Oryza ]]; then
      echo "Handle Ozyza_sativa file; IDs like Os99999aa.transcript-rps2 or Os99999aa.Os03t0845800-01"
      zcat $file | perl -pe 's/>(Os\S+)\.cds-\S+ .+(transcript-\S+) .+/>$1.$2/' |
        awk '{print $1}' | ../bin/fasta_to_table.awk |
        perl -pe 's/(Os\S+\.Os\S+)-(\d+)\t(\S+)/$1\t$2\t$3/; 
                  s/(Os\S+\.transcript-\S+)\t(\S+)/$1\t999\t$2/' | 
                    awk -v FS="\t" -v OFS="\t" '{print $1, length($3), $2, $3}' |
        sort -k1,1 -k2nr,2nr |
        awk '$2>20' |
        awk '$1!~/Os01t0235400|Os01t0275300|Os01t0337700|Os01t0782300|Os03t0355900|Os03t0359100|Os03t0776100|Os04t0644950/ && \
             $1!~/Os07t0251200|Os08t0199200|Os09t0347401|Os11t0533550|Os11t0594900|Os12t0113001|-petB|-petD|-rpl16|-rps16/' |
        ../bin/top_line.awk | 
          awk -v FS="\t" '$3!=999 {print ">" $1 "-" $3; print $4} 
                          $3==999 {print ">" $1; print $4}' |
        cat > ../data/$base.canonical.protein.fa
    elif [[ "$file" =~ Eragrostis ]]; then
      echo "Handle Eragrostis file; IDs like Et99999aa.Et_5A_041911.CDS (but only one splicevar per gene)"
      zcat $file | awk '{print $1}' | perl -pe 's/>(\S+)\.CDS\d?/>$1.mRNA1/' | ../bin/fasta_to_table.awk | 
        awk -v FS="\t" '{print ">" $1; print $2}' | 
        cat > ../data/$base.canonical.protein.fa
    elif [[ "$file" =~ Hordeum ]]; then
      echo "Handle Hordeum file; IDs like Hv99999aa.HORVU.MOREX.r3.7HG0737000.1.CDS1"
      zcat $file | awk '{print $1}' | 
        perl -pe 's/\.CDS\d?//' | ../bin/fasta_to_table.awk | 
        awk -v FS="\t" '{print ">" $1; print $2}' | perl -pe 's/>(\S+)\.CDS/>$1/' |
        cat > ../data/$base.canonical.protein.fa
    else
      echo "Handle outside file (not MaizeGDB or the special cases above)"
      zcat $file | awk '{print $1}' | perl -pe 's/^>(\S+)\.p$/>$1/; s/\.cds\d+$//i' |
        perl -pe 's/:cds\.1//' |
        ../bin/longest_variant_from_fasta.sh > ../data/$base.canonical.protein.fa
    fi
    printf "  Printed ../data/$base.canonical.protein.fa\n"
  fi
done


# Test numbers of IDs before and after
cd /project/maizegdb/ethy/pandagma/data
for file in *.cds.fa; do
  base=`basename $file .cds.fa`
  echo $base
  grep -c '>' ../data/$base.cds.fa
  grep -c '>' ../data/$base.protein.fa
  echo
done
# Fix Oryza, in which 15 genes differ. List and remove these.
  grep '>' Oryza*.cds.fa | sort > lis.Oryza.cds
  grep '>' Oryza*.protein.fa | sort > lis.Oryza.protein
  comm -3 lis.O* | perl -pe 's/\t?>Os[^.]+\.(.+)/$1/; s/-\d+$//; s/transcript-/-/' | sort -u | awk -v ORS="" '{print $1 " "} END{print "\n"}'
# The following are now removed as part of the cds and protein processing steps above
#  Os01t0235400 Os01t0275300 Os01t0337700 Os01t0782300 Os03t0355900 Os03t0359100 Os03t0776100 Os04t0644950 Os07t0251200 Os08t0199200 Os09t0347401 Os11t0533550 Os11t0594900 Os12t0113001 -petB -petD -rpl16 -rps16
  rm lis.*


### DERIVE BED FILES, PREFIXING THE CHROMOSOMES WITH THE ANNOTATION ID FIRST ###
cd /project/maizegdb/ethy/pandagma/data_orig
echo
echo "Derive BED from GFF. "
echo "Add annotation name (e.g. Av00001aa000001 or Bd99999aa) as prefix to the chromosome/scaffold names."
for file in *gff3.gz; do
  base=`basename $file .gff3.gz`
  if [[ "$file" =~ REFERENCE || "$file" =~ DRAFT ]]; then
    export annot_name=$(zcat $file | awk '$3~/gene/ {print $9}' | head -1 | perl -pe 's/ID=(\D+\d+\D+)\d+;.+/$1/')
  else
    export annot_name=$(zcat $file | awk '$3~/gene/ {print $9}' | head -1 | perl -pe 's/ID=(\D+\d+[a-z]+)\..+/$1/')
  fi
  printf "$annot_name\t$base\n"

  if [[ "$file" =~ Panicum ]]; then
    zcat $file | awk '$1!~/^#/ {print}' | perl -pe 's/\.v2\.2//g' |
      awk -v OFS="\t" -v PRE=$annot_name '\
        $1~/^[0-9]/ {print PRE ".chr" $1, $2, $3, $4, $5, $6, $7, $8, $9}
        $1!~/^[0-9]/ {print PRE "." $1, $2, $3, $4, $5, $6, $7, $8, $9}' |
      ../bin/gff_to_bed6_mRNA_simple.awk > ../data/$base.bed 
  elif [[ "$file" =~ REFERENCE || "$file" =~ DRAFT ]]; then
    zcat $file | awk '$1!~/^#/ {print}' | perl -pe 's/(\w+)=(\D+\d+\D+)(\d+)/$1=$2.$3/g' |
      awk -v OFS="\t" -v PRE=$annot_name '\
        $1~/^[0-9]/ {print PRE ".chr" $1, $2, $3, $4, $5, $6, $7, $8, $9}
        $1!~/^[0-9]/ {print PRE "." $1, $2, $3, $4, $5, $6, $7, $8, $9}' |
      ../bin/gff_to_bed6_mRNA_simple.awk > ../data/$base.bed 
  else 
    zcat $file | awk '$1!~/^#/ {print}' | 
      awk -v OFS="\t" -v PRE=$annot_name '\
        $1~/^[0-9]/ {print PRE ".chr" $1, $2, $3, $4, $5, $6, $7, $8, $9}
        $1!~/^[0-9]/ {print PRE "." $1, $2, $3, $4, $5, $6, $7, $8, $9}' |
      ../bin/gff_to_bed6_mRNA_simple.awk > ../data/$base.bed 
  fi
done

# Test IDs in cds, protein, and bed files
cd /project/maizegdb/ethy/pandagma/data
for file in *.cds.fa; do
  base=`basename $file .canonical.cds.fa`
  echo $base
  head -1 $base.canonical.cds.fa
  head -1 $base.canonical.protein.fa
  head -1 $base.bed
  echo
done

# Check counts in cds, protein, and bed files.
# Counts in bed files should be higher than cds or protein if there are multiple splice variants
cd /project/maizegdb/ethy/pandagma/data
for file in *.cds.fa; do
  base=`basename $file .canonical.cds.fa`
  echo $base
  grep -c '>' $base.canonical.cds.fa
  grep -c '>' $base.canonical.protein.fa
  wc -l $base.bed
  echo
done



### GZIP THE DERIVED DATA FILES ###
echo
echo "Compress the derived files in data"
cd /project/maizegdb/ethy/pandagma
for file in data/*fa data/*bed; do 
  gzip $file &
done
wait


### EXPECTED "QUOTAS" ###
cd /project/maizegdb/ethy/pandagma
cat << 'DATA' > data/expected_quotas.tsv
Av00001aa 2
Bd99999aa 2
Et99999aa 2
Hv99999aa 2
Os99999aa 2
Ph99998aa 2
Ph99999aa 2
Ss99999aa 4
Si99999aa 2
Sv99999aa 2
Sb99999aa 2
Ta99999aa 6
Zm00001eb 2
DATA


