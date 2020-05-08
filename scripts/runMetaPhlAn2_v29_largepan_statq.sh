#Threshold markers non-zero 0.33, stat_q 0.1, default
SAMPLEPATH=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/eric_mocks/output
for mock in largepan_113913 largepan_262858 largepan_357135 largepan_521317 largepan_639964 mockeven_008139 mockeven_055086 mockeven_330123 mockeven_563092 mockeven_678180
do
    mkdir ${SAMPLEPATH}/${mock}/curated_markers
    /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py \
        --input_type fastq \
        --nproc 6 \
        --bowtie2out ${SAMPLEPATH}/${mock}/curated_markers/${mock}.bowtie2 \
        --samout ${SAMPLEPATH}/${mock}/curated_markers/${mock}.sam \
        --index mpa_v295_CHOCOPhlAn_201901 \
        --bowtie2db /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/chocophlan/export_201901/metaphlan2/mpa_v295_CHOCOPhlAn_201901_curated_markers \
        --sample_id ${mock} \
        --output_file ${SAMPLEPATH}/${mock}/curated_markers/${mock}.orig.cami \
        --force \
        ${SAMPLEPATH}/${mock}/${mock}.fq.gz &
done

for mock in largepan_113913 largepan_262858 largepan_357135 largepan_521317 largepan_639964
do
    for sq in 0.125 0.15 0.175 0.2 0.225 0.25 0.275 0.3
    do
        (/shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py  \
                --input_type bowtie2out \
                --nproc 6 \
                --bowtie2out ${SAMPLEPATH}/${mock}/${mock}.bowtie2 \
                --index mpa_v294_CHOCOPhlAn_201901 \
                --bowtie2db /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/chocophlan/export_201901/metaphlan2/mpa_v294_CHOCOPhlAn_201901 \
                --sample_id ${mock}_statq_${sq} \
                --output_file ${SAMPLEPATH}/${mock}/${mock}_statq${sq}.orig.cami \
                --stat_q ${sq} \
                --force \
                ${SAMPLEPATH}/${mock}/${mock}.bowtie2 ) &
    done
done

for sample in largepan_262858 largepan_357135 largepan_521317 largepan_639964
do
    cd ${sample}
    merge_metaphlan_tables.py ${sample}_statq0.3.orig.cami ${sample}_statq0.25.orig.cami ${sample}_statq0.2.orig.cami ${sample}_statq0.15.orig.cami ${sample}_statq0.1.orig.cami | \
    grep -E '^clade|s__' | sed 's/^.*s__//g; ' > ${sample}_merged.tsv
    cd ..
done