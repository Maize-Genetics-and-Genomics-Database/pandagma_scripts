# file: run_pan_trees.sh
#
# This script permits running trees for pan-genes.
# It is NOT part of the pandagma reposistory, but must be executed from within
# the Pandagma bin/ directory.
#
# If restarting the script, set $start to the number of last tree calculated.
#
# These commands are required before executing:
#    salloc -N 1 -n 36 -t 4:00:00 -p short    # adjust time as needed
#    ml miniconda
#    source activate pandagma
#    . config/pan_zea.conf
#    cd work_pandagma

export OMP_NUM_THREADS=1
export NPROC=$( ( command -v nproc > /dev/null && nproc ) || getconf _NPROCESSORS_ONLN)
export dir_prefix=2
export start='06112'
for filepath in "${dir_prefix}3_hmmalign_trim2"/*; do
  file=$(basename "$filepath")
  num=$(echo "$file" | sed 's/pan//')
  if [[ $num > $start ]]; then
    echo "  Calculating tree for $file"
    echo "fasttree -quiet $filepath > ${dir_prefix}4_trees/$file"
    fasttree -quiet "$filepath" > "${dir_prefix}4_trees/$file" &
    # allow to execute up to $NPROC concurrent asynchronous processes
    if [[ $(jobs -r -p | wc -l) -ge ${NPROC} ]]; then wait -n; fi
  fi
done
