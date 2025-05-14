process PARSE_FASTP_REPORTS {
    tag "$sample_name"
    label 'process_low'

    container "quay.io/biocontainers/python:3.8.3"

    input:
    tuple val(sample_name), path(json_file)

    output:
    path("*.tsv")      , emit: tsv_path
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """

    parse_filter.py -i $json_file -o $params.outdir

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Python: \$(python --version 2>&1 | sed 's/Python //;')
    END_VERSIONS

    """
}
