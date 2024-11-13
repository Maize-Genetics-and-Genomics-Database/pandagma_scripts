#!/usr/bin/env bash

for filepath in hand_curated_fasta/*; do
  file=$(basename "$filepath");
  echo "  Computing alignment, using program famsa, for file $file"
  famsa -t 2 hand_curated_fasta/"$file" hand_curated_aligns/"$file" 1>/dev/null &
  if [[ $(jobs -r -p | wc -l) -ge $((NPROC/2)) ]]; then wait -n; fi
done

