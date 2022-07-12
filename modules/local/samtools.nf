process SAM2BAM{
  scratch true
  publishDir "prepare/bam"
  cpus 2
  time 2.h
  container "biocontainers/samtools:v1.7.0_cv4"

  input:
  tuple val(x), path(sam)
  output:
  tuple val(x), path("*.sorted.bam") , emit:sortbam
  path("*.sorted.bam"), emit:single_bam
  path("reads.txt") , emit:nreads
  //tuple val(x.id), path("out.txt"), emit:nreads
  script:
  """
  samtools view --threads 2 \\
      -S -b ${sam} > ${x.id}.bam
  samtools sort --threads 2 \\
      ${x.id}.bam > ${x.id}.sorted.bam
  samtools view -c -F 260 ${x.id}.bam > out.txt
  printf '%s\\t%s\\n' ${x.id} \$(cat out.txt) > reads.txt
  """
}
