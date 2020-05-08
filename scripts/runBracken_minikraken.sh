#!/bin/bash
#create Bracken DB
KRAKEN_DB=/shares/CIBIO-Storage/CM/scratch/databases/minikraken2_v1_8GB
THREADS=10
KMER_LEN=35
READ_LEN=100
# /shares/CIBIO-Storage/CM/mir/tools/source_code/Bracken/bracken-build -d ${KRAKEN_DB} -t ${THREADS} -k ${KMER_LEN} -l ${READ_LEN} -x /shares/CIBIO-Storage/CM/mir/tools/kraken2/ 

OUTDIR=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/bracken_output_minikraken

ds_folder=/shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets
for dataset in CAMI_I_HIGH CAMI_I_MEDIUM CAMI_I_LOW
do
    mkdir -p ${OUTDIR}/${dataset}
    for SAMPLE_PATH in `ls ${ds_folder}/${dataset}/*.fq.gz`
    do
        SAMPLE=`cut -f10 -d'/' <<< ${SAMPLE_PATH} | cut -f1 -d '.'`

        /shares/CIBIO-Storage/CM/mir/tools/kraken2/kraken2 \
                    --db ${KRAKEN_DB} \
                    --threads ${THREADS} \
                    --report ${OUTDIR}/${dataset}/${SAMPLE}.kreport \
                    ${SAMPLE_PATH} > ${OUTDIR}/${dataset}/${SAMPLE}.kraken

        /shares/CIBIO-Storage/CM/mir/tools/source_code/Bracken/bracken \
                    -d ${KRAKEN_DB} \
                    -i ${OUTDIR}/${dataset}/${SAMPLE}.kreport \
                    -o ${OUTDIR}/${dataset}/${SAMPLE}.bracken
    done 
done