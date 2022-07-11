process GFF2BED {
    cpus 1
    container "brodyj/bedops:latest"
    publishDir "prepare",
      mode: "copy"
    time "4h"

    input:
      path(gff)
    output:
      path("genes.bed"), emit: genesbed
    script:
      """
      gff2bed < $gff > genes.bed
      sort -k1,1V -k2,2n -k3,3n genes.bed > tmp && mv tmp genes.bed
      cut -f 1-4 genes.bed > tmp && mv tmp genes.bed
      """
}

process GENOMEBED {
  cpus 1
  container "biopython/biopython:latest"
  publishDir "prepare",
    mode: "copy"
  time "4h"

  input:
    path(bed)
  output:
    path("contigs.genome.bed"), emit: genomebed
  script:
    """
    genomebed.py $bed
    """
}
