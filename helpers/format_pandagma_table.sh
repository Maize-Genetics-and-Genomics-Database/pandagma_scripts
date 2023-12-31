#!/bin/bash

# file: format_pandagma_table.sh
# 
# Purpose: Format _genome.txt files for loading into MaizeGDB.
#
# Produces a table of pan-IDs and annotation IDs and chromosomes for each constituent gene:
#   panID gene-model chr start end strand panChr-full panChr pan-start pan-end pan-strand exemplar
# Example:
#   pan00001 Zd00001aa032704_T001 Zd-Gigi_PanAnd-1.chr9 48262170 48264952 + Zea.pan3.chr09_039400_pan00001 chr09 039400 3940000 3941000 + Zm00001eb376300_T001
#
# NOTE: Run this script from within the pandagma output directory
#
# History:
#  10/01/23  sbc  created
#  10/10/23 eksc  adapted

# IMPORTANT NOTE! This uses data from the 25th percentile, that is, pan-gene with a
#                 minimum of 25% the number of annotations.
#                 To build a loading table with all pan-genes, use format_loading_table.pl

PREFIX=$1

# From 23_syn_pan_pctl25_posn_cds.fna, extract table of IDs and positions
echo -e "\nExtract IDs and positions..."
grep '>' 23_syn_pan_pctl25_posn_cds.fna | 
  perl -pe 's/^>//; s/ /\t/g; s/^(\w+\.\w+\.([^_]+)_(\d+)_(\w+))/$1\t$2\t$3\t$4/' |
  sort -k4,4 > 23_syn_pan_pctl25_posn.tsv

# Join to table 22_syn_pan_aug_extra_pctl25_posn.hsh.tsv
echo -e "\nJoin to extra..."
join -1 1 -2 4 -a 1 22_syn_pan_aug_extra_pctl25_posn.hsh.tsv 23_syn_pan_pctl25_posn.tsv | 
  perl -pe 's/ /\t/g' |
  awk -v PRE=$PREFIX '{print PRE $0}' > 22_syn_pan_aug_extra_pctl25_posn.hsh.extended.tsv

# Add header
echo -e "panID\ttrans\ttransChr\ttransStart\ttransEnd\ttransStrand\tlongPanID\tpanChr\tignore\tpanStart\tpanEnd\tpanStrand\texemplar" |
cat - 22_syn_pan_aug_extra_pctl25_posn.hsh.extended.tsv > 22_syn_pan_aug_extra_pctl25_posn.hsh.extended.header.tsv
echo -e "\n\nTable to load: 22_syn_pan_aug_extra_pctl25_posn.hsh.extended.header.tsv\n"

