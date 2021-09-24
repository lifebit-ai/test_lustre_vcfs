ch_files = Channel.create()

Channel.fromPath("${params.vcf_dir}/*.vcf.gz")
    .toSortedList()
    .subscribe onNext: { items ->
        items.each { ch_files << it }
    },
    onComplete: { ch_files.close() }

ch_files2 = ch_files.take(params.file_count)

process bcftools_sort {
    label 'bcftools'
    publishDir "${params.outdir}", mode: 'copy'

    input:
    file(ingvcf) from ch_files2

    output:
    file("${ingvcf.simpleName}.bcf") into ch_bcf_files

    script:
    """
    ${params.before_cmd}
    bcftools sort --temp-dir ${ingvcf.simpleName} --output-type u --max-mem ${params.sort_mem} --output ${ingvcf.simpleName}.bcf ${ingvcf}
    ${params.after_cmd}
    """

}
