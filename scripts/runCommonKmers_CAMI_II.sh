#!/bin/bash
DB_DIR=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/gottcha/database

cami2_path=/shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets/

for ds in CAMI_Airways CAMI_Gastrointestinal_tract CAMI_Oral CAMI_Skin CAMI_Urogenital_tract
do
    echo $ds
    OUTPATH=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/CAMI_II/${ds}/CommonKmers/
    INPATH=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/CAMI_II/${ds}/CommonKmers/input
    mkdir -p ${OUTPATH}
    mkdir -p ${INPATH}

    for s in ${cami2_path}/${ds}/short_read/*sample*/reads/anonymous_reads.fq.gz
    do
        sname=`rev <<< $s | cut -f3 -d'/' | cut -f-2 -d '_' | rev`
        ln -s ${s} ${INPATH}/${sname}.fq.gz
    done
    ls ${INPATH}/*.fq.gz > ${INPATH}/sample.fq.gz.list
    
    docker run --rm -e "QUALITY=C" -e "DCKR_THREADS=48" \
    -v /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/git/CommonKmers/CommonKmersData:/dckr/mnt/camiref/CommonKmersData:ro \
    -v ${OUTPATH}:/dckr/mnt/output:rw \
    -v ${INPATH}:/dckr/mnt/input:ro \
    -v ${cami2_path}/${ds}/:${cami2_path}/${ds}/:ro \
    -it dkoslicki/commonkmers default

    fn=`date +%s`
    zcat ${cami2_path}/${ds}/short_read/*${s}/reads/anonymous_reads.fq.gz > /shares/CIBIO-Storage/CM/tmp/${fn}.fq
    gottcha.pl --input /shares/CIBIO-Storage/CM/tmp/${fn}.fq \
        --outdir ${OUTPATH}/${s} \
        --threads 10 \
        --dbLevel species \
        --database ${DB_DIR}/GOTTCHA_BACTERIA_c4937_k24_u30_xHUMAN3x.species
    rm /shares/CIBIO-Storage/CM/tmp/${fn}.fq
    done
done

cami2_path_mouse=/shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets/CAMISIM_MOUSEGUT/19122017_mousegut_scaffolds/
OUTPATH=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/CAMI_II/CAMISIM_MOUSEGUT/GOTTCHA/
mkdir -p ${OUTPATH}
ls -d ${cami2_path_mouse}/*sample*/ | xargs -n1 basename | rev | cut -f1,2 -d '_' | rev | parallel -j 6 "fn=`date +%s`; \
