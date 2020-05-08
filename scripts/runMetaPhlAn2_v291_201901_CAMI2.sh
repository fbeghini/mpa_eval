cami2_path=/shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets

for ds in CAMI_Skin CAMI_Gastrointestinal_tract CAMI_Airways CAMI_Oral CAMI_Urogenital_tract
do
    echo $ds
    OUTPATH=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/CAMI_II/${ds}/mpa2_v296_201901/
    mkdir -p ${OUTPATH}
    for s in `ls -d ${cami2_path}/${ds}/short_read/*sample* | xargs -n1 basename | rev | cut -f1,2 -d '_' | rev`
    do
        (/shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py  \
        --input_type fastq \
        --nproc 8 \
        --index mpa_v296_CHOCOPhlAn_201901 \
        --bowtie2db /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/chocophlan/export_201901/metaphlan2/mpa_v296_CHOCOPhlAn_201901 \
        --bowtie2out ${OUTPATH}/${s}.bowtie2 \
        -s ${OUTPATH}/${s}.sam \
        --sample_id ${s/sample_/} \
        --output_file ${OUTPATH}/${s}.orig.cami \
        --force \
        --CAMI_format_output \
        ${cami2_path}/${ds}/short_read/*${s}/reads/anonymous_reads.fq.gz ) &
    done
    wait
done

cami2_path_mouse=/shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets/CAMISIM_MOUSEGUT/19122017_mousegut_scaffolds/
OUTPATH=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/CAMI_II/CAMISIM_MOUSEGUT/mpa2_v296_201901/
mkdir -p ${OUTPATH}
for s in `ls -d ${cami2_path_mouse}/*sample*/ | xargs -n1 basename | rev | cut -f1,2 -d '_' | rev`
do
    (/shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py  \
    --input_type fastq \
    --nproc 2 \
    --bowtie2db /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/chocophlan/export_201901/metaphlan2/mpa_v296_CHOCOPhlAn_201901 \
    --index mpa_v296_CHOCOPhlAn_201901 \
    --bowtie2out ${OUTPATH}/${s}.bowtie2 \
    -s ${OUTPATH}/${s}.sam \
    --sample_id ${s/sample_/} \
    --output_file ${OUTPATH}/${s}.orig.cami \
    --force \
    --CAMI_format_output \
    ${cami2_path_mouse}/*${s}/reads/anonymous_reads.fq.gz ) &
done
wait


#### VARIABLE STATQ ####
for sq in 0.125 0.15 0.175 0.2 0.225 0.25 0.275 0.3
do
    for ds in CAMI_Skin CAMI_Gastrointestinal_tract CAMI_Airways CAMI_Oral CAMI_Urogenital_tract
    do
        echo $ds
        OUTPATH=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/CAMI_II/${ds}/mpa2_v294_201901/
        mkdir -p ${OUTPATH}/statq_${sq}
        for s in `ls -d ${cami2_path}/${ds}/short_read/*sample* | xargs -n1 basename | rev | cut -f1,2 -d '_' | rev`
        do
            (/shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py  \
            --input_type bowtie2out \
            --nproc 6 \
            --index mpa_v294_CHOCOPhlAn_201901 \
            --bowtie2db /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/chocophlan/export_201901/metaphlan2/mpa_v294_CHOCOPhlAn_201901 \
            --sample_id ${s/sample_/} \
            --output_file ${OUTPATH}/statq_${sq}/${s}.orig.cami \
            --stat_q ${sq} \
            --force \
            --CAMI_format_output \
            ${OUTPATH}/${s}.bowtie2 ) &
        done
        wait
    done
done

cami2_path_mouse=/shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets/CAMISIM_MOUSEGUT/19122017_mousegut_scaffolds/
OUTPATH=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/CAMI_II/CAMISIM_MOUSEGUT/mpa2_v294_201901/
mkdir -p ${OUTPATH}
for s in `ls -d ${cami2_path_mouse}/*sample*/ | xargs -n1 basename | rev | cut -f1,2 -d '_' | rev`
do
    (/shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py  \
    --input_type bowtie2out \
    --nproc 2 \
    --bowtie2db /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/chocophlan/export_201901/metaphlan2/mpa_v294_CHOCOPhlAn_201901 \
    --index mpa_v294_CHOCOPhlAn_201901 \
    --bowtie2out ${OUTPATH}/${s}.bowtie2 \
    -s ${OUTPATH}/${s}.sam \
    --sample_id ${s/sample_/} \
    --output_file ${OUTPATH}/${s}.orig.cami \
    --force \
    --CAMI_format_output \
    ${cami2_path_mouse}/*${s}/reads/anonymous_reads.fq.gz ) &
done
wait