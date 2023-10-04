#!/bin/bash
#SBATCH --time=23:50:0
#SBATCH --job-name="pandagma-fam"
#SBATCH --mail-user=<ethy.cannon@usda.gov> # email address
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --qos=maizegdb             # cigru-mem: priority access to cpu=80,mem=1530G
#SBATCH --partition=priority
#SBATCH --error="stderr.%j.%N"     # job standard error file (%j will be replaced by job id)
#SBATCH --nodes=1                  # number of nodes
#SBATCH --ntasks=20                # keep this smallish to avoid memory overrun


# # SBATCH --qos=maizegdb             # cigru-mem: priority access to cpu=80,mem=1530G
# # SBATCH --qos=cigru-mem            # priority access to cpu=80,mem=1530G
# # SBATCH --time=23:0

set -o errexit nounset xtrace

PDGPATH=/project/maizegdb/ethy/grass-fam/pandagma
CONFIG=config/grass_family.conf
IMAGE=/project/maizegdb/ethy/pandagma-2023-09-19.sif

date   # print timestamp

ml singularityCE

# Test path
# SINGULARITYENV_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec --cleanenv $IMAGE which pandagma-fam.sh
# SINGULARITYENV_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec --cleanenv $IMAGE which calc_ks_from_dag.pl
 
# Run first
#SINGULARITYENV_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec $IMAGE pandagma-fam.sh -c $CONFIG -s ingest
SINGULARITYENV_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec $IMAGE pandagma-fam.sh -c $CONFIG -s mmseqs
SINGULARITYENV_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec $IMAGE pandagma-fam.sh -c $CONFIG -s filter
SINGULARITYENV_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec $IMAGE pandagma-fam.sh -c $CONFIG -s dagchainer
SINGULARITYENV_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec $IMAGE pandagma-fam.sh -c $CONFIG -s ks_calc
 
# Run second, after preparing data/ks_peaks.tsv
#SINGULARITYENV_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec $IMAGE pandagma-fam.sh -c $CONFIG -s ks_filter
#SINGULARITYENV_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec $IMAGE pandagma-fam.sh -c $CONFIG -s mcl
#SINGULARITYENV_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec $IMAGE pandagma-fam.sh -c $CONFIG -s consense
#SINGULARITYENV_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec $IMAGE pandagma-fam.sh -c $CONFIG -s cluster_rest
#SINGULARITYENV_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec $IMAGE pandagma-fam.sh -c $CONFIG -s add_extra
#SINGULARITYENV_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec $IMAGE pandagma-fam.sh -c $CONFIG -s align
#SINGULARITYENV_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec $IMAGE pandagma-fam.sh -c $CONFIG -s model_and_trim
#SINGULARITYENV_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec $IMAGE pandagma-fam.sh -c $CONFIG -s calc_trees
#SINGULARITYENV_PREPEND_PATH=$PDGPATH:$PDGPATH/bin singularity exec $IMAGE pandagma-fam.sh -c $CONFIG -s summarize
 
date   # print timestamp

