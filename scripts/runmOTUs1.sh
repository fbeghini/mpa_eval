#!/bin/bash
OUTDIR=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/mOTUs1_output

for SAMPLE_PATH in `ls /shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets/CAMI_I_*/*.fq.gz`
do
    SAMPLE=`cut -f10 -d'/' <<< ${SAMPLE_PATH} | cut -f1 -d '.'`
    DATASET=`cut -f1-9 -d'/' <<< ${SAMPLE_PATH}`
    mkdir -p ${OUTDIR}/${SAMPLE}
    cd ${OUTDIR}/${SAMPLE}
    /shares/CIBIO-Storage/CM/mir/tools/mOTUs.pl ${SAMPLE_PATH} --processors 5 --output-directory ${OUTDIR}/SAMPLE 

done
