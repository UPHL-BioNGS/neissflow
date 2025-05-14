process GUBBINS {
    label 'process_high'

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'staphb/gubbins:3.3.5' :
        'staphb/gubbins:3.3.5' }"

    input:
    path(clean_full_aln)

    output:
    path '*.filtered_polymorphic_sites.phylip', emit: phylip
    path '*.filtered_polymorphic_sites.fasta' , emit: fasta
    path '*.recombination_predictions.gff'    , emit: gff
    path '*.recombination_predictions.embl'   , emit: pred_embl
    path '*.branch_base_reconstruction.embl'  , emit: base_recon_embl
    path '*.summary_of_snp_distribution.vcf'  , emit: vcf 
    path '*.final_tree.tre'                   , emit: tre
    path '*.node_labelled.final_tree.tre'     , emit: node_tre
    //path '*.log'                              , emit: log
    path '*.per_branch_statistics.csv'        , emit: csv
    path "versions.yml"                       , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    export NUMBA_CACHE_DIR=/tmp
    file=$clean_full_aln
    name=\${file%%.clean.full.aln}
    run_gubbins.py -c ${task.cpus} -i ${params.max_itr} -u -p \$name -t raxml $clean_full_aln

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        gubbins: \$(run_gubbins.py --version 2>&1)
    END_VERSIONS

    """
}
