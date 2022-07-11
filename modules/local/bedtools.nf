process BEDTOOLS_COVERAGE{
  //scratch=true
  container "biocontainers/bedtools:v2.27.1dfsg-4-deb_cv1"
  publishDir "output"
  cpus 1
  time "3h"

  input:
    tuple val(x), path(bam)
    //path(genesbed), path(genomebed)

    //contig_bed file contains the gene annotatiosn from the contig.fasta file
    //genome bed contains the file with expected chromosome order
  output:
    tuple val(x), path("*coverage.bed") , emit: bedcov
  script:
    """
    bedtools bamtobed -i $bam > bam2bed.bed
    sort -k1,1V -k2,2n -k3,3n bam2bed.bed > bam2bed.sort.bed

    bedtools coverage \\
      -a $launchDir/prepare/genes.bed\\
      -b bam2bed.sort.bed \\
      -g $launchDir/prepare/contigs.genome.bed \\
      -sorted > ${x.id}.coverage.bed
    """
}
