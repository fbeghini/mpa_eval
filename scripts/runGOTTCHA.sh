#!/bin/bash
OUTDIR=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/gottcha
DB_DIR=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/gottcha/database

mkdir -p ${OUTDIR}
sample_path=/shares/CIBIO-Storage/CM/scratch/data/meta/HMP_2012/reads
for sample_name in SRS011271 SRS011529 SRS011239 SRS049900 SRS075404 SRS024075 SRS017007 SRS078182 SRS011115 SRS011084
do
	/usr/bin/time -f "%e" gottcha.pl --input ${sample_path}/${sample_name}/${sample_name}_R1.fastq,${sample_path}/${sample_name}/${sample_name}_R2.fastq \
		--outdir ${OUTDIR}/${sample_name}.csv \
		--threads 1 \
		--database ${DB_DIR}/GOTTCHA_BACTERIA_c4937_k24_u30_xHUMAN3x.species
done

