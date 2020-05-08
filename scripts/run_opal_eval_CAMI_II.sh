#!/bin/bash
wd=/shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval/CAMI_II
mg_folder=/shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets/
OPAL_outfolder=opal_out/CAMI_II/

# for sample in `ls ${wd}/*/*/*.orig*`
# do 
#     python3 -c 'from convertMetaphlan2 import convertNewMetaphlan2; from sys import argv; convertNewMetaphlan2(argv[1])' $sample
# done
# python3 -c 'from convertMetaphlan2 import convertBracken; from sys import argv; convertBracken(argv[1:])' `ls ${wd}/*/bracken_output*/*.bracken`
# python3 -c 'from convertMetaphlan2 import convertBracken; from sys import argv; convertBracken(argv[1:])' `ls ${wd}/*/bracken_output_minikraken*/*.bracken`
python3 -c 'from convertMetaphlan2 import convertBracken; from sys import argv; convertBracken(argv[1:])' `ls ${wd}/*/bracken_output_208_25/*.bracken`
# python3 -c 'from convertMetaphlan2 import convertMetaphlan2; from sys import argv; convertMetaphlan2(argv[1:])' `ls ${wd}/*/mpa2_v20/*.orig`
# python3 -c 'from convertMetaphlan2 import convertCLARK; from sys import argv; convertCLARK(argv[1:])' `ls ${wd}/*/CLARK/*.clarkres`
# python3 -c 'from convertMetaphlan2 import convertGOTTCHA; from sys import argv; convertGOTTCHA(argv[1:])' `ls ${wd}/*/GOTTCHA/*/*.gottcha.tsv`
mkdir -p ${OPAL_outfolder}

for dataset in CAMI_Airways CAMI_Gastrointestinal_tract CAMI_Oral CAMI_Skin CAMI_Urogenital_tract
do
    # ls ${wd}/${dataset}/bracken_output/*.profile | grep -v t10 | xargs cat | sed 's/@SampleID:sample_/@SampleID:/g' > ${wd}/${dataset}/Bracken_refseq
    cat ${wd}/${dataset}/bracken_output_208_25/*.profile | sed 's/@SampleID:sample_/@SampleID:/g' > ${wd}/${dataset}/Bracken_208_25_refseq
    # ls ${wd}/${dataset}/bracken_output_minikraken/*.profile | grep -v t10 | xargs cat | sed 's/@SampleID:sample_/@SampleID:/g' > ${wd}/${dataset}/Bracken_minikraken
    # cat ${wd}/${dataset}/bracken_output_minikraken/*.t10_bracken.profile | sed 's/@SampleID:sample_/@SampleID:/g' > ${wd}/${dataset}/Bracken_t10_minikraken
    # cat ${wd}/${dataset}/mOTUs2_output/*.precision.motus | sed 's/@SampleID: sample_/@SampleID:/g' > ${wd}/${dataset}/mOTUs2_precision
    # cat ${wd}/${dataset}/mOTUs2_output/*.motus.recall | sed 's/@SampleID: sample_/@SampleID:/g' > ${wd}/${dataset}/mOTUs2_recall
    # cat ${wd}/${dataset}/mOTUs2_output/*.parenthesis.motus | sed 's/@SampleID: sample_/@SampleID:/g' > ${wd}/${dataset}/mOTUs2_parenthesis
    cat ${wd}/${dataset}/mOTUs251_output/*.precision.motus | sed 's/@SampleID: sample_/@SampleID:/g' > ${wd}/${dataset}/mOTUs251_precision
    cat ${wd}/${dataset}/mOTUs251_output/*.recall.motus | sed 's/@SampleID: sample_/@SampleID:/g' > ${wd}/${dataset}/mOTUs251_recall
    cat ${wd}/${dataset}/mOTUs251_output/*.parenthesis.motus | sed 's/@SampleID: sample_/@SampleID:/g' > ${wd}/${dataset}/mOTUs251_parenthesis
    # cat ${wd}/${dataset}/mpa2_v20/*.profile | sed 's/{}//g' > ${wd}/${dataset}/mpa20
    # cat ${wd}/${dataset}/mpa2_v25_201901/*.profile > ${wd}/${dataset}/mpa2_201901
    #cat ${wd}/${dataset}/mpa2_v293_201901/*.cami > ${wd}/${dataset}/mpa293_201901
    # cat ${wd}/${dataset}/mpa2_v294_201901/*.cami > ${wd}/${dataset}/mpa294_201901
    # cat ${wd}/${dataset}/mpa2_v296_201901/*.cami > ${wd}/${dataset}/mpa2_v296
    # cat ${wd}/${dataset}/mpa2_v296_201901/*_025.profile > ${wd}/${dataset}/mpa2_v296_statq025
    # # cat ${wd}/${dataset}/CLARK/*.profile | sed 's/@SampleID:sample_/@SampleID:/g' > ${wd}/${dataset}/clark
    # cat ${wd}/${dataset}/GOTTCHA/*/*.profile | sed 's/@SampleID:sample_/@SampleID:/g' > ${wd}/${dataset}/gottcha
    
    # cat ${mg_folder}/${dataset}/short_read/taxonomic_profile*.txt > ${wd}/${dataset}/${dataset}_gold_standard.txt

    docker \
    run --rm \
        -u ${UID} \
        -v /shares/CIBIO-Storage/CM/mir/projects/fbeghini_CAMIEval:/fbeghini_CAMIEval opal:latest \
        opal.py -g /fbeghini_CAMIEval/CAMI_II/${dataset}/${dataset}_gold_standard.txt \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa20 \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa2_201901 \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa292_201901 \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa293_201901 \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa294_201901 \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa2_v296 \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa2_v296_statq025 \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/mOTUs2_precision \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/mOTUs2_recall \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/mOTUs2_parenthesis \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/mOTUs251_precision \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/mOTUs251_recall \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/mOTUs251_parenthesis \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/clark \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/Bracken_refseq \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/Bracken_208_25_refseq \
            /fbeghini_CAMIEval/CAMI_II/${dataset}/Bracken_minikraken \
            -o /fbeghini_CAMIEval/${OPAL_outfolder}/${dataset} &    
done

dataset=CAMISIM_MOUSEGUT
# for sample in `ls ${wd}/${dataset}/mpa2_v25_201901/*.orig`
# do 
#     python3 -c 'from convertMetaphlan2 import convertNewMetaphlan2; from sys import argv; convertNewMetaphlan2(argv[1])' $sample
# done

# cat ${wd}/${dataset}/bracken_output/*.profile | sed 's/@SampleID:sample_/@SampleID:/g' > ${wd}/${dataset}/Bracken_refseq
cat ${wd}/${dataset}/bracken_output_208_25/*.profile | sed 's/@SampleID:sample_/@SampleID:/g' > ${wd}/${dataset}/Bracken_208_25_refseq
# cat ${wd}/${dataset}/bracken_output_minikraken/*.profile | sed 's/@SampleID:sample_/@SampleID:/g' > ${wd}/${dataset}/Bracken_minikraken
# cat ${wd}/${dataset}/mOTUs2_output/*.motus | sed 's/@SampleID: sample_/@SampleID:/g' > ${wd}/${dataset}/mOTUs2
cat ${wd}/${dataset}/mOTUs251_output/*.precision.motus | sed 's/@SampleID: sample_/@SampleID:/g' > ${wd}/${dataset}/mOTUs251_precision
cat ${wd}/${dataset}/mOTUs251_output/*.recall.motus | sed 's/@SampleID: sample_/@SampleID:/g' > ${wd}/${dataset}/mOTUs251_recall
cat ${wd}/${dataset}/mOTUs251_output/*.parenthesis.motus | sed 's/@SampleID: sample_/@SampleID:/g' > ${wd}/${dataset}/mOTUs251_parenthesis
# cat ${wd}/${dataset}/mpa2_v20/*.profile | sed 's/{}//g' > ${wd}/${dataset}/mpa20
# cat ${wd}/${dataset}/mpa2_v25_201901/*.profile > ${wd}/${dataset}/mpa2_201901
# cat ${wd}/${dataset}/mpa2_v293_201901/*.cami > ${wd}/${dataset}/mpa293_201901
# cat ${wd}/${dataset}/mpa2_v294_201901/*.cami > ${wd}/${dataset}/mpa294_201901
cat ${wd}/${dataset}/mpa2_v296_201901/*.cami > ${wd}/${dataset}/mpa296_201901
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
        /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa291_201901 \
        /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa293_201901 \
        /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa294_201901 \
        /fbeghini_CAMIEval/CAMI_II/${dataset}/mpa296_201901 \
        /fbeghini_CAMIEval/CAMI_II/${dataset}/mOTUs2 \
	    /fbeghini_CAMIEval/CAMI_II/${dataset}/clark \
        /fbeghini_CAMIEval/CAMI_II/${dataset}/Bracken_refseq \
        /fbeghini_CAMIEval/CAMI_II/${dataset}/Bracken_minikraken \
        -o /fbeghini_CAMIEval/${OPAL_outfolder}/${dataset}
