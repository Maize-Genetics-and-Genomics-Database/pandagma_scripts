# pandagma_scripts
A repository for scripts used to prepare files, process results, and for running pandagma on Ceres.

Files include config files, get_data scripts, sbatch scripts for running pandagma on Ceres (or similar server), and all  pre- and post-processing scripts. **These files
need to be copied into the pandagma directory after cloning the Pandagma repository.**

Files in use by current code include the config and batch files.

Obsolete files:
  sbatch\_grass\_family.sh
  
Pandagma is available [here](https://github.com/legumeinfo/pandagma). Information for
installing and running the pipeline can be found in the Pandagma repository README file.

The pan-gene and grass family loading scripts are in the MaizeGDB support\_scripts repository, 
directory PanGenome.

### File preparation
Although the latest Pandagma pipeline no longer includes `get_data\*`, a `get\_data.[pl/sh]` script can still be used to download and prepare files.

_Gene model identifiers_: Must start with a common prefix for the annotation. For MaizeGDB nomenclature, the prefix should be the gene model prefix, e.g. Zm00001eb, followed by a dot. **Note that this breaks the maize nomenclature, rewriting Zm00001eb000010 as Zm00001eb.000010.** 

_Transcript and protein identifiers_: Protein and transcript names must match, **which also breaks the maize nomenclature, rewriting Zm00001eb000010\_P001 as Zm00001eb.000010\_T001.**

_Chromosome names_: Must start with the gene model prefix, followed by a dot, then 'chr', then the chromosome number. E.g.: Zm00001eb.chr1.

_FASTA files_: the deflines should consist of only the transcript/protein identifier, no additional information.

_File names_: Must be prefixed with the gene model prefix, e.g. Zm00001eb.Zm-B73-REFERENCE-NAM-5.0_Zm000001eb.1.cds.fa.


###Gene families###
As gene family analyses rely on datasets from multiple groups, the nomenclature varies greatly, making file preparation a challenge. Each dataset will need to be assigned a prefix, following the format of gene model prefixes in maize. To avoid the possibility of naming conflicts, start the numbering at 99999. For example, Ph99999aa is the prefix for Panicum\_hallii\_590, and Ph99998aa for Ph99998aa.Panicum\_hallii\_591.

