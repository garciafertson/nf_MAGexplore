process COVERAGE_METRICS {
  container "biopython/biopython:latest"
  publishDir "output"
  cpus 1
  time '2h'

  input:
    tuple val(x), path(bedcov), val(gp), val(bp)
  output:
    path("coverage_stats.csv") , emit: csv
  script:
    """
    coverage_metrics.py \\
    --gp_fraction $gp \\
    --bp_fraction $bp \\
    --bedcoverage $bedcov --sample ${x.id}
    """
}

process COV_MATRIX {
    container "biopython/biopython:latest"
    publishDir "output",
      mode: "copy"
    cpus 1
    time '2h'

    input:
      path(csv)
    output:
      path("*Coverage_table.csv") , emit: coverage
      path("*Presence_table.csv") , emit: presence
      path("*TPM_table.csv")     , emit: tpm
      path("*RPKM_table.csv")    , emit: rpkm
    script:
      """
      dataframe2matrix.py --coverage_stats $csv
      """

}
