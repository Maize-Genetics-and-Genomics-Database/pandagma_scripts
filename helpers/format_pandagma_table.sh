#!/bin/bash

# file: format_pandagma_table.sh
# 
# Purpose: Format _genome.txt files for R table.
#          This also puts multiple transcripts per genome per pan-gene 
#          in a single cell separated by semicolons.
#
# DEPENDENCIES:
#   Imported here: R, bedtools
#   Must be installed: R tidyverse via install.packages("tidyverse")
#                          (may complain about missing 'ragg': ignore)
#
# NOTE: Run this script from within the pandagma output file
#
# History:
#  2023     MW    created
#  10/05/23 eksc  consolidated 

PREFIX=$1

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo "Script directory: $SCRIPT_DIR"

# Load modules
ml r/4.3.0
ml bedtools

# To hold temp working files
mkdir pandagma_csv


# Split 22_syn_pan_aug_extra_pctl25_posn.hsh.tsv into files named *.genome.txt 
#   panID transcript prefix.chromosome start end strand
#       --> panID transcript chromosome start end 
#   without transcript suffix
cat 22_syn_pan_aug_extra_pctl25_posn.hsh.tsv | tr '.' '\t' | 
  awk -v OFS="\t" '{print $3"_genome.txt",$1,$2,$3,$4}' | sort -k1,1 | uniq | awk '{print>"pandagma_csv/"$1}'


# Extract pan gene chromosomes from 23_syn_pan_pctl25_posn_cds.fna
cat 23_syn_pan_pctl25_posn_cds.fna | 
  perl -nle 'if(/>.*\.(chr.*?)_\d+_(pan\d+)/){print "$2\t$1"}' | sort -k1,1n > pandagma_csv/pan_chr.txt


cd pandagma_csv

# Make the pan-gene membership table
for sample in *_genome.txt
  do
   describer=$(echo ${sample} | sed 's/_genome.txt//')
   echo $sample $describer

   cat ${sample} | cut -f 2,3,5 | groupBy -g 1 -c 2,3 -o distinct,distinct | tr ',' ';' | 
     awk -v x=${describer} 'BEGIN { OFS=","; print "panID", "transcripts_"x,"chromosomeIDs_"x} {print $0}' | 
     sed -e 's/-1_genome.txt//g; s/-2_genome.txt//g; s/-3_genome.txt//g; s/-4_genome.txt//g' | 
     tr '\t' ',' > ${describer}_pandagma.csv

done
rm *_genome.txt

echo
echo "Run R script format_pandagma_table.R to create pandagma_table.txt, adding chrs to members"
Rscript $SCRIPT_IDR/format_pandagma_table.R


# Add the pan-gene prefix and chr to the table
cat pandagma_table.txt | head -n -1 | sort -k 1,1n |
  join -a 1 - pandagma_csv/pan_chr.txt |
  perl -nle 'if(/(.*?)\s(.*)pan_(chr\d+)/){print "$1\t$3\t$2"}else{s/(.*?)\s/$1\tNA\t/;print}' |
  awk -v PRE=$PREFIX '{print PRE $0}' > pandagma_table_chr.txt

:
