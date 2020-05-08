#!/bin/bash
OUTDIR=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/CAMI_II/
cami2_path=/shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets

for ds in CAMI_Airways CAMI_Gastrointestinal_tract CAMI_Oral CAMI_Skin CAMI_Urogenital_tract
do
    mkdir -p ${OUTDIR}/${ds}/mOTUs2_output
    for SAMPLE in `ls -d ${cami2_path}/${ds}/short_read/*sample* | xargs -n1 basename`
    do
        SAMPLE_PATH="${cami2_path}/${ds}/short_read/${SAMPLE}/reads"
        SAMPLE_NAME=`rev <<< $SAMPLE | cut -f1,2 -d '_' | rev`
        echo $SAMPLE_PATH
        docker run --rm \
        -v ${SAMPLE_PATH}:/data:ro \
        -v ${OUTDIR}/${ds}/mOTUs2_output:/local-storage:rw \
        quay.io/biocontainers/motus:2.1.1--py37_3 \
        /bin/sh -c \
        "motus profile \
        -s /data/anonymous_reads.fq.gz \
        -I /local-storage/${SAMPLE_NAME}.bam \
        -o /local-storage/${SAMPLE_NAME}.recall.motus \
        -n ${SAMPLE_NAME} \
        -p -u -q -C recall -t 12; 
        motus profile \
        -i /local-storage/${SAMPLE_NAME}.bam \
        -o /local-storage/${SAMPLE_NAME}.precision.motus \
        -n ${SAMPLE_NAME} \
        -p -u -q -C precision -t 12;
        motus profile \
        -i /local-storage/${SAMPLE_NAME}.bam \
        -o /local-storage/${SAMPLE_NAME}.parenthesis.motus \
        -n ${SAMPLE_NAME} \
        -p -u -q -C parenthesis -t 12;"
    done
done

ds=CAMISIM_MOUSEGUT
mkdir -p ${OUTDIR}/${ds}/mOTUs2_output

for SAMPLE in `ls -d ${cami2_path}/${ds}/19122017_mousegut_scaffolds/*sample*/ | xargs -n1 basename`
do
    SAMPLE_PATH=${cami2_path}/${ds}/19122017_mousegut_scaffolds/${SAMPLE}/reads
    SAMPLE_NAME=`rev <<< $SAMPLE | cut -f1,2 -d '_' | rev`
    echo $SAMPLE_PATH
    docker run --rm \
    -v ${SAMPLE_PATH}:/data:ro \
    -v ${OUTDIR}/${ds}/mOTUs2_output:/local-storage:rw \
    quay.io/biocontainers/motus:2.1.1--py37_3 \
    /bin/sh -c \
    "motus profile \
    -s /data/anonymous_reads.fq.gz \
    -I /local-storage/${SAMPLE_NAME}.bam \
    -o /local-storage/${SAMPLE_NAME}.motus \
    -n ${SAMPLE_NAME} \
    -p -u -q -C recall -t 12;
    motus profile \
    -i /local-storage/${SAMPLE_NAME}.bam \
    -o /local-storage/${SAMPLE_NAME}.precision.motus \
    -n ${SAMPLE_NAME} \
    -p -u -q -C precision -t 12;
    motus profile \
    -i /local-storage/${SAMPLE_NAME}.bam \
    -o /local-storage/${SAMPLE_NAME}.parenthesis.motus \
    -n ${SAMPLE_NAME} \
    -p -u -q -C parenthesis -t 12;"
done