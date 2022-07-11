process PRODIGAL{
  //scratch true
  cpus 1
  container "metashot/prodigal:2.6.3-1"
  publishDir "prepare",
    mode: "copy"
  time "4h"

  input:
    path(contigs)
  output:
    path("genes.fasta"), emit: genes
    path("genes.gff") , emit: gff
  script:
    """
    prodigal -i $contigs  \\
          -d genes.fasta \\
          -f gff \\
          -c -m > genes.gff
    """
}
