cami2_path=/shares/CIBIO-Storage/CM/scratch/data/meta/CAMI_datasets/

for ds in CAMI_Airways CAMI_Gastrointestinal_tract CAMI_Oral CAMI_Skin CAMI_Urogenital_tract
do
    for s in `ls -d ${cami2_path}/${ds}/short_read/taxonomic_profile_*.txt`
    do
        paste \
        <(sort -k1 -t$'\t' ${cami2_path}/${ds}/short_read/genome_to_id.tsv -V ) \
        <( grep -P '\tstrain\t' $s | cut -f3,4,6 | sort -k3 -t$'\t' -V) -- | cut -f2-4 | sed 's/\/net.*\/GCA/GCA/g' > ${s}.genome_taxonomy
    done
done

ds=CAMISIM_MOUSEGUT
for s in `ls -d ${cami2_path}/${ds}/19122017_mousegut_scaffolds/taxonomic_profile_*.txt`
do
    paste \
        <(sort -k1 -t$'\t' ${cami2_path}/${ds}/19122017_mousegut_scaffolds/genome_to_id.tsv -V ) \
        <( grep -P '\tstrain\t' $s | cut -f3,4,6 | sort -k3 -t$'\t' -V) -- | cut -f2-4 | sed 's/\/net.*\/GCF/GCF/g' > ${s}.genome_taxonomy
done