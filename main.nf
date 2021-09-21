
Channel.fromPath("${params.vcf_dir}/**.vcf.gz")
    .take( 3 )
    .set { ch_files }


process bcftools_sort {
    label 'bcftools'
    publishDir "output", mode: 'copy'

    input:
    set file(ingvcf) from ch_files

    output:
    file(outbcf) into bcf_files

    script:
    """
    bcftools sort --temp-dir . --output-type u --max-mem 1.0G --output ${outbcf} ${ingvcf}
    """

}