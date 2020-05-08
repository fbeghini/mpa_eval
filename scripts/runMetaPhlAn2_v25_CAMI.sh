#!/bin/bash
sample_path=/shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets/
OUTFOLDER=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/mpa2_output/CAMI_v25
mkdir -p $OUTFOLDER

for sample in CAMI_I_LOW/RL_S001__insert_270.fq.gz \
              CAMI_I_HIGH/RH_S002__insert_270.fq.gz \
              CAMI_I_HIGH/RH_S003__insert_270.fq.gz \
              CAMI_I_HIGH/RH_S004__insert_270.fq.gz \
              CAMI_I_HIGH/RH_S005__insert_270.fq.gz \
              CAMI_I_HIGH/RH_S001__insert_270.fq.gz \
              CAMI_I_MEDIUM/RM1_S001__insert_5000.fq.gz \
              CAMI_I_MEDIUM/RM1_S002__insert_5000.fq.gz \
              CAMI_I_MEDIUM/RM2_S001__insert_270.fq.gz \
              CAMI_I_MEDIUM/RM2_S002__insert_270.fq.gz
do
    sample_name=$(cut -f1 -d '.' <<< `basename $sample`)
    /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py  \
        --input_type fastq \
        --nproc 20 \
        --index latest \
        --bowtie2out ${OUTFOLDER}/${sample_name}.bowtie2 \
        -s ${OUTFOLDER}/${sample_name}.sam \
        --output_file ${OUTFOLDER}/${sample_name}.orig \
        ${sample_path}/${sample} 

done