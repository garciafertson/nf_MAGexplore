process CATMAGS{
  scratch true
  cpus '1'
  time '1h'
  publishDir "prepare", mode: 'copy'
  container "biopython/biopython:latest"
  //module 'bioinfo-tools:fastp'

  input:
    path(mags_folder)
  output:
    path(params.contigs_file), emit: contigs
    path(params.contigs_genomebed), emit:genomebed
  script:
  """
  concat_mags.py --mags_folder $launchDir/$params.mags_folder \\
                    --out_contigs $params.contigs_file \\
                    --out_genomebed $params.contigs_genomebed
  sort -k1,1V $params.contigs_genomebed > tmp
  mv tmp $params.contigs_genomebed
  """
  }
