
def sorted_files
Channel.fromPath("${params.vcf_dir}/*.vcf.gz")
    .toSortedList()
    .subscribe { sorted_files = it }

Channel.fromList(sorted_files)
    .take( 3 )
    .set { ch_files }


process bcftools_sort {
    label 'bcftools'
    publishDir "${params.outdir}", mode: 'copy'

    input:
    file(ingvcf) from ch_files

    output:
    file("${ingvcf.simpleName}.bcf") into ch_bcf_files

    script:
    """
    bcftools sort --temp-dir . --output-type u --max-mem ${params.sort_mem} --output ${ingvcf.simpleName}.bcf ${ingvcf}
    """

}