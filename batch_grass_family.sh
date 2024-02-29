#!/bin/bash
#SBATCH --time=23:50:0
#SBATCH --job-name="panfam"
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

date   # print timestamp

ml miniconda
source activate pandagma

PDGPATH=$PWD
CONFIG=config/grass_family.conf

export PATH=$PATH:$PDGPATH:$PDGPATH/bin

echo "PATH: $PATH"
echo "Config: $CONFIG"

# Test path
which pandagma
which calc_ks_from_dag.pl
 
# Run first
pandagma fam -c $CONFIG -s ingest -d data
pandagma fam -c $CONFIG -s mmseqs
pandagma fam -c $CONFIG -s filter
pandagma fam -c $CONFIG -s dagchainer
pandagma fam -c $CONFIG -s ks_calc

# Run second, after assessing data/ks_peaks.tsv and copying to data/
#pandagma fam -c $CONFIG -s ks_filter
#pandagma fam -c $CONFIG -s mcl
#pandagma fam -c $CONFIG -s consense
#pandagma fam -c $CONFIG -s cluster_rest
#pandagma fam -c $CONFIG -s add_extra    # need this even if no extras
#pandagma fam -c $CONFIG -s align
#pandagma fam -c $CONFIG -s model_and_trim
#pandagma fam -c $CONFIG -s calc_trees
#pandagma fam -c $CONFIG -s summarize
 
date   # print timestamp

