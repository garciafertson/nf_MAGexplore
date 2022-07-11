process FASTP{
  //scratch true
  cpus '2'
  time '5h'
  container "biocontainers/fastp:v0.19.6dfsg-1-deb_cv1"
  //module 'bioinfo-tools:fastp'

  input:
    tuple val(x), path(reads)
  output:
    tuple val(x), path("${x.id}.*.trim.fq.gz"), emit: reads
  script:
    if(x.single_end) {
      """
      fastp -i ${reads} \\
            -o ${x.id}.R1.trim.fq.gz \\
            --thread 1
      """
    }else {
      """
      fastp --in1 ${reads[0]} \\
            --in2 ${reads[1]} \\
            --out1 "${x.id}.R1.trim.fq.gz" \\
            --out2 "${x.id}.R2.trim.fq.gz" \\
            --thread 2
      """
    }
}
