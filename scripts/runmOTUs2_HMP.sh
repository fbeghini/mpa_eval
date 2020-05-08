#!/bin/bash
OUTDIR=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/mOTUs2_output
DATASET=/shares/CIBIO-Storage/CM/scratch/data/meta/HMP_2012/reads
mkdir -p ${OUTDIR}
for sample_name in SRS011271 SRS011529 SRS011239 SRS049900 SRS075404 SRS024075 SRS017007 SRS078182 SRS011115 SRS011084
do
    /usr/bin/time -f "%e" docker run --rm -v ${DATASET}:/data -v ${OUTDIR}:/local-storage quay.io/biocontainers/motus:2.1.1--py37_3 \
    /bin/sh -c "motus profile -f /data/${sample_name}/${sample_name}_R1.fastq.bz2 -r /data/${sample_name}/${sample_name}_R2.fastq.bz2 -s /data/${sample_name}/${sample_name}_UN.fastq.bz2 -o /local-storage/${sample_name}.motus -n ${sample_name} -p -u -q -t 5" &

done
