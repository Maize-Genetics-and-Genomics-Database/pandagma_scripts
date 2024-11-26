#!/bin/bash
#SBATCH --job-name="pandagma-pan_zea"          # name of the job submitted
#SBATCH --partition=short                      # name of the queue you are submitting job to
#SBATCH -N 1                                   # number of nodes in this job
#SBATCH -n 39                                  # number of cores/tasks in this job
#SBATCH -t 24:00:00                            # time allocated for this job hours:mins:seconds
#SBATCH --mail-user=<ethy.cannon@usda.gov>     # enter your email address to receive emails
#SBATCH --mail-type=BEGIN,END,FAIL             # will receive an email when job starts, ends or fails
# #SBATCH -o "stdout.%j.%N"                      # standard out %j adds job number to outputfile
# #SBATCH -e "stderr.%j.%N"                      # optional but it prints our standard error

# #SBATCH -p priority -q maizegdb                # name of the queue you are submitting job to
# #SBATCH --mem=350G

# optional; this command prints out timestamp
date

set -o errexit
set -o nounset
set -o xtrace

date   # print timestamp

# If using conda environment for dependencies:
ml miniconda
source activate pandagma

PDGPATH=/project/maizegdb/ethy/pan-zea/pandagma
CONFIG=$PDGPATH/config/pan_zea.conf

echo "Config: $CONFIG"

export PATH=$PATH:$PDGPATH:$PDGPATH/bin
echo "PATH: $PATH"

#HERE='/project/maizegdb/ethy/pan-zea/pandagma'

##########
# Test PATH
which pandagma-pan.sh  # instead, give full path with $HERE
which calc_ks_from_dag.pl

##########
## Run all main steps (Uncomment to run all steps, comment to run steps individually)
##pandagma-pan.sh -c $CONFIG


# One step at a time
pandagma-pan.sh -c $CONFIG -s ingest
pandagma-pan.sh -c $CONFIG -s mmseqs
pandagma-pan.sh -c $CONFIG -s filter
pandagma-pan.sh -c $CONFIG -s dagchainer
pandagma-pan.sh -c $CONFIG -s mcl
pandagma-pan.sh -c $CONFIG -s consense
pandagma-pan.sh -c $CONFIG -s cluster_rest
pandagma-pan.sh -c $CONFIG -s add_extra
pandagma-pan.sh -c $CONFIG -s pick_exemplars
pandagma-pan.sh -c $CONFIG -s tabularize
pandagma-pan.sh -c $CONFIG -s filter_to_pctile
pandagma-pan.sh -c $CONFIG -s order_and_name
pandagma-pan.sh -c $CONFIG -s calc_chr_pairs
pandagma-pan.sh -c $CONFIG -s summarize

##########
# Optional alignment and tree-construction steps
#pandagma-pan -c $CONFIG -s align_cds
#pandagma-pan -c $CONFIG -s align_protein
#pandagma pan -c $CONFIG -s model_and_trim
#pandagma pan -c $CONFIG -s calc_trees
#pandagma pan -c $CONFIG -s xfr_aligns_trees

##########
## Optional work-directory cleanup steps
#pandagma-pan.sh -c $CONFIG -s clean
#pandagma-pan.sh -c $CONFIG -s ReallyClean

date
