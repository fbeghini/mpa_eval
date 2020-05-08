#Threshold markers non-zero 0.33, stat_q 0.1, default
for mock in 'samples-50M-mix-human-nothuman' '50M_SyntheticMetagenomesAna'
do
    /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py \
        --input_type bowtie2out \
        --nproc 20 \
        --index v24_CHOCOPhlAn_0.2 \
        --output_file mpa_v24/sample_uni_default.orig \
        --no-unknown-estimation \
        /shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/${mock}/mpa_v24/sample_uni.bowtie2

    /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py \
        --input_type bowtie2out \
        --nproc 20 \
        --index v24_CHOCOPhlAn_0.2 \
        --output_file mpa_v24/sample_ln_default.orig \
        --no-unknown-estimation \
        /shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/${mock}/mpa_v24/sample_ln.bowtie2

    /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py \
        --input_type bowtie2out \
        --nproc 20 \
        --index v25_CHOCOPhlAn_0.21 \
        --output_file mpa_v25/sample_uni_default.orig \
        --no-unknown-estimation \
        /shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/${mock}/mpa_v25/sample_uni.bowtie2

    /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py \
        --input_type bowtie2out \
        --nproc 20 \
        --index v25_CHOCOPhlAn_0.21 \
        --output_file mpa_v25/sample_ln_default.orig \
        --no-unknown-estimation \
        /shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/${mock}/mpa_v25/sample_ln.bowtie2
done

#Threshold markers non-zero 0.2, stat_q 0.1
for mock in 'samples-50M-mix-human-nothuman' '50M_SyntheticMetagenomesAna'
do
    /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py \
        --input_type bowtie2out \
        --nproc 20 \
        --index v24_CHOCOPhlAn_0.2 \
        --output_file mpa_v24/sample_uni_0201.orig \
        --no-unknown-estimation \
        --perc_nonzero 0.2 \
        /shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/${mock}/mpa_v24/sample_uni.bowtie2

    /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py \
        --input_type bowtie2out \
        --nproc 20 \
        --index v24_CHOCOPhlAn_0.2 \
        --output_file mpa_v24/sample_ln_0201.orig \
        --no-unknown-estimation \
        --perc_nonzero 0.2 \
        /shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/${mock}/mpa_v24/sample_ln.bowtie2

    /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py \
        --input_type bowtie2out \
        --nproc 20 \
        --index v25_CHOCOPhlAn_0.21 \
        --output_file mpa_v25/sample_uni_0201.orig \
        --no-unknown-estimation \
        --perc_nonzero 0.2 \
        /shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/${mock}/mpa_v25/sample_uni.bowtie2

    /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py \
        --input_type bowtie2out \
        --nproc 20 \
        --index v25_CHOCOPhlAn_0.21 \
        --output_file mpa_v25/sample_ln_0201.orig \
        --no-unknown-estimation \
        --perc_nonzero 0.2 \
        /shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/${mock}/mpa_v25/sample_ln.bowtie2
done

#Threshold markers non-zero 0.2, stat_q 0.2
for mock in 'samples-50M-mix-human-nothuman' '50M_SyntheticMetagenomesAna'
do
    /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py \
        --input_type bowtie2out \
        --nproc 20 \
        --index v24_CHOCOPhlAn_0.2 \
        --output_file mpa_v24/sample_uni_0202.orig \
        --stat_q 0.2 \
        --no-unknown-estimation \
        --perc_nonzero 0.2 \
        /shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/${mock}/mpa_v24/sample_uni.bowtie2

    /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py \
        --input_type bowtie2out \
        --nproc 20 \
        --index v24_CHOCOPhlAn_0.2 \
        --output_file mpa_v24/sample_ln_0202.orig \
        --stat_q 0.2 \
        --no-unknown-estimation \
        --perc_nonzero 0.2 \
        /shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/${mock}/mpa_v24/sample_ln.bowtie2

    /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py \
        --input_type bowtie2out \
        --nproc 20 \
        --index v25_CHOCOPhlAn_0.21 \
        --output_file mpa_v25/sample_uni_0202.orig \
        --stat_q 0.2 \
        --no-unknown-estimation \
        --perc_nonzero 0.2 \
        /shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/${mock}/mpa_v25/sample_uni.bowtie2

    /shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/metaphlan2_dev/metaphlan2.py \
        --input_type bowtie2out \
        --nproc 20 \
        --index v25_CHOCOPhlAn_0.21 \
        --output_file mpa_v25/sample_ln_0202.orig \
        --stat_q 0.2 \
        --no-unknown-estimation \
        --perc_nonzero 0.2 \
        /shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/${mock}/mpa_v25/sample_ln.bowtie2
done