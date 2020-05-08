#!/bin/bash
OUTDIR=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/mOTUs2_output

mkdir -p ${OUTDIR}
for SAMPLE_PATH in `ls /shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets/CAMI_I_*/*.fq.gz`
do
    SAMPLE=`cut -f10 -d'/' <<< ${SAMPLE_PATH} | cut -f1 -d '.'`
    DATASET=`cut -f1-9 -d'/' <<< ${SAMPLE_PATH}`

    docker run --rm -v ${DATASET}:/data -v ${OUTDIR}:/local-storage quay.io/biocontainers/motus:2.1.1--py37_3 \
    /bin/sh -c "motus profile -s /data/${SAMPLE}.fq.gz -o /local-storage/${SAMPLE}.motus -n ${SAMPLE} -p -u -q -C recall -t 20" &

done
