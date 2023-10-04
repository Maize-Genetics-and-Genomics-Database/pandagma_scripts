#!/bin/bash
#SBATCH --job-name="pandagma"                  # name of the job submitted
#SBATCH --partition=short                      # name of the queue you are submitting job to
#SBATCH -N 1                                   # number of nodes in this job
#SBATCH -n 39                                  # number of cores/tasks in this job
#SBATCH -t 23:00:00                            # time allocated for this job hours:mins:seconds
#SBATCH --mail-user=<ethy.cannon@usda.gov>     # enter your email address to receive emails
#SBATCH --mail-type=BEGIN,END,FAIL             # will receive an email when job starts, ends or fails
#SBATCH -o "stdout.%j.%N"                      # standard out %j adds job number to outputfile
#SBATCH -e "stderr.%j.%N"                      # optional but it prints our standard error

# #SBATCH -p priority -q maizegdb                # name of the queue you are submitting job to
# #SBATCH --mem=350G

# optional; this command prints out timestamp
date

ml singularityCE

set -o errexit -o nounset

PDGPATH=/project/maizegdb/ethy/pandagma
CONFIG=config/pan_zea.conf
IMAGE=../../pandagma-2023-09-19.sif

# The whole deal
SINGULARITY_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec --cleanenv $IMAGE pandagma-pan.sh -c $CONFIG

# One step at a time
#SINGULARITY_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec --cleanenv $IMAGE pandagma-pan.sh -c $CONFIG -s ingest
#SINGULARITY_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec --cleanenv $IMAGE pandagma-pan.sh -c $CONFIG -s mmseqs
#SINGULARITY_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec --cleanenv $IMAGE pandagma-pan.sh -c $CONFIG -s filter
#SINGULARITY_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec --cleanenv $IMAGE pandagma-pan.sh -c $CONFIG -s dagchainer
#SINGULARITY_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec --cleanenv $IMAGE pandagma-pan.sh -c $CONFIG -s mcl
#SINGULARITY_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec --cleanenv $IMAGE pandagma-pan.sh -c $CONFIG -s consense
#SINGULARITY_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec --cleanenv $IMAGE pandagma-pan.sh -c $CONFIG -s cluster_rest
#SINGULARITY_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec --cleanenv $IMAGE pandagma-pan.sh -c $CONFIG -s add_extra
#SINGULARITY_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec --cleanenv $IMAGE pandagma-pan.sh -c $CONFIG -s pick_exemplars
#SINGULARITY_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec --cleanenv $IMAGE pandagma-pan.sh -c $CONFIG -s filter_to_pctile
#SINGULARITY_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec --cleanenv $IMAGE pandagma-pan.sh -c $CONFIG -s order_and_name
#SINGULARITY_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec --cleanenv $IMAGE pandagma-pan.sh -c $CONFIG -s calc_chr_pairs
#SINGULARITY_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec --cleanenv $IMAGE pandagma-pan.sh -c $CONFIG -s summarize
#SINGULARITY_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec --cleanenv $IMAGE pandagma-pan.sh -c $CONFIG -s clean
#SINGULARITY_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec --cleanenv $IMAGE pandagma-pan.sh -c $CONFIG -s ReallyClean

date
