#!/bin/bash

#create Bracken DB
KRAKEN_DB=/shares/CIBIO-Storage/CM/scratch/databases/minikraken2_v1_8GB
THREADS=1
KMER_LEN=35
READ_LEN=100
# /shares/CIBIO-Storage/CM/mir/tools/source_code/Bracken/bracken-build -d ${KRAKEN_DB} -t ${THREADS} -k ${KMER_LEN} -l ${READ_LEN} -x /shares/CIBIO-Storage/CM/mir/tools/kraken2/ 

OUTDIR=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/bracken_output

mkdir -p ${OUTDIR}
sample_path=/shares/CIBIO-Storage/CM/scratch/data/meta/HMP_2012/reads
# SAMPLE_PATH=/shares/CIBIO-Storage/CM/scratch/data/meta/AsnicarF_2017/reads/MV_FEI4_t1Q14/MV_FEI4_t1Q14_R1.fastq.bz2
for sample_name in SRS011271 SRS011529 SRS011239 SRS049900 SRS075404 SRS024075 SRS017007 SRS078182 SRS011115 SRS011084
do
        /usr/bin/time -f "%e" /shares/CIBIO-Storage/CM/mir/tools/kraken2/kraken2 --db ${KRAKEN_DB} \
                                                           --threads ${THREADS} \
                                                           --report ${OUTDIR}/${sample_name}.kreport \
                                                           --paired \
                    ${sample_path}/${sample_name}/${sample_name}_R1.fastq.bz2 ${sample_path}/${sample_name}/${sample_name}_R2.fastq.bz2 > ${OUTDIR}/${sample_name}.kraken
        /usr/bin/time -f "%e" /shares/CIBIO-Storage/CM/mir/tools/source_code/Bracken/bracken -d ${KRAKEN_DB} -i ${OUTDIR}/${sample_name}.kreport -o ${OUTDIR}/${sample_name}.bracken

        (head -n 1 ${OUTDIR}/${sample_name}.bracken && tail -n +2 ${OUTDIR}/${sample_name}.bracken | sort -k7 -t $'\t' -n -r) > ${OUTDIR}/${sample_name}.bracken.sorted
        rm ${OUTDIR}/${sample_name}.bracken
        mv ${OUTDIR}/${sample_name}.bracken.sorted ${OUTDIR}/${sample_name}.bracken
    
done
