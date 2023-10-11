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
# NOTE: Run this script from within the pandagma output file
#
# History:
#  10/01/23  sbc  created
#  10/10/23 eksc  adapted

# From 23_syn_pan_pctl25_posn_cds.fna, extract table of IDs and positions
grep '>' 23_syn_pan_pctl25_posn_cds.fna | 
  perl -pe 's/^>//; s/ /\t/g; s/^(\w+\.\w+\.([^_]+)_(\d+)_(\w+))/$1\t$2\t$3\t$4/' |
  sort -k4,4 > 23_syn_pan_pctl25_posn.tsv

# Join to table 22_syn_pan_aug_extra_pctl25_posn.hsh.tsv
join -1 1 -2 4 -a 1 22_syn_pan_aug_extra_pctl25_posn.hsh.tsv 23_syn_pan_pctl25_posn.tsv | 
  perl -pe 's/ /\t/g' > 22_syn_pan_aug_extra_pctl25_posn.hsh.extended.tsv
 
echo
echo "Table to load: 22_syn_pan_aug_extra_pctl25_posn.hsh.extended.tsv"
echo
