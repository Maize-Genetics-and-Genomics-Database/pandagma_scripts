# This script retrieves data for a pan-gene calculation, from a remote location (typically https or ftp). 
# Retrieved files are typically nucleotide CDS files and/or protein files, and 
# corresponding annotation files, in GFF3 or BED format.

# Edit this file to identify the base URL for the remote location, and the files to retrieve.

set -o errexit
set -o nounset

if [ ! -d data ]; then mkdir -p data; fi
if [ ! -d data_orig ]; then mkdir -p data_orig; fi
base_dir=$PWD

# Base URL for remote data repository, where annotation files are found
url_base="https://download.maizegdb.org"

cd data_orig

#: << "END"
#### GET CDS FILES ####

curl -O $url_base/Zd-Gigi-REFERENCE-PanAnd-1.0/Zd-Gigi-REFERENCE-PanAnd-1.0_Zd00001aa.1.cds.fa.gz
curl -O $url_base/Zd-Momo-REFERENCE-PanAnd-1.0/Zd-Momo-REFERENCE-PanAnd-1.0_Zd00003aa.1.cds.fa.gz
curl -O $url_base/Zh-RIMHU001-REFERENCE-PanAnd-1.0/Zh-RIMHU001-REFERENCE-PanAnd-1.0_Zh00001aa.1.cds.fa.gz
# No annotation
#curl -O $url_base/Zl-RIL003-REFERENCE-PanAnd-1.0/ .cds.fa.gz
curl -O $url_base/Zl-RIL003-REFERENCE-PanAnd-1.0.
curl -O $url_base/Zm-A188-REFERENCE-KSU-1.0/Zm-A188-REFERENCE-KSU-1.0_Zm00056aa.1.cds.fa.gz
curl -O $url_base/Zm-A632-REFERENCE-CAAS_FIL-1.0/Zm-A632-REFERENCE-CAAS_FIL-1.0_Zm00092aa.1.cds.fa.gz
# NOTE: B73v3 with "fake" ids not in MaizeGDB downloads dir, so loaded by hand 
curl -O $url_base/Zm-B73-REFERENCE-GRAMENE-4.0/Zm-B73-REFERENCE-GRAMENE-4.0_Zm00001d.2.cds.fa.gz
curl -O $url_base/Zm-B73-REFERENCE-NAM-5.0/Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.canonical.cds.fa.gz
curl -O $url_base/Zm-B97-REFERENCE-NAM-1.0/Zm-B97-REFERENCE-NAM-1.0_Zm00018ab.1.canonical.cds.fa.gz
# CIMBL55 v1 gene models were lifted over to v2; although v2 sequence is better, there are errors in the lifted file
#curl -O $url_base/Zm-CIMBL55-REFERENCE-CAU-1.0/Zm-CIMBL55-REFERENCE-CAU-1.0_Zm00067a.1.cds.fa
#curl -O $url_base/Zm-CIMBL55-REFERENCE-CAU-2.0/Zm-CIMBL55-REFERENCE-CAU-2.0_Zm00067a.1.cds.fa.gz
curl -O $url_base/Zm-Chang-7_2-REFERENCE-CAAS_FIL-1.0/Zm-Chang-7_2-REFERENCE-CAAS_FIL-1.0_Zm00093aa.1.cds.fa.gz
curl -O $url_base/Zm-CML103-REFERENCE-NAM-1.0/Zm-CML103-REFERENCE-NAM-1.0_Zm00021ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-CML228-REFERENCE-NAM-1.0/Zm-CML228-REFERENCE-NAM-1.0_Zm00022ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-CML247-REFERENCE-NAM-1.0/Zm-CML247-REFERENCE-NAM-1.0_Zm00023ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-CML277-REFERENCE-NAM-1.0/Zm-CML277-REFERENCE-NAM-1.0_Zm00024ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-CML322-REFERENCE-NAM-1.0/Zm-CML322-REFERENCE-NAM-1.0_Zm00025ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-CML333-REFERENCE-NAM-1.0/Zm-CML333-REFERENCE-NAM-1.0_Zm00026ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-CML52-REFERENCE-NAM-1.0/Zm-CML52-REFERENCE-NAM-1.0_Zm00019ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-CML69-REFERENCE-NAM-1.0/Zm-CML69-REFERENCE-NAM-1.0_Zm00020ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-Dan340-REFERENCE-BAAFS-1.0/Zm-Dan340-REFERENCE-BAAFS-1.0_Zm00104aa.1.cds.fa.gz
curl -O $url_base/Zm-Dan340-REFERENCE-CAAS_FIL-1.0/Zm-Dan340-REFERENCE-CAAS_FIL-1.0_Zm00094aa.1.cds.fa.gz
curl -O $url_base/Zm-DK105-REFERENCE-TUM-1.0/Zm-DK105-REFERENCE-TUM-1.0_Zm00016a.1.cds.fa.gz
curl -O $url_base/Zm-EP1-REFERENCE-TUM-1.0/Zm-EP1-REFERENCE-TUM-1.0_Zm00010a.1.cds.fa.gz
curl -O $url_base/Zm-F7-REFERENCE-TUM-1.0/Zm-F7-REFERENCE-TUM-1.0_Zm00011a.1.cds.fa.gz
curl -O $url_base/Zm-HP301-REFERENCE-NAM-1.0/Zm-HP301-REFERENCE-NAM-1.0_Zm00027ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-Huangzaosi-REFERENCE-CAAS_FIL-1.0/Zm-Huangzaosi-REFERENCE-CAAS_FIL-1.0_Zm00095aa.1.cds.fa.gz
curl -O $url_base/Zm-Ia453-REFERENCE-FL-1.0/Zm-Ia453-REFERENCE-FL-1.0_Zm00045a.1.transcripts.fa.gz	
mv Zm-Ia453-REFERENCE-FL-1.0_Zm00045a.1.transcripts.fa.gz Zm-Ia453-REFERENCE-FL-1.0_Zm00045a.1.cds.fa.gz 
curl -O $url_base/Zm-Il14H-REFERENCE-NAM-1.0/Zm-Il14H-REFERENCE-NAM-1.0_Zm00028ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-Jing92-REFERENCE-CAAS_FIL-1.0/Zm-Jing92-REFERENCE-CAAS_FIL-1.0_Zm00097aa.1.cds.fa.gz
curl -O $url_base/Zm-Jing724-REFERENCE-CAAS_FIL-1.0/Zm-Jing724-REFERENCE-CAAS_FIL-1.0_Zm00096aa.1.cds.fa.gz
curl -O $url_base/Zm-K0326Y-REFERENCE-SIPPE-1.0/Zm-K0326Y-REFERENCE-SIPPE-1.0_Zm00054a.1.cds.fa.gz
curl -O $url_base/Zm-Ki11-REFERENCE-NAM-1.0/Zm-Ki11-REFERENCE-NAM-1.0_Zm00030ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-Ki3-REFERENCE-NAM-1.0/Zm-Ki3-REFERENCE-NAM-1.0_Zm00029ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-Ky21-REFERENCE-NAM-1.0/Zm-Ky21-REFERENCE-NAM-1.0_Zm00031ab.1.canonical.cds.fa.gz
# No protein file
#curl -O $url_base/Zm-LH244-REFERENCE-BAYER-1.0/Zm-LH244-REFERENCE-BAYER-1.0_Zm00052a.1.cds.fa.gz
curl -O $url_base/Zm-M162W-REFERENCE-NAM-1.0/Zm-M162W-REFERENCE-NAM-1.0_Zm00033ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-M37W-REFERENCE-NAM-1.0/Zm-M37W-REFERENCE-NAM-1.0_Zm00032ab.1.canonical.cds.fa.gz
# Replaced by v2
#curl -O $url_base/Zm-Mo17-REFERENCE-CAU-1.0/Zm-Mo17-REFERENCE-CAU-1.0_Zm00014a.1.cds.fa.gz
curl -O $url_base/Zm-Mo17-REFERENCE-CAU-2.0/Zm-Mo17-REFERENCE-CAU-2.0_Zm00014ba.cds.fa.gz
curl -O $url_base/Zm-Mo18W-REFERENCE-NAM-1.0/Zm-Mo18W-REFERENCE-NAM-1.0_Zm00034ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-Ms71-REFERENCE-NAM-1.0/Zm-Ms71-REFERENCE-NAM-1.0_Zm00035ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-NC350-REFERENCE-NAM-1.0/Zm-NC350-REFERENCE-NAM-1.0_Zm00036ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-NC358-REFERENCE-NAM-1.0/Zm-NC358-REFERENCE-NAM-1.0_Zm00037ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-Oh43-REFERENCE-NAM-1.0/Zm-Oh43-REFERENCE-NAM-1.0_Zm00039ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-Oh7B-REFERENCE-NAM-1.0/Zm-Oh7B-REFERENCE-NAM-1.0_Zm00038ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-P39-REFERENCE-NAM-1.0/Zm-P39-REFERENCE-NAM-1.0_Zm00040ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-PE0075-REFERENCE-TUM-1.0/Zm-PE0075-REFERENCE-TUM-1.0_Zm00017a.1.cds.fa.gz
curl -O $url_base/Zm-PH207-REFERENCE_NS-UIUC_UMN-1.0/Zm-PH207-REFERENCE_NS-UIUC_UMN-1.0_Zm00008a.1.cds.fa.gz
curl -O $url_base/Zm-PH207-REFERENCE-CAAS_FIL-1.0/Zm-PH207-REFERENCE-CAAS_FIL-1.0_Zm00099aa.1.cds.fa.gz
curl -O $url_base/Zm-S37-REFERENCE-CAAS_FIL-1.0/Zm-S37-REFERENCE-CAAS_FIL-1.0_Zm00100aa.1.cds.fa.gz
curl -O $url_base/Zm-SK-REFERENCE-YAN-1.0/Zm-SK-REFERENCE-YAN-1.0_Zm00015a.1.cds.fa.gz
curl -O $url_base/Zm-Tx303-REFERENCE-NAM-1.0/Zm-Tx303-REFERENCE-NAM-1.0_Zm00041ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-Tzi8-REFERENCE-NAM-1.0/Zm-Tzi8-REFERENCE-NAM-1.0_Zm00042ab.1.canonical.cds.fa.gz
curl -O $url_base/Zm-W22-REFERENCE-NRGENE-2.0/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1.cds.fa.gz
curl -O $url_base/Zm-SK-REFERENCE-YAN-1.0/Zm-SK-REFERENCE-YAN-1.0_Zm00015a.1.cds.fa.gz
curl -O $url_base/Zm-Xu178-REFERENCE-CAAS_FIL-1.0/Zm-Xu178-REFERENCE-CAAS_FIL-1.0_Zm00101aa.1.cds.fa.gz
curl -O $url_base/Zm-Ye478-REFERENCE-CAAS_FIL-1.0/Zm-Ye478-REFERENCE-CAAS_FIL-1.0_Zm00102aa.1.cds.fa.gz
curl -O $url_base/Zm-Zheng58-REFERENCE-CAAS_FIL-1.0/Zm-Zheng58-REFERENCE-CAAS_FIL-1.0_Zm00103aa.1.cds.fa.gz
curl -O $url_base/Zn-PI615697-REFERENCE-PanAnd-1.0/Zn-PI615697-REFERENCE-PanAnd-1.0_Zn00001aa.1.cds.fa.gz
curl -O $url_base/Zv-TIL01-REFERENCE-PanAnd-1.0/Zv-TIL01-REFERENCE-PanAnd-1.0_Zv00001aa.1.cds.fa.gz
curl -O $url_base/Zv-TIL11-REFERENCE-PanAnd-1.0/Zv-TIL11-REFERENCE-PanAnd-1.0_Zv00002aa.1.cds.fa.gz
#curl -O $url_base/Zx-PI566673-REFERENCE-YAN-1.0/...
curl -O $url_base/Zx-TIL18-REFERENCE-PanAnd-1.0/Zx-TIL18-REFERENCE-PanAnd-1.0_Zx00002aa.1.cds.fa.gz
curl -O $url_base/Zx-TIL25-REFERENCE-PanAnd-1.0/Zx-TIL25-REFERENCE-PanAnd-1.0_Zx00003aa.1.cds.fa.gz


### GET GFF FILES ###

curl -O $url_base/Zd-Gigi-REFERENCE-PanAnd-1.0/Zd-Gigi-REFERENCE-PanAnd-1.0_Zd00001aa.1.gff3.gz
curl -O $url_base/Zd-Momo-REFERENCE-PanAnd-1.0/Zd-Momo-REFERENCE-PanAnd-1.0_Zd00003aa.1.gff3.gz
curl -O $url_base/Zh-RIMHU001-REFERENCE-PanAnd-1.0/Zh-RIMHU001-REFERENCE-PanAnd-1.0_Zh00001aa.1.gff3.gz
# No annotation
#curl -O $url_base/Zl-RIL003-REFERENCE-PanAnd-1.0/ .gff3.gz
curl -O $url_base/Zm-A188-REFERENCE-KSU-1.0/Zm-A188-REFERENCE-KSU-1.0_Zm00056aa.1.gff3.gz
curl -O $url_base/Zm-A632-REFERENCE-CAAS_FIL-1.0/Zm-A632-REFERENCE-CAAS_FIL-1.0_Zm00092aa.1.gff3.gz
#NOTE: B73v3 with "fake" ids not in downloads dir, so loaded by hand 
curl -O $url_base/Zm-B73-REFERENCE-GRAMENE-4.0/Zm-B73-REFERENCE-GRAMENE-4.0_Zm00001d.2.gff3.gz
curl -O $url_base/Zm-B73-REFERENCE-NAM-5.0/Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.gff3.gz
curl -O $url_base/Zm-B97-REFERENCE-NAM-1.0/Zm-B97-REFERENCE-NAM-1.0_Zm00018ab.1.gff3.gz
# CIMBL55 v2 gene models were lifted over. NOTE that gm names don't change between v1 and v2
#curl -O $url_base/Zm-CIMBL55-REFERENCE-CAU-1.0/Zm-CIMBL55-REFERENCE-CAU-1.0_Zm00067a.1.gff3
#curl -O $url_base/Zm-CIMBL55-REFERENCE-CAU-2.0/gene_37493_liftover.gff.gz
#mv gene_37493_liftover.gff.gz Zm-CIMBL55-REFERENCE-CAU-2.0_Zm00067a.1.gff3.gz
curl -O $url_base/Zm-Chang-7_2-REFERENCE-CAAS_FIL-1.0/Zm-Chang-7_2-REFERENCE-CAAS_FIL-1.0_Zm00093aa.1.gff3.gz
curl -O $url_base/Zm-CML103-REFERENCE-NAM-1.0/Zm-CML103-REFERENCE-NAM-1.0_Zm00021ab.1.gff3.gz
curl -O $url_base/Zm-CML228-REFERENCE-NAM-1.0/Zm-CML228-REFERENCE-NAM-1.0_Zm00022ab.1.gff3.gz
curl -O $url_base/Zm-CML247-REFERENCE-NAM-1.0/Zm-CML247-REFERENCE-NAM-1.0_Zm00023ab.1.gff3.gz
curl -O $url_base/Zm-CML277-REFERENCE-NAM-1.0/Zm-CML277-REFERENCE-NAM-1.0_Zm00024ab.1.gff3.gz
curl -O $url_base/Zm-CML322-REFERENCE-NAM-1.0/Zm-CML322-REFERENCE-NAM-1.0_Zm00025ab.1.gff3.gz
curl -O $url_base/Zm-CML333-REFERENCE-NAM-1.0/Zm-CML333-REFERENCE-NAM-1.0_Zm00026ab.1.gff3.gz
curl -O $url_base/Zm-CML52-REFERENCE-NAM-1.0/Zm-CML52-REFERENCE-NAM-1.0_Zm00019ab.1.gff3.gz
curl -O $url_base/Zm-CML69-REFERENCE-NAM-1.0/Zm-CML69-REFERENCE-NAM-1.0_Zm00020ab.1.gff3.gz
curl -O $url_base/Zm-Dan340-REFERENCE-BAAFS-1.0/Zm-Dan340-REFERENCE-BAAFS-1.0_Zm00104aa.1.gff3.gz
curl -O $url_base/Zm-Dan340-REFERENCE-CAAS_FIL-1.0/Zm-Dan340-REFERENCE-CAAS_FIL-1.0_Zm00094aa.1.gff3.gz
curl -O $url_base/Zm-DK105-REFERENCE-TUM-1.0/Zm-DK105-REFERENCE-TUM-1.0_Zm00016a.1.gff3.gz
curl -O $url_base/Zm-EP1-REFERENCE-TUM-1.0/Zm-EP1-REFERENCE-TUM-1.0_Zm00010a.1.gff3.gz
curl -O $url_base/Zm-F7-REFERENCE-TUM-1.0/Zm-F7-REFERENCE-TUM-1.0_Zm00011a.1.gff3.gz
curl -O $url_base/Zm-HP301-REFERENCE-NAM-1.0/Zm-HP301-REFERENCE-NAM-1.0_Zm00027ab.1.gff3.gz
curl -O $url_base/Zm-Huangzaosi-REFERENCE-CAAS_FIL-1.0/Zm-Huangzaosi-REFERENCE-CAAS_FIL-1.0_Zm00095aa.1.gff3.gz
curl -O $url_base/Zm-Ia453-REFERENCE-FL-1.0/Zm-Ia453-REFERENCE-FL-1.0_Zm00045a.1.gff3.gz	
curl -O $url_base/Zm-Il14H-REFERENCE-NAM-1.0/Zm-Il14H-REFERENCE-NAM-1.0_Zm00028ab.1.gff3.gz
curl -O $url_base/Zm-Jing92-REFERENCE-CAAS_FIL-1.0/Zm-Jing92-REFERENCE-CAAS_FIL-1.0_Zm00097aa.1.gff3.gz
curl -O $url_base/Zm-Jing724-REFERENCE-CAAS_FIL-1.0/Zm-Jing724-REFERENCE-CAAS_FIL-1.0_Zm00096aa.1.gff3.gz
curl -O $url_base/Zm-K0326Y-REFERENCE-SIPPE-1.0/Zm-K0326Y-REFERENCE-SIPPE-1.0_Zm00054a.1.gff3.gz
curl -O $url_base/Zm-Ki11-REFERENCE-NAM-1.0/Zm-Ki11-REFERENCE-NAM-1.0_Zm00030ab.1.gff3.gz
curl -O $url_base/Zm-Ki3-REFERENCE-NAM-1.0/Zm-Ki3-REFERENCE-NAM-1.0_Zm00029ab.1.gff3.gz
curl -O $url_base/Zm-Ky21-REFERENCE-NAM-1.0/Zm-Ky21-REFERENCE-NAM-1.0_Zm00031ab.1.gff3.gz
# No protein file
#curl -O $url_base/Zm-LH244-REFERENCE-BAYER-1.0/Zm-LH244-REFERENCE-BAYER-1.0_Zm00052a.1.gff3.gz
curl -O $url_base/Zm-M162W-REFERENCE-NAM-1.0/Zm-M162W-REFERENCE-NAM-1.0_Zm00033ab.1.gff3.gz
curl -O $url_base/Zm-M37W-REFERENCE-NAM-1.0/Zm-M37W-REFERENCE-NAM-1.0_Zm00032ab.1.gff3.gz
# Mo17 v1 replaced by v2
#curl -O $url_base/Zm-Mo17-REFERENCE-CAU-1.0/Zm-Mo17-REFERENCE-CAU-1.0_Zm00014a.1.gff3.gz
curl -O $url_base/Zm-Mo17-REFERENCE-CAU-2.0/Zm-Mo17-REFERENCE-CAU-2.0_Zm00014ba.gff3.gz
curl -O $url_base/Zm-Mo18W-REFERENCE-NAM-1.0/Zm-Mo18W-REFERENCE-NAM-1.0_Zm00034ab.1.gff3.gz
curl -O $url_base/Zm-Ms71-REFERENCE-NAM-1.0/Zm-Ms71-REFERENCE-NAM-1.0_Zm00035ab.1.gff3.gz
curl -O $url_base/Zm-NC350-REFERENCE-NAM-1.0/Zm-NC350-REFERENCE-NAM-1.0_Zm00036ab.1.gff3.gz
curl -O $url_base/Zm-NC358-REFERENCE-NAM-1.0/Zm-NC358-REFERENCE-NAM-1.0_Zm00037ab.1.gff3.gz
curl -O $url_base/Zm-Oh43-REFERENCE-NAM-1.0/Zm-Oh43-REFERENCE-NAM-1.0_Zm00039ab.1.gff3.gz
curl -O $url_base/Zm-Oh7B-REFERENCE-NAM-1.0/Zm-Oh7B-REFERENCE-NAM-1.0_Zm00038ab.1.gff3.gz
curl -O $url_base/Zm-P39-REFERENCE-NAM-1.0/Zm-P39-REFERENCE-NAM-1.0_Zm00040ab.1.gff3.gz
curl -O $url_base/Zm-PE0075-REFERENCE-TUM-1.0/Zm-PE0075-REFERENCE-TUM-1.0_Zm00017a.1.gff3.gz
curl -O $url_base/Zm-PH207-REFERENCE_NS-UIUC_UMN-1.0/Zm-PH207-REFERENCE_NS-UIUC_UMN-1.0_Zm00008a.1.gff3.gz
curl -O $url_base/Zm-PH207-REFERENCE-CAAS_FIL-1.0/Zm-PH207-REFERENCE-CAAS_FIL-1.0_Zm00099aa.1.gff3.gz
curl -O $url_base/Zm-S37-REFERENCE-CAAS_FIL-1.0/Zm-S37-REFERENCE-CAAS_FIL-1.0_Zm00100aa.1.gff3.gz
curl -O $url_base/Zm-SK-REFERENCE-YAN-1.0/Zm-SK-REFERENCE-YAN-1.0_Zm00015a.1.gff3.gz
curl -O $url_base/Zm-Tx303-REFERENCE-NAM-1.0/Zm-Tx303-REFERENCE-NAM-1.0_Zm00041ab.1.gff3.gz
curl -O $url_base/Zm-Tzi8-REFERENCE-NAM-1.0/Zm-Tzi8-REFERENCE-NAM-1.0_Zm00042ab.1.gff3.gz
curl -O $url_base/Zm-W22-REFERENCE-NRGENE-2.0/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1.gff3.gz
curl -O $url_base/Zm-SK-REFERENCE-YAN-1.0/Zm-SK-REFERENCE-YAN-1.0_Zm00015a.1.gff3.gz
curl -O $url_base/Zm-Xu178-REFERENCE-CAAS_FIL-1.0/Zm-Xu178-REFERENCE-CAAS_FIL-1.0_Zm00101aa.1.gff3.gz
curl -O $url_base/Zm-Ye478-REFERENCE-CAAS_FIL-1.0/Zm-Ye478-REFERENCE-CAAS_FIL-1.0_Zm00102aa.1.gff3.gz
curl -O $url_base/Zm-Zheng58-REFERENCE-CAAS_FIL-1.0/Zm-Zheng58-REFERENCE-CAAS_FIL-1.0_Zm00103aa.1.gff3.gz
curl -O $url_base/Zn-PI615697-REFERENCE-PanAnd-1.0/Zn-PI615697-REFERENCE-PanAnd-1.0_Zn00001aa.1.gff3.gz
curl -O $url_base/Zv-TIL01-REFERENCE-PanAnd-1.0/Zv-TIL01-REFERENCE-PanAnd-1.0_Zv00001aa.1.gff3.gz
curl -O $url_base/Zv-TIL11-REFERENCE-PanAnd-1.0/Zv-TIL11-REFERENCE-PanAnd-1.0_Zv00002aa.1.gff3.gz
#curl -O $url_base/Zx-PI566673-REFERENCE-YAN-1.0/...
curl -O $url_base/Zx-TIL18-REFERENCE-PanAnd-1.0/Zx-TIL18-REFERENCE-PanAnd-1.0_Zx00002aa.1.gff3.gz
curl -O $url_base/Zx-TIL25-REFERENCE-PanAnd-1.0/Zx-TIL25-REFERENCE-PanAnd-1.0_Zx00003aa.1.gff3.gz


### GET PROTEIN FILES ###

curl -O $url_base/Zd-Gigi-REFERENCE-PanAnd-1.0/Zd-Gigi-REFERENCE-PanAnd-1.0_Zd00001aa.1.protein.fa.gz
curl -O $url_base/Zd-Momo-REFERENCE-PanAnd-1.0/Zd-Momo-REFERENCE-PanAnd-1.0_Zd00003aa.1.protein.fa.gz
curl -O $url_base/Zh-RIMHU001-REFERENCE-PanAnd-1.0/Zh-RIMHU001-REFERENCE-PanAnd-1.0_Zh00001aa.1.protein.fa.gz
#curl -O $url_base/Zl-RIL003-REFERENCE-PanAnd-1.0/...
curl -O $url_base/Zm-A188-REFERENCE-KSU-1.0/Zm-A188-REFERENCE-KSU-1.0_Zm00056aa.1.protein.fa.gz
curl -O $url_base/Zm-A632-REFERENCE-CAAS_FIL-1.0/Zm-A632-REFERENCE-CAAS_FIL-1.0_Zm00092aa.1.protein.fa.gz
#NOTE: B73v3 with "fake" ids not in downloads dir, so loaded by hand 
curl -O $url_base/Zm-B73-REFERENCE-GRAMENE-4.0/Zm-B73-REFERENCE-GRAMENE-4.0_Zm00001d.2.protein.fa.gz
curl -O $url_base/Zm-B73-REFERENCE-NAM-5.0/Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.protein.fa.gz
curl -O $url_base/Zm-B97-REFERENCE-NAM-1.0/Zm-B97-REFERENCE-NAM-1.0_Zm00018ab.1.protein.fa.gz
# CIMBL55 v2 gene models were lifted over
#curl -O $url_base/Zm-CIMBL55-REFERENCE-CAU-1.0/Zm-CIMBL55-REFERENCE-CAU-1.0_Zm00067a.1.protein.fa
#curl -O $url_base/Zm-CIMBL55-REFERENCE-CAU-2.0/Zm-CIMBL55-REFERENCE-CAU-2.0_Zm00067a.1.protein.fa.gz
curl -O $url_base/Zm-Chang-7_2-REFERENCE-CAAS_FIL-1.0/Zm-Chang-7_2-REFERENCE-CAAS_FIL-1.0_Zm00093aa.1.protein.fa.gz
curl -O $url_base/Zm-CML103-REFERENCE-NAM-1.0/Zm-CML103-REFERENCE-NAM-1.0_Zm00021ab.1.protein.fa.gz
curl -O $url_base/Zm-CML228-REFERENCE-NAM-1.0/Zm-CML228-REFERENCE-NAM-1.0_Zm00022ab.1.protein.fa.gz
curl -O $url_base/Zm-CML247-REFERENCE-NAM-1.0/Zm-CML247-REFERENCE-NAM-1.0_Zm00023ab.1.protein.fa.gz
curl -O $url_base/Zm-CML277-REFERENCE-NAM-1.0/Zm-CML277-REFERENCE-NAM-1.0_Zm00024ab.1.protein.fa.gz
curl -O $url_base/Zm-CML322-REFERENCE-NAM-1.0/Zm-CML322-REFERENCE-NAM-1.0_Zm00025ab.1.protein.fa.gz
curl -O $url_base/Zm-CML333-REFERENCE-NAM-1.0/Zm-CML333-REFERENCE-NAM-1.0_Zm00026ab.1.protein.fa.gz
curl -O $url_base/Zm-CML52-REFERENCE-NAM-1.0/Zm-CML52-REFERENCE-NAM-1.0_Zm00019ab.1.protein.fa.gz
curl -O $url_base/Zm-CML69-REFERENCE-NAM-1.0/Zm-CML69-REFERENCE-NAM-1.0_Zm00020ab.1.protein.fa.gz
curl -O $url_base/Zm-Dan340-REFERENCE-BAAFS-1.0/Zm-Dan340-REFERENCE-BAAFS-1.0_Zm00104aa.1.protein.fa.gz
curl -O $url_base/Zm-Dan340-REFERENCE-CAAS_FIL-1.0/Zm-Dan340-REFERENCE-CAAS_FIL-1.0_Zm00094aa.1.protein.fa.gz
curl -O $url_base/Zm-DK105-REFERENCE-TUM-1.0/Zm-DK105-REFERENCE-TUM-1.0_Zm00016a.1.protein.fa.gz
curl -O $url_base/Zm-EP1-REFERENCE-TUM-1.0/Zm-EP1-REFERENCE-TUM-1.0_Zm00010a.1.protein.fa.gz
curl -O $url_base/Zm-F7-REFERENCE-TUM-1.0/Zm-F7-REFERENCE-TUM-1.0_Zm00011a.1.protein.fa.gz
curl -O $url_base/Zm-HP301-REFERENCE-NAM-1.0/Zm-HP301-REFERENCE-NAM-1.0_Zm00027ab.1.protein.fa.gz
curl -O $url_base/Zm-Huangzaosi-REFERENCE-CAAS_FIL-1.0/Zm-Huangzaosi-REFERENCE-CAAS_FIL-1.0_Zm00095aa.1.protein.fa.gz
curl -O $url_base/Zm-Ia453-REFERENCE-FL-1.0/Zm-Ia453-REFERENCE-FL-1.0_Zm00045a.1.protein.fa.gz
curl -O $url_base/Zm-Il14H-REFERENCE-NAM-1.0/Zm-Il14H-REFERENCE-NAM-1.0_Zm00028ab.1.protein.fa.gz
curl -O $url_base/Zm-Jing92-REFERENCE-CAAS_FIL-1.0/Zm-Jing92-REFERENCE-CAAS_FIL-1.0_Zm00097aa.1.protein.fa.gz
curl -O $url_base/Zm-Jing724-REFERENCE-CAAS_FIL-1.0/Zm-Jing724-REFERENCE-CAAS_FIL-1.0_Zm00096aa.1.protein.fa.gz
curl -O $url_base/Zm-K0326Y-REFERENCE-SIPPE-1.0/Zm-K0326Y-REFERENCE-SIPPE-1.0_Zm00054a.1.protein.fa.gz
curl -O $url_base/Zm-Ki11-REFERENCE-NAM-1.0/Zm-Ki11-REFERENCE-NAM-1.0_Zm00030ab.1.protein.fa.gz
curl -O $url_base/Zm-Ki3-REFERENCE-NAM-1.0/Zm-Ki3-REFERENCE-NAM-1.0_Zm00029ab.1.protein.fa.gz
curl -O $url_base/Zm-Ky21-REFERENCE-NAM-1.0/Zm-Ky21-REFERENCE-NAM-1.0_Zm00031ab.1.protein.fa.gz
# No protein file
#curl -O $url_base/Zm-LH244-REFERENCE-BAYER-1.0/Zm-LH244-REFERENCE-BAYER-1.0_Zm00052a.1.protein.fa.gz
curl -O $url_base/Zm-M162W-REFERENCE-NAM-1.0/Zm-M162W-REFERENCE-NAM-1.0_Zm00033ab.1.protein.fa.gz
curl -O $url_base/Zm-M37W-REFERENCE-NAM-1.0/Zm-M37W-REFERENCE-NAM-1.0_Zm00032ab.1.protein.fa.gz
#curl -O $url_base/Zm-Mo17-REFERENCE-CAU-1.0/Zm-Mo17-REFERENCE-CAU-1.0_Zm00014a.1.protein.fa.gz
curl -O $url_base/Zm-Mo17-REFERENCE-CAU-2.0/Zm-Mo17-REFERENCE-CAU-2.0_Zm00014ba.protein.fa.gz
curl -O $url_base/Zm-Mo18W-REFERENCE-NAM-1.0/Zm-Mo18W-REFERENCE-NAM-1.0_Zm00034ab.1.protein.fa.gz
curl -O $url_base/Zm-Ms71-REFERENCE-NAM-1.0/Zm-Ms71-REFERENCE-NAM-1.0_Zm00035ab.1.protein.fa.gz
curl -O $url_base/Zm-NC350-REFERENCE-NAM-1.0/Zm-NC350-REFERENCE-NAM-1.0_Zm00036ab.1.protein.fa.gz
curl -O $url_base/Zm-NC358-REFERENCE-NAM-1.0/Zm-NC358-REFERENCE-NAM-1.0_Zm00037ab.1.protein.fa.gz
curl -O $url_base/Zm-Oh43-REFERENCE-NAM-1.0/Zm-Oh43-REFERENCE-NAM-1.0_Zm00039ab.1.protein.fa.gz
curl -O $url_base/Zm-Oh7B-REFERENCE-NAM-1.0/Zm-Oh7B-REFERENCE-NAM-1.0_Zm00038ab.1.protein.fa.gz
curl -O $url_base/Zm-P39-REFERENCE-NAM-1.0/Zm-P39-REFERENCE-NAM-1.0_Zm00040ab.1.protein.fa.gz
curl -O $url_base/Zm-PE0075-REFERENCE-TUM-1.0/Zm-PE0075-REFERENCE-TUM-1.0_Zm00017a.1.protein.fa.gz
curl -O $url_base/Zm-PH207-REFERENCE_NS-UIUC_UMN-1.0/Zm-PH207-REFERENCE_NS-UIUC_UMN-1.0_Zm00008a.1.protein.fa.gz
curl -O $url_base/Zm-PH207-REFERENCE-CAAS_FIL-1.0/Zm-PH207-REFERENCE-CAAS_FIL-1.0_Zm00099aa.1.protein.fa.gz
curl -O $url_base/Zm-S37-REFERENCE-CAAS_FIL-1.0/Zm-S37-REFERENCE-CAAS_FIL-1.0_Zm00100aa.1.protein.fa.gz
curl -O $url_base/Zm-SK-REFERENCE-YAN-1.0/Zm-SK-REFERENCE-YAN-1.0_Zm00015a.1.protein.fa.gz
curl -O $url_base/Zm-Tx303-REFERENCE-NAM-1.0/Zm-Tx303-REFERENCE-NAM-1.0_Zm00041ab.1.protein.fa.gz
curl -O $url_base/Zm-Tzi8-REFERENCE-NAM-1.0/Zm-Tzi8-REFERENCE-NAM-1.0_Zm00042ab.1.protein.fa.gz
curl -O $url_base/Zm-W22-REFERENCE-NRGENE-2.0/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1.protein.fa.gz
curl -O $url_base/Zm-SK-REFERENCE-YAN-1.0/Zm-SK-REFERENCE-YAN-1.0_Zm00015a.1.protein.fa.gz
curl -O $url_base/Zm-Xu178-REFERENCE-CAAS_FIL-1.0/Zm-Xu178-REFERENCE-CAAS_FIL-1.0_Zm00101aa.1.protein.fa.gz
curl -O $url_base/Zm-Ye478-REFERENCE-CAAS_FIL-1.0/Zm-Ye478-REFERENCE-CAAS_FIL-1.0_Zm00102aa.1.protein.fa.gz
curl -O $url_base/Zm-Zheng58-REFERENCE-CAAS_FIL-1.0/Zm-Zheng58-REFERENCE-CAAS_FIL-1.0_Zm00103aa.1.protein.fa.gz
curl -O $url_base/Zn-PI615697-REFERENCE-PanAnd-1.0/Zn-PI615697-REFERENCE-PanAnd-1.0_Zn00001aa.1.protein.fa.gz
curl -O $url_base/Zv-TIL01-REFERENCE-PanAnd-1.0/Zv-TIL01-REFERENCE-PanAnd-1.0_Zv00001aa.1.protein.fa.gz
curl -O $url_base/Zv-TIL11-REFERENCE-PanAnd-1.0/Zv-TIL11-REFERENCE-PanAnd-1.0_Zv00002aa.1.protein.fa.gz
#curl -O $url_base/Zx-PI566673-REFERENCE-YAN-1.0/...
curl -O $url_base/Zx-TIL18-REFERENCE-PanAnd-1.0/Zx-TIL18-REFERENCE-PanAnd-1.0_Zx00002aa.1.protein.fa.gz
curl -O $url_base/Zx-TIL25-REFERENCE-PanAnd-1.0/Zx-TIL25-REFERENCE-PanAnd-1.0_Zx00003aa.1.protein.fa.gz

# Do some repairs
zcat Zm-DK105-REFERENCE-TUM-1.0_Zm00016a.1.gff3.gz | awk -v OFS="\t" '{if($3 == "CDS")print $1,$2,$3,$4,$5,$6,$7,$8,"ID="$9":cds;"$9; else print}' | sed -e 's/ID=Parent=/ID=/g' > Zm-DK105-REFERENCE-TUM-1.0_Zm00016a.1.gff3
gzip Zm-DK105-REFERENCE-TUM-1.0_Zm00016a.1.gff3

zcat Zm-EP1-REFERENCE-TUM-1.0_Zm00010a.1.gff3.gz | awk -v OFS="\t" '{if($3 == "CDS")print $1,$2,$3,$4,$5,$6,$7,$8,"ID="$9":cds;"$9; else print}' | sed -e 's/ID=Parent=/ID=/g' > Zm-EP1-REFERENCE-TUM-1.0_Zm00010a.1.gff3
gzip Zm-EP1-REFERENCE-TUM-1.0_Zm00010a.1.gff3

zcat Zm-F7-REFERENCE-TUM-1.0_Zm00011a.1.gff3.gz | awk -v OFS="\t" '{if($3 == "CDS")print $1,$2,$3,$4,$5,$6,$7,$8,"ID="$9":cds;"$9; else print}' | sed -e 's/ID=Parent=/ID=/g' > Zm-F7-REFERENCE-TUM-1.0_Zm00011a.1.gff3
gzip Zm-F7-REFERENCE-TUM-1.0_Zm00011a.1.gff3

zcat Zm-PE0075-REFERENCE-TUM-1.0_Zm00017a.1.gff3.gz | awk -v OFS="\t" '{if($3 == "CDS")print $1,$2,$3,$4,$5,$6,$7,$8,"ID="$9":cds;"$9; else print}' | sed -e 's/ID=Parent=/ID=/g' > Zm-PE0075-REFERENCE-TUM-1.0_Zm00017a.1.gff3
gzip Zm-PE0075-REFERENCE-TUM-1.0_Zm00017a.1.gff3

zcat Zm-SK-REFERENCE-YAN-1.0_Zm00015a.1.gff3.gz | awk -v OFS="\t" '{if($3 == "CDS")print $1,$2,$3,$4,$5,$6,$7,$8,"ID="$9":cds;"$9; else print}' | sed -e 's/ID=Parent=/ID=/g' > Zm-SK-REFERENCE-YAN-1.0_Zm00015a.1.gff3
gzip Zm-SK-REFERENCE-YAN-1.0_Zm00015a.1.gff3

# Get rid of organelle gene models from B73v4
zcat Zm-B73-REFERENCE-GRAMENE-4.0_Zm00001d.2.gff3.gz |
awk '{if(!($1~/Pt/||$1~/Mt/)){print}}' > Zm-B73-REFERENCE-GRAMENE-4.0_Zm00001d.2.gff3
rm Zm-B73-REFERENCE-GRAMENE-4.0_Zm00001d.2.gff3.gz
gzip Zm-B73-REFERENCE-GRAMENE-4.0_Zm00001d.2.gff3

zcat Zm-B73-REFERENCE-GRAMENE-4.0_Zm00001d.2.cds.fa.gz | perl -nle 'if(!(/provisional/)){print}' |
awk '{print $1}' | ../bin/fasta_to_table.awk | awk '{if(!($1~/GRMZM/)){print}}' |
awk -v FS="\t" '{print ">" $1; print $2}' > Zm-B73-REFERENCE-GRAMENE-4.0_Zm00001d.2.cds.fa
rm Zm-B73-REFERENCE-GRAMENE-4.0_Zm00001d.2.cds.fa.gz
gzip Zm-B73-REFERENCE-GRAMENE-4.0_Zm00001d.2.cds.fa

zcat Zm-B73-REFERENCE-GRAMENE-4.0_Zm00001d.2.protein.fa.gz | perl -nle 'if(!(/provisional/)){print}' |
awk '{print $1}' | ../bin/fasta_to_table.awk | awk '{if(!($1~/GRMZM/)){print}}' |
awk -v FS="\t" '{print ">" $1; print $2}' > Zm-B73-REFERENCE-GRAMENE-4.0_Zm00001d.2.protein.fa
rm Zm-B73-REFERENCE-GRAMENE-4.0_Zm00001d.2.protein.fa.gz
gzip Zm-B73-REFERENCE-GRAMENE-4.0_Zm00001d.2.protein.fa
#END


### EXTRACT LONGEST AS CANONICAL WHERE NEEDED ###
echo
echo "Make canonical CDS files if missing"
for file in *.cds.fa.gz; do
  if [[ "$file" != *canonical.cds.fa.gz ]]; then
    base=`basename $file .cds.fa.gz`
    echo "Write" $file "to" $base".canonical.cds.fa"
    zcat $file | ../bin/fasta_to_table.awk |
      perl -pe 's/_T(\d+) ?/\tT$1\t/' |
      awk -v FS="\t" -v OFS="\t" '$0!~/provisional/ {print $1, length($4), $2, $3, $4}' |
      sort -k1,1 -k2nr,2nr |
      ../bin/top_line.awk | awk -v FS="\t" '{print ">" $1 "_" $3 " " $4; print $5}' |
      cat > ../data/$base.canonical.cds.fa
  fi
done
#END


### COPY CANONICAL FILES ###
echo
echo "Copy existing canonical files from data_orig/ to data/"
for file in *canonical.cds.fa.gz; do 
  gunzip $file &
done
wait
cp *canonical.cds.fa ../data/
#END


### FIX AND COPY PROTEIN FILES ###
# Protein ids must match CDS ids
echo
echo "Fix then copy protein files"
for file in *protein.fa.gz; do
  gunzip $file &
done
wait
perl -i -pe 's/_P(\d+)/_T$1/' *protein.fa  # -i = edit in place
for file in *protein.fa; do
  gzip $file &
done
wait

cp *protein.fa.gz ../data/


### MAKE BED FILES ###
echo
echo "Derive BED from GFF. "
echo "Add annotation name (e.g. Zm-W22_NRGENE-2) as prefix to the chromosome/scaffold names."
for path in *gff3.gz; do
  base=`basename $path .gz`
  echo $base
  export annot_name=$(echo $base | perl -pe 's/(.+)-REFERENCE[-_](.+\d)\.\d_Z\w\d+.+/$1_$2/')
  zcat $path | ../bin/gff_to_bed7_mRNA.awk | 
    perl -pe '$prefix=$ENV{'annot_name'}; s/^(\D+)/$prefix.$1/; s/transcript://' |
    cat > ../data/$base.bed &
done
wait


echo
echo "Change chromosome strings in Zm-B73-REFERENCE-GRAMENE-4.0"
perl -pi -e 's/Chr/chr/' ../data/Zm-B73-REFERENCE-GRAMENE-4.0_Zm00001d.2.gff3.bed


### ZIP FILES ###
echo
echo "Re-compress files"
for file in *.fa *.gff3; do
  gzip $file &
done
wait

for file in ../data/*fa ../data/*bed; do
  gzip $file &
done
wait


### CHECK CHROMOSOME NAMES ###
echo
echo "Check chromosome IDs"
for file in ../data/*bed.gz; do 
  echo $file; zcat $file | cut -f1 | awk '$1!~/ctg|scaf|Scaf|unk|Unk|UNK|pt|Pt|Mt|mt|Unplaced|unplaced/' | sort | uniq -c; echo; 
done

### EXPECTED CHROMOSOME MATCHES ###
cat << 'DATA' > ../data/expected_chr_matches.tsv
# Expected chromosome matches for Zea
1 1
2 2
3 3
4 4
5 5
6 6
7 7
8 8
9 9
9 10
10 10
DATA

cd $base_dir



