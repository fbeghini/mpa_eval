#!/bin/bash
sample_path=/shares/CIBIO-Storage/CM/scratch/data/meta/HMP_2012/reads
OUTPATH=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/mpa2_output/HMP_v25
for sample_name in SRS011271 SRS011529 SRS011239 SRS049900 SRS075404 SRS024075 SRS017007 SRS078182 SRS011115 SRS011084
do 
    /usr/bin/time -f "%e" metaphlan2.py  \
        --input_type fastq \
        --nproc 1 \
        --bowtie2out ${OUTPATH}/${sample_name%.*}.bowtie2 \
        -s ${OUTPATH}/${sample_name%.*}.sam \
        --output_file ${OUTPATH}/${sample_name%.*}.orig \
        ${sample_path}/${sample_name}/${sample_name}_R1.fastq.bz2,${sample_path}/${sample_name}/${sample_name}_R2.fastq.bz2,${sample_path}/${sample_name}/${sample_name}_UN.fastq.bz2
done