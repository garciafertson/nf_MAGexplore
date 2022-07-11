
process METAPOP {
  //scratch true
  cpus params.metapopcores
  time '5h'
  container "quay.io/biocontainers/metapop:1.0.2--0"
  publishDir "output",
     mode: "copy"
  //module 'bioinfo-tools:fastp'

  input:
    path(bamdir)
    path (contigs)
    path (genes)
    path(lib_count)
  output:
    path("output/*") , emit: macrodiversirty
  script:
  """
  mkdir bamfiles
  mv *.bam bamfiles/.
  MetaPop.R -dir bamfiles \\
          -assem \$PWD/$contigs \\
          -genes \$PWD/$genes \\
          -ct \$PWD/$lib_count \\
          -dep 1 \\
          -min_bp 1000 \\
          -id 90 \\
          -cov 20 \\
          -threads ${params.metapopcores}
  """
}
