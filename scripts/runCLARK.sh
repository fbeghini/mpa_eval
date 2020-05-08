#!/bin/bash
OUTDIR=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/CLARK_output
DB_DIR=/shares/CIBIO-Storage/CM/mir/tools/CLARKSCV1.2.5.1/DIR_DB

# /shares/CIBIO-Storage/CM/mir/tools/CLARKSCV1.2.5.1/set_targets.sh ${DB_DIR} bacteria fungi
# /shares/CIBIO-Storage/CM/mir/tools/CLARKSCV1.2.5.1/set_targets.sh ${DB_DIR} bacteria --species

mkdir -p ${OUTDIR}
sample_path=/shares/CIBIO-Storage/CM/scratch/data/meta/HMP_2012/reads
for sample_name in SRS011271 SRS011529 SRS011239 SRS049900 SRS075404 SRS024075 SRS017007 SRS078182 SRS011115 SRS011084
do
	bzcat ${sample_path}/${sample_name}/${sample_name}_R1.fastq.bz2 > ${sample_path}/${sample_name}/${sample_name}_R1.fastq &
	bzcat ${sample_path}/${sample_name}/${sample_name}_R2.fastq.bz2 > ${sample_path}/${sample_name}/${sample_name}_R2.fastq &
	wait
	echo $sample_name " classify_metagenome" 
	/usr/bin/time -f "%e" /shares/CIBIO-Storage/CM/mir/tools/CLARKSCV1.2.5.1/classify_metagenome.sh \
									-P ${sample_path}/${sample_name}/${sample_name}_R1.fastq ${sample_path}/${sample_name}/${sample_name}_R2.fastq \
									-R ${OUTDIR}/${sample_name} \
									-n 1
	echo $sample_name " estinamte_abundance"
	/usr/bin/time -f "%e" /shares/CIBIO-Storage/CM/mir/tools/CLARKSCV1.2.5.1/estimate_abundance.sh -F ${OUTDIR}/${sample_name}.csv -D $DB_DIR > ${OUTDIR}/${sample_name}.clarkres

    (head -n 1 ${OUTDIR}/${sample_name}.clarkres && tail -n +2 ${OUTDIR}/${sample_name}.clarkres | sort -k6 -t ',' -g -r) > ${OUTDIR}/${sample_name}.clarkres.sorted

    rm ${OUTDIR}/${sample_name}.clarkres
    mv ${OUTDIR}/${sample_name}.clarkres.sorted ${OUTDIR}/${sample_name}.clarkres

done

