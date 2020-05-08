#!/bin/bash
wd=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/CAMI_II
mg_folder=/shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets/
OPAL_outfolder=opal_out/CAMI_II/

mkdir -p ${OPAL_outfolder}

for dataset in CAMI_Airways CAMI_Gastrointestinal_tract CAMI_Oral CAMI_Skin CAMI_Urogenital_tract
do
    cat ${wd}/${dataset}/mpa2_v294_201901/*.cami > ${wd}/${dataset}/mpa294_statq0_1
    cat ${wd}/${dataset}/mpa2_v294_201901/statq_0.125/*.cami > ${wd}/${dataset}/mpa294_statq0_125
    cat ${wd}/${dataset}/mpa2_v294_201901/statq_0.15/*.cami > ${wd}/${dataset}/mpa294_statq0_15
    cat ${wd}/${dataset}/mpa2_v294_201901/statq_0.175/*.cami > ${wd}/${dataset}/mpa294_statq0_175
    cat ${wd}/${dataset}/mpa2_v294_201901/statq_0.2/*.cami > ${wd}/${dataset}/mpa294_statq0_2
    cat ${wd}/${dataset}/mpa2_v294_201901/statq_0.225/*.cami > ${wd}/${dataset}/mpa294_statq0_225
    cat ${wd}/${dataset}/mpa2_v294_201901/statq_0.25/*.cami > ${wd}/${dataset}/mpa294_statq0_25
    cat ${wd}/${dataset}/mpa2_v294_201901/statq_0.275/*.cami > ${wd}/${dataset}/mpa294_statq0_275
    cat ${wd}/${dataset}/mpa2_v294_201901/statq_0.3/*.cami > ${wd}/${dataset}/mpa294_statq0_3
    
    # cat ${mg_folder}/${dataset}/short_read/taxonomic_profile*.txt > ${wd}/${dataset}/${dataset}_gold_standard.txt

    docker \
    run --rm \
        -u ${UID} \
        -v /shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval:/fbeghini_CAMIEval opal:latest \
        opal.py -g /fbeghini_CAMIEval/CAMI_II/${dataset}/${dataset}_gold_standard.txt \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa294_statq0_125 \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa294_statq0_15 \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa294_statq0_175 \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa294_statq0_2 \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa294_statq0_225 \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa294_statq0_25 \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa294_statq0_275 \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa294_statq0_3 \
            -o /fbeghini_CAMIEval/${OPAL_outfolder}/${dataset}_statq &    
done

dataset=CAMISIM_MOUSEGUT
# for sample in `ls ${wd}/${dataset}/mpa2_v25_201901/*.orig`
# do 
#     python3 -c 'from convertMetaphlan2 import convertNewMetaphlan2; from sys import argv; convertNewMetaphlan2(argv[1])' $sample
# done

# cat ${wd}/${dataset}/bracken_output/*.profile | sed 's/@SampleID:sample_/@SampleID:/g' > ${wd}/${dataset}/Bracken_refseq
# cat ${wd}/${dataset}/bracken_output_minikraken/*.profile | sed 's/@SampleID:sample_/@SampleID:/g' > ${wd}/${dataset}/Bracken_minikraken
# cat ${wd}/${dataset}/mOTUs2_output/*.motus | sed 's/@SampleID: sample_/@SampleID:/g' > ${wd}/${dataset}/mOTUs2
# cat ${wd}/${dataset}/mpa2_v20/*.profile | sed 's/{}//g' > ${wd}/${dataset}/mpa20
# cat ${wd}/${dataset}/mpa2_v25_201901/*.profile > ${wd}/${dataset}/mpa2_201901
# cat ${wd}/${dataset}/mpa2_v293_201901/*.cami > ${wd}/${dataset}/mpa293_201901
# cat ${wd}/${dataset}/mpa2_v294_201901/*.cami > ${wd}/${dataset}/mpa294_201901
cat ${wd}/${dataset}/mpa2_v294_201901_variants/*.cami > ${wd}/${dataset}/mpa294_201901_variants
# cat ${wd}/${dataset}/mpa2_v292_201901/*.cami.filt > ${wd}/${dataset}/mpa292_201901_mapqfilt10
# cat ${wd}/${dataset}/mpa2_v292_201901/*.cami.filt1 > ${wd}/${dataset}/mpa292_201901_mapqfilt1
# cat ${wd}/${dataset}/mpa2_v292_201901/*.cami.filt3 > ${wd}/${dataset}/mpa292_201901_mapqfilt3
# cat ${wd}/${dataset}/mpa2_v292_201901/*.cami.filt5 > ${wd}/${dataset}/mpa292_201901_mapqfilt5
# cat ${wd}/${dataset}/CLARK/*.profile | sed 's/@SampleID:sample_/@SampleID:/g' > ${wd}/${dataset}/clark

# cp ${wd}/../OPAL/cami_ii_mg/metaphlan2.profile ${wd}/${dataset}/mpa2_opal_paper
# cat ${mg_folder}/${dataset}/19122017_mousegut_scaffolds/taxonomic_profile_*.txt > ${wd}/${dataset}/${dataset}_gold_standard.txt

docker \
run --rm \
    -u ${UID} \
    -v /shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval:/fbeghini_CAMIEval opal:latest \
    opal.py -g /fbeghini_CAMIEval/CAMI_II/${dataset}/${dataset}_gold_standard.txt \
        /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa20 \
        /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa2_201901 \
        /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa293_201901 \
        /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa294_201901 \
        /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa294_201901_variants \
        /fbeghini_CAMIEval/CAMI_II/${dataset}/mOTUs2 \
	    /fbeghini_CAMIEval/CAMI_II/${dataset}/clark \
        /fbeghini_CAMIEval/CAMI_II/${dataset}/Bracken_refseq \
        /fbeghini_CAMIEval/CAMI_II/${dataset}/Bracken_minikraken \
        -o /fbeghini_CAMIEval/${OPAL_outfolder}/${dataset}
