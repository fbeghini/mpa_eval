#!/bin/bash
sample_path=/shares/CIBIO-Storage/CM/scratch/data/meta/HMP_2012/reads
for sample_name in SRS011271 SRS011529 SRS011239 SRS049900 SRS075404 SRS024075 SRS017007 SRS078182 SRS011115 SRS011084
do 
    /usr/bin/time -f "%e" metaphlan2.py  \
        --input_type fastq \
        --index v20_m200 \
        --nproc 1 \
        --bowtie2out mpa2_output/HMP_v20/${sample_name%.*}.bowtie2 \
        -s mpa2_output/HMP_v20/${sample_name%.*}.sam \
        --output_file mpa2_output/HMP_v20/${sample_name%.*}.orig \
        ${sample_path}/${sample_name}/${sample_name}_R1.fastq.bz2,${sample_path}/${sample_name}/${sample_name}_R2.fastq.bz2,${sample_path}/${sample_name}/${sample_name}_UN.fastq.bz2
done