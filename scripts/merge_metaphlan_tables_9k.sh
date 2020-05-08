#!/bin/bash

. /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/anaconda3/etc/profile.d/conda.sh
conda activate mpa2
mg_folder=/shares/CIBIO-Storage/CM/mir/data/meta/

for dataset in AsnicarF_2017 BackhedF_2015 BengtssonPalmeJ_2015 BritoIL_2016 Castro-NallarE_2015 ChengpingW_2017 ChngKR_2016 CM_cf CM_periimplantitis CosteaPI_2017 FengQ_2015 \
FerrettiP_2018 \
GeversD_2014 \
HanniganGD_2017 \
HeQ_2017 \
HMP_2012 \
IjazUZ_2017 \
KarlssonFH_2013 \
KosticAD_2015 \
LawrenceA_2015 \
LeChatelierE_2013 \
LiJ_2014 \
LiJ_2017 \
LiSS_2016 \
LiuW_2016 \
LomanNJ_2013 \
LoombaR_2017 \
LouisS_2016 \
NielsenHB_2014 \
Obregon-TitoAJ_2015 \
OhJ_2014 \
OlmMR_2017 \
QinJ_2012 \
QinN_2014 \
RampelliS_2015 \
RaymondF_2016 \
SchirmerM_2016 \
SmitsSA_2017 \
VatanenT_2016 \
VincentC_2016 \
VogtmannE_2016 \
WenC_2017 \
XieH_2016 \
YuJ_2015 \
ZeeviD_2015 \
ZellerG_2014 
do
    merge_metaphlan_tables.py ${mg_folder}/${dataset}/metaphlan29/*/*profile* > ${mg_folder}/${dataset}/metaphlan29/merged_abundance_profiles.tsv
done
