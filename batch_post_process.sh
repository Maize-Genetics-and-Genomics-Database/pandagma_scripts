#!/bin/bash
#SBATCH -A maizegdb                            # user
#SBATCH --job-name="Post processing"           # name of the job submitted
#SBATCH --partition=short                      # name of the queue you are submitting job to
#SBATCH -N 1                                   # number of nodes in this job
#SBATCH -n 39                                  # number of cores/tasks in this job
#SBATCH -t 24:00:00                            # time allocated for this job hours:mins:seconds
#SBATCH --mail-user=<ethy.cannon@usda.gov>     # enter your email address to receive emails
#SBATCH --mail-type=BEGIN,END,FAIL             # will receive an email when job starts, ends or fails

set -o errexit
set -o nounset

SCRIPTS=/project/maizegdb/ethy/pandagma_scripts
PREFIX=pan-zea.v4.

ml miniconda
source activate post-process

#echo "Make the table file"
#perl $SCRIPTS/helpers/format_loading_table.pl $PREFIX data work_pandagma out_pandagma
#echo "Convert v3 identifiers in table file and write file to out_pandagma/${PREFIX}pandagma_load.txt"
#perl $SCRIPTS/helpers/restore_v3_ids.pl $SCRIPTS/data/v3_xref.txt work_pandagma/pandagma_load.txt \
#   > out_pandagma/${PREFIX}pandagma_load.txt
#echo

#echo "Make tandem array file"
#echo "Create and load positions from bed files into sqlite database..."
#perl $SCRIPTS/helpers/make_gm_pos_db.pl data
#echo "Get tandem arrays from sqlite db and out_pandagma/18_syn_pan_aug_extra.table.tsv"
#perl $SCRIPTS/helpers/get_tandems.pl $PREFIX out_pandagma/18_syn_pan_aug_extra.table.tsv  \
#  > work_pandagma/tandems.txt
#echo "Convert v3 identifiers in tandem file and write to out_pandagma/${PREFIX}tandems_load.txt"
#perl $SCRIPTS/helpers/restore_v3_ids.pl -t generic $SCRIPTS/data/v3_xref.txt work_pandagma/tandems.txt \
#   > out_pandagma/${PREFIX}tandems_load.txt
#echo

#echo "Translate CDS alignments and write to 20_aligns_cds_mod with the correct file prefix."
#if [ ! -d work_pandagma/20_aligns_cds_mod ]; then mkdir work_pandagma/20_aligns_cds_mod; fi
#perl $SCRIPTS/helpers/restore_v3_ids.pl -d 'work_pandagma/20_aligns_cds' \
#     -o 'work_pandagma/20_aligns_cds_mod'  -g 'pan.*' -p $PREFIX  \
#     -t FASTA $SCRIPTS/data/v3_xref.txt
#echo "Tar up files."
#cd work_pandagma/20_aligns_cds_mod
#find . -maxdepth 1 -name "${PREFIX}*" -print0 | tar -czf cds_alignments.tar.gz --null -T -
#cd ../..
#echo

#echo "Translate protein alignments and write to 20_aligns_prot_mod with the correct file prefix."
#if [ ! -d work_pandagma/20_aligns_prot_mod ]; then mkdir work_pandagma/20_aligns_prot_mod; fi
#perl $SCRIPTS/helpers/restore_v3_ids.pl -d 'work_pandagma/20_aligns_prot' \
#     -o 'work_pandagma/20_aligns_prot_mod'  -g 'pan.*' -p $PREFIX \
#     -t FASTA $SCRIPTS/data/v3_xref.txt
#echo "Tar up files."
#cd work_pandagma/20_aligns_prot_mod
#find . -maxdepth 1 -name "${PREFIX}*" -print0 | tar -czf prot_alignments.tar.gz --null -T -
#cd ../..
#echo

#echo "Translate trees and write to 24_trees_mod with the correct file prefix."
#if [ ! -d work_pandagma/24_trees_mod ]; then mkdir work_pandagma/24_trees_mod; fi
#perl $SCRIPTS/helpers/restore_v3_ids.pl -d 'work_pandagma/24_trees' \
#     -o 'work_pandagma/24_trees_mod' -g 'pan.*' \
#     -p $PREFIX -t tree $SCRIPTS/data/v3_xref.txt
#echo "Tar up files."
#cd work_pandagma/24_trees_mod
#find . -maxdepth 1 -name "${PREFIX}*" -print0 | tar -czf trees.tar.gz --null -T -
#cd ../..
#echo

#echo "Translate CDS exemplars and write to out_pandagma/${PREFIX}CDS.fa"
#perl $SCRIPTS/helpers/restore_v3_ids.pl -c 2 -p $PREFIX -t FASTA \
#    $SCRIPTS/data/v3_xref.txt \
#    out_pandagma/21_pan_fasta_clust_rep_cds.fna > out_pandagma/${PREFIX}CDS.fa
#gzip out_pandagma/${PREFIX}CDS.fa
#echo
#
#echo "Translate protein exemplars and write to out_pandagma/${PREFIX}protein.fa"
#perl $SCRIPTS/helpers/restore_v3_ids.pl -c 2 -p $PREFIX -t FASTA \
#    $SCRIPTS/data/v3_xref.txt \
#    out_pandagma/21_pan_fasta_clust_rep_prot.faa > out_pandagma/${PREFIX}protein.fa
#gzip out_pandagma/${PREFIX}protein.fa
#echo


echo
echo "Switch to pandagma environment"
conda deactivate
source activate pandagma
echo

#echo "Translate and tar CDS FASTA files"
#cd work_pandagma/19_palmc
#if [ ! -d fixed ]; then mkdir fixed; fi
#perl $SCRIPTS/helpers/restore_v3_ids.pl -d . -o fixed -p $PREFIX -t FASTA \
#      -g 'pan*' $SCRIPTS/data/v3_xref.txt
#cd fixed
#find . -name "${PREFIX}*" -print | tar -czf ${PREFIX}all_CDS.tar.gz --files-from -
#cd ../../
#echo

#echo "Translate and tar protein FASTA files. Translated files will be given the correct prefix."
#cd work_pandagma/19_palmp
#if [ ! -d fixed ]; then mkdir fixed; fi
#perl $SCRIPTS/helpers/restore_v3_ids.pl -d . -o fixed -p $PREFIX -t FASTA \
#      -g 'pan*' $SCRIPTS/data/v3_xref.txt
#cd fixed
#find . -name "${PREFIX}*" -print | tar -czf ${PREFIX}all_proteins.tar.gz --files-from -
#cd ../../
#echo

#echo "Make genomic FASTA files"
#if [ ! -d genomic_sequence ]; then mkdir genomic_sequence; fi
#perl bin/get_fasta_from_family_file.pl data/*.gene.fa.gz  \
#      -family_file out_pandagma/18_syn_pan_aug_extra.clust.gene_mod.tsv \
#      -out_dir genomic_sequence -add_IDs
#cd genomic_sequence
#echo "Translate files and add prefix"
#if [ ! -d fixed ]; then mkdir fixed; fi
#perl $SCRIPTS/helpers/restore_v3_ids.pl -d . -o fixed -p $PREFIX \
#      -t FASTA -g "pan*" $SCRIPTS/data/v3_xref.txt
#echo "Tar up translated files"
#cd fixed
#find . -name "${PREFIX}pan*" -print | tar -czf ${PREFIX}all_gene.tar.gz --files-from -
#chmod 664 $({REFIX}all_gene.tar.gz
#cd ../../
#echo

echo "Translate cluster file and write to ${PREFIX}pan-genes_clust.tsv"
cd out_pandagma
perl $SCRIPTS/helpers/restore_v3_ids.pl -t generic $SCRIPTS/data/v3_xref.txt \
      18_syn_pan_aug_extra.clust.tsv | perl -nle "s/(pan\d+)/${PREFIX}\$1/; print" \
      > ${PREFIX}pan-genes_clust.tsv
gzip ${PREFIX}pan-genes_clust.tsv
echo
         
echo "Translate hash file and write to ${PREFIX}pan-genes_hash.tsv"  
perl $SCRIPTS//helpers/restore_v3_ids.pl -t generic $SCRIPTS/data/v3_xref.txt \
     18_syn_pan_aug_extra.hsh.tsv | perl -nle "s/(pan\d+)/${PREFIX}\$1/; print" \
     > ${PREFIX}pan-genes_hash.tsv
gzip ${PREFIX}pan-genes_hash.tsv
      
echo "Translate table file and write to ${PREFIX}pan-genes_table.tsv"  
perl $SCRIPTS//helpers/restore_v3_ids.pl -t generic $SCRIPTS/data/v3_xref.txt \
     18_syn_pan_aug_extra.table.tsv | perl -nle "s/(pan\d+)/${PREFIX}\$1/; print" \
     > ${PREFIX}pan-genes_table.tsv
gzip ${PREFIX}pan-genes_table.tsv
cd ..

echo
echo "DONE"
echo


