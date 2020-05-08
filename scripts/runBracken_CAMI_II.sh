#!/bin/bash

#create Bracken DB
KRAKEN_DB=/shares/CIBIO-Storage/CM/mir/tools/kraken2/kraken2_db
THREADS=16
KMER_LEN=35
READ_LEN=100
# /shares/CIBIO-Storage/CM/mir/tools/source_code/Bracken/bracken-build -d ${KRAKEN_DB} -t ${THREADS} -k ${KMER_LEN} -l ${READ_LEN} -x /shares/CIBIO-Storage/CM/mir/tools/kraken2/ 

OUTDIR=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/CAMI_II

cami2_path=/shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets

for dataset in CAMI_Airways CAMI_Gastrointestinal_tract CAMI_Oral CAMI_Skin CAMI_Urogenital_tract
do
    mkdir -p ${OUTDIR}/${dataset}/bracken_output_208_25/
    for SAMPLE in `ls -d ${cami2_path}/${dataset}/short_read/*sample* | xargs -n1 basename | rev | cut -f1,2 -d '_' | rev`
    do
        SAMPLE_PATH=${cami2_path}/${dataset}/short_read/*${SAMPLE}/reads/anonymous_reads.fq.gz

            /shares/CIBIO-Storage/CM/mir/tools/kraken2/kraken2 \
                    --db ${KRAKEN_DB} \
                    --threads ${THREADS} \
                    --report ${OUTDIR}/${dataset}/bracken_output_208_25/${SAMPLE}.kreport \
                    --output ${OUTDIR}/${dataset}/bracken_output_208_25/${SAMPLE}.kraken \
                    ${SAMPLE_PATH} 

        /shares/CIBIO-Storage/CM/mir/tools/source_code/Bracken/bracken \
                -d ${KRAKEN_DB} \
                -i ${OUTDIR}/${dataset}/bracken_output_208_25/${SAMPLE}.kreport \
                -o ${OUTDIR}/${dataset}/bracken_output_208_25/${SAMPLE}.bracken
       
    done
done 


ds=CAMISIM_MOUSEGUT
mkdir -p ${OUTDIR}/${ds}/bracken_output/
for SAMPLE in `ls -d ${cami2_path}/${ds}/19122017_mousegut_scaffolds/*sample*/ | xargs -n1 basename | rev | cut -f1,2 -d '_' | rev`
do
    SAMPLE_PATH=${cami2_path}/${ds}/19122017_mousegut_scaffolds/*${SAMPLE}/reads/anonymous_reads.fq.gz
    /shares/CIBIO-Storage/CM/mir/tools/kraken2/kraken2 \
                --db ${KRAKEN_DB} \
                --threads ${THREADS} \
                --report ${OUTDIR}/${ds}/bracken_output/${SAMPLE}.kreport \
                ${SAMPLE_PATH} > ${OUTDIR}/${ds}/bracken_output/${SAMPLE}.kraken

    /shares/CIBIO-Storage/CM/mir/tools/source_code/Bracken/bracken \
                -d ${KRAKEN_DB} \
                -i ${OUTDIR}/${ds}/bracken_output/${SAMPLE}.kreport \
                -o ${OUTDIR}/${ds}/bracken_output/${SAMPLE}.bracken

    /shares/CIBIO-Storage/CM/mir/tools/source_code/Bracken/bracken \
                -d ${KRAKEN_DB} \
                -t 10 \
                -i ${OUTDIR}/${ds}/bracken_output/${SAMPLE}.kreport \
                -o ${OUTDIR}/${ds}/bracken_output/${SAMPLE}.t10.bracken
done