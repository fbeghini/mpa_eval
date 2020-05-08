cami2_path=/shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets/

for ds in CAMI_Airways CAMI_Gastrointestinal_tract CAMI_Oral CAMI_Skin CAMI_Urogenital_tract
do
    echo $ds
    OUTPATH=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/CAMI_II/${ds}/mpa2_v25/
    mkdir -p ${OUTPATH}
    for s in `ls -d ${cami2_path}/${ds}/short_read/*sample* | xargs -n1 basename | rev | cut -f1,2 -d '_' | rev`
    do
        (/shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py  \
        --input_type fastq \
        --nproc 6 \
        --index latest \
        --bowtie2out ${OUTPATH}/${s}.bowtie2 \
        -s ${OUTPATH}/${s}.sam \
        --sample_id ${s/sample_/} \
        --output_file ${OUTPATH}/${s}.orig \
        --no-unknown-estimation \
        ${cami2_path}/${ds}/short_read/*${s}/reads/anonymous_reads.fq.gz )
    done
done

cami2_path_mouse=/shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets/CAMISIM_MOUSEGUT/19122017_mousegut_scaffolds/
OUTPATH=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/CAMI_II/MOUSEGUT/mpa2_v25/
mkdir -p ${OUTPATH}
for s in `ls -d ${cami2_path_mouse}/*sample*/ | xargs -n1 basename | rev | cut -f1,2 -d '_' | rev`
do
    (/shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py  \
    --input_type fastq \
    --nproc 6 \
    --index latest \
    --bowtie2out ${OUTPATH}/${s}.bowtie2 \
    -s ${OUTPATH}/${s}.sam \
    --sample_id ${s/sample_/} \
    --output_file ${OUTPATH}/${s}.orig \
    --no-unknown-estimation \
    ${cami2_path_mouse}/*${s}/reads/anonymous_reads.fq.gz )
done


for ds in CAMI_Airways CAMI_Gastrointestinal_tract CAMI_Oral CAMI_Skin CAMI_Urogenital_tract
do
    echo $ds
    OUTPATH=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/CAMI_II/${ds}/mpa2_v25/
    mkdir -p ${OUTPATH}
    for s in `ls -d ${cami2_path}/${ds}/short_read/*sample* | xargs -n1 basename | rev | cut -f1,2 -d '_' | rev`
    do
        (/shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py  \
        --input_type bowtie2out \
        --nproc 6 \
        --index latest \
        --sample_id ${s/sample_/} \
        --output_file ${OUTPATH}/${s}.orig.unknown \
        ${OUTPATH}/${s}.bowtie2 ) &
    done
done

cami2_path_mouse=/shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets/CAMISIM_MOUSEGUT/19122017_mousegut_scaffolds/
OUTPATH=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/CAMI_II/CAMISIM_MOUSEGUT/mpa2_v25/
mkdir -p ${OUTPATH}
for s in `ls -d ${cami2_path_mouse}/*sample*/ | xargs -n1 basename | rev | cut -f1,2 -d '_' | rev`
do
    (/shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py  \
    --input_type bowtie2out \
    --nproc 6 \
    --index latest \
    --bowtie2out ${OUTPATH}/${s}.bowtie2 \
    --sample_id ${s/sample_/} \
    --output_file ${OUTPATH}/${s}.orig.unknown \
    ${OUTPATH}/${s}.bowtie2 ) &
done