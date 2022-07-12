process BOWTIE2INDEX{
  //directives for uppmax rackham
  publishDir "prepare/bowtieindex",
    mode: "copy"
  //conda "bioconda::bowtie2"
  container "biocontainers/bowtie2:v2.4.1_cv1"
  cpus params.bowtiecores
  time 6.h

  input:
    path(seqs)
  output:
    path("mags_bowtieindex*"), emit: index
  script:
    """
    bowtie2-build -f --threads 6 $seqs mags_bowtieindex
    """
}

process BOWTIE2{
  //directives
  //scratch true
  cpus params.bowtiecores
  time 6.h
  container "biocontainers/bowtie2:v2.4.1_cv1"
  //module "bioinfo-tools:bowtie2", "samtools"
  //conda "bioconda::bowtie2"

  input:
    path(index)
    tuple val(x) , path(reads)
  output:
    tuple val(x) , path("*.sam") , emit: sam
    //tuple val(x) , path("error.txt") , emit: metric
  script:
    //run bowtie. convert to bam, sort bam

  if(x.single_end){
    """
    INDEX=`find -L ./ -name "*.rev.1.bt2l" -o -name "*.rev.1.bt2" | sed 's/.rev.1.bt2l//' | sed 's/.rev.1.bt2//'`
    bowtie2 -x \$INDEX \\
            -U ${reads} \\
            -S ${x.id}.sam \\
            --threads $params.bowtiecores \\
            --no-unal \\
            --reorder
            #--met-file ${x.id}.bowtiemetric.file
    """

  } else{
    """
    INDEX=`find -L ./ -name "*.rev.1.bt2l" -o -name "*.rev.1.bt2" | sed 's/.rev.1.bt2l//' | sed 's/.rev.1.bt2//'`
    bowtie2 -x \$INDEX \\
            -1 ${reads[0]} \\
            -2 ${reads[1]} \\
            -S ${x.id}.sam \\
            --threads $params.bowtiecores \\
            --no-unal --reorder
    """
  }
}
