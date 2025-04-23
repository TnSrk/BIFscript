InputName=$1
bash gatk_haplotypeCaller.sh $InputName
bash gatk_variantFiltration.sh $InputName
bash gatk4_VCF_normalliz.sh $InputName
sed -i 's/^NC_063383/NC_063383.1/' $InputName.filtered.normalized.vcf
bash gatk4_snpeff.sh $InputName
sed -i 's/^NC_063383.1/NC_063383/' $InputName.filtered.normalized.snpeffed.vcf
