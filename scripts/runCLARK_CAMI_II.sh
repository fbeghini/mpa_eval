#!/bin/bash
DB_DIR=/shares/CIBIO-Storage/CM/mir/tools/CLARKSCV1.2.5.1/DIR_DB

cami2_path=/shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets/

for ds in CAMI_Airways CAMI_Gastrointestinal_tract CAMI_Oral CAMI_Skin CAMI_Urogenital_tract
do
    echo $ds
    OUTPATH=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/CAMI_II/${ds}/CLARK/
    mkdir -p ${OUTPATH}
    for s in `ls -d ${cami2_path}/${ds}/short_read/*sample* | xargs -n1 basename | rev | cut -f1,2 -d '_' | rev`
    do
	/shares/CIBIO-Storage/CM/mir/tools/CLARKSCV1.2.5.1/classify_metagenome.sh \
                                    --gzipped \
									-O ${cami2_path}/${ds}/short_read/*${s}/reads/anonymous_reads.fq.gz \
									-R ${OUTPATH}/${s} \
									-n 10

	/shares/CIBIO-Storage/CM/mir/tools/CLARKSCV1.2.5.1/estimate_abundance.sh -F ${OUTPATH}/${s}.csv -D $DB_DIR > ${OUTPATH}/${s}.clarkres
    done
done



cami2_path_mouse=/shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets/CAMISIM_MOUSEGUT/19122017_mousegut_scaffolds/
OUTPATH=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/CAMI_II/CAMISIM_MOUSEGUT/CLARK/
mkdir -p ${OUTPATH}
for s in `ls -d ${cami2_path_mouse}/*sample*/ | xargs -n1 basename | rev | cut -f1,2 -d '_' | rev`
do
	COUNTER=0
	/shares/CIBIO-Storage/CM/mir/tools/CLARKSCV1.2.5.1/classify_metagenome.sh \
                                    --gzipped \
									-O ${cami2_path_mouse}/*${s}/reads/anonymous_reads.fq.gz \
									-R ${OUTPATH}/${s} \
									-n 10 && /shares/CIBIO-Storage/CM/mir/tools/CLARKSCV1.2.5.1/estimate_abundance.sh -F ${OUTPATH}/${s}.csv -D $DB_DIR > ${OUTPATH}/${s}.clarkres &
	COUNTER=$((COUNTER+1))
done
