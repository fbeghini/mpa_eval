#!/bin/bash
wd=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval

python3 -c 'from convertMetaphlan2 import convertBracken; from sys import argv; convertBracken(argv[1:])' `ls ${wd}/CAMI_I/bracken_output/*/*.bracken`
python3 -c 'from convertMetaphlan2 import convertBracken; from sys import argv; convertBracken(argv[1:])' `ls ${wd}/CAMI_I/bracken_output_minikraken/*/*.bracken`

for dataset in `ls -d ${wd}/CAMI_I/bracken_output/*`
do
    cat ${dataset}/*.profile > ${dataset}/Bracken_refseq
done

for dataset in `ls -d ${wd}/CAMI_I/bracken_output_minikraken/*`
do
    cat ${dataset}/*.profile > ${dataset}/Bracken_minikraken
done

docker run --rm \
           -v /shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets:/CAMI_datasets \
           -v /shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval:/fbeghini_CAMIEval opal:latest \
opal.py -g /CAMI_datasets/CAMI_I_LOW/goldstandard_low_1.profile \
    /fbeghini_CAMIEval/opal_CAMI_out/low/CLARK \
    /fbeghini_CAMIEval/opal_CAMI_out/low/FOCUS \
    /fbeghini_CAMIEval/opal_CAMI_out/low/MetaPhlAn2.0 \
    /fbeghini_CAMIEval/opal_CAMI_out/low/MetaPhyler \
    /fbeghini_CAMIEval/opal_CAMI_out/low/mOTU \
    /fbeghini_CAMIEval/opal_CAMI_out/low/Quikr \
    /fbeghini_CAMIEval/opal_CAMI_out/low/TIPP \
    /fbeghini_CAMIEval/mpa2_output/CAMI_v25/low/MPA25 \
    /fbeghini_CAMIEval/mpa2_output/CAMI_v25_201901/low/MPA25_201901 \
    /fbeghini_CAMIEval/CAMI_I/bracken_output/CAMI_I_LOW/Bracken_refseq \
    /fbeghini_CAMIEval/CAMI_I/bracken_output_minikraken/CAMI_I_LOW/Bracken_minikraken \
    /fbeghini_CAMIEval/mOTUs2_output/low/motus2 \
    -o /fbeghini_CAMIEval/opal_out/low

docker run --rm \
           -v /shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets:/CAMI_datasets \
           -v /shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval:/fbeghini_CAMIEval opal:latest \
opal.py -g /CAMI_datasets/CAMI_I_MEDIUM/goldstandard_medium.profile \
    /fbeghini_CAMIEval/opal_CAMI_out/medium/CLARK \
    /fbeghini_CAMIEval/opal_CAMI_out/medium/FOCUS \
    /fbeghini_CAMIEval/opal_CAMI_out/medium/MetaPhlAn2.0 \
    /fbeghini_CAMIEval/opal_CAMI_out/medium/MetaPhyler \
    /fbeghini_CAMIEval/opal_CAMI_out/medium/mOTU \
    /fbeghini_CAMIEval/opal_CAMI_out/medium/Quikr \
    /fbeghini_CAMIEval/opal_CAMI_out/medium/TIPP \
    /fbeghini_CAMIEval/mpa2_output/CAMI_v25/medium/MPA25 \
    /fbeghini_CAMIEval/mpa2_output/CAMI_v25_201901/medium/MPA25_201901 \
    /fbeghini_CAMIEval/CAMI_I/bracken_output/CAMI_I_MEDIUM/Bracken_refseq \
    /fbeghini_CAMIEval/CAMI_I/bracken_output_minikraken/CAMI_I_MEDIUM/Bracken_minikraken \
    /fbeghini_CAMIEval/mOTUs2_output/medium/motus2 \
    -o /fbeghini_CAMIEval/opal_out/medium

docker run --rm \
           -v /shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets:/CAMI_datasets \
           -v /shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval:/fbeghini_CAMIEval opal:latest \
opal.py \
    -g /CAMI_datasets/CAMI_I_HIGH/goldstandard_high.profile \
    /fbeghini_CAMIEval/opal_CAMI_out/high/CLARK \
    /fbeghini_CAMIEval/opal_CAMI_out/high/FOCUS \
    /fbeghini_CAMIEval/opal_CAMI_out/high/MetaPhlAn2.0 \
    /fbeghini_CAMIEval/opal_CAMI_out/high/MetaPhyler \
    /fbeghini_CAMIEval/opal_CAMI_out/high/mOTU \
    /fbeghini_CAMIEval/opal_CAMI_out/high/Quikr \
    /fbeghini_CAMIEval/opal_CAMI_out/high/TIPP \
    /fbeghini_CAMIEval/mpa2_output/CAMI_v25/high/MPA25 \
    /fbeghini_CAMIEval/mpa2_output/CAMI_v25_201901/high/MPA25_201901 \
    /fbeghini_CAMIEval/CAMI_I/bracken_output/CAMI_I_HIGH/Bracken_refseq \
    /fbeghini_CAMIEval/CAMI_I/bracken_output_minikraken/CAMI_I_HIGH/Bracken_minikraken \
    /fbeghini_CAMIEval/mOTUs2_output/high/motus2 \
    -o /fbeghini_CAMIEval/opal_out/high