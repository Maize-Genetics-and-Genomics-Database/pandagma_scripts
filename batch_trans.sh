#!/bin/bash
#SBATCH -A maizegdb                            # user
#SBATCH --job-name="v3 translation"            # name of the job submitted
#SBATCH --partition=short                      # name of the queue you are submitting job to
#SBATCH -N 1                                   # number of nodes in this job
#SBATCH -n 4                                   # number of cores/tasks in this job
#SBATCH -t 12:00:00                            # time allocated for this job hours:mins:seconds
#SBATCH --mail-user=<ethy.cannon@usda.gov>     # enter your email address to receive emails
#SBATCH --mail-type=BEGIN,END,FAIL             # will receive an email when job starts, ends or fails

set -o errexit
set -o nounset
#set -o xtrace

date

echo "Perl:"
which perl

echo "Translate CDS alignments"
perl ../../pandagma_scripts/helpers/restore_v3_ids.pl -d 'work_pandagma/20_aligns_cds' \
     -o 'work_pandagma/20_aligns_cds_mod'  -g 'pan.*' -p 'pan-zea.v4.' \
     -t FASTA ../../pandagma_scripts/data/v3_xref.txt > t1 

echo "Translate protein alignments"
perl ../../pandagma_scripts/helpers/restore_v3_ids.pl -d 'work_pandagma/20_aligns_prot' \
     -o 'work_pandagma/20_aligns_prot_mod'  -g 'pan.*' -p 'pan-zea.v4.' \
     -t FASTA ../../pandagma_scripts/data/v3_xref.txt > t2

date

