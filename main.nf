
ch_files = Channel.create()

Channel.fromPath("${params.vcf_dir}/*.vcf.gz")
    .toSortedList()
    .subscribe { list ->
        list.each { ch_files << it }
    }

ch_files2 = ch_files.take(3)

process bcftools_sort {
    label 'bcftools'
    publishDir "${params.outdir}", mode: 'copy'

    input:
    file(ingvcf) from ch_files2

    output:
    file("${ingvcf.simpleName}.bcf") into ch_bcf_files

    script:
    """
    bcftools sort --temp-dir . --output-type u --max-mem ${params.sort_mem} --output ${ingvcf.simpleName}.bcf ${ingvcf}
    """

}