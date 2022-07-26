//Import subworkflows
include { PREPARE } from  "../subworkflows/prepare"
include { RUN_ABUNDANCE }      from "../subworkflows/run_abundance"

workflow MAG_ABUNDANCE{
  if (params.build_bowtie2index){
    Channel
      .fromPath(params.mags_folder, type: 'dir')
      .set {mags_folder}
    PREPARE(mags_folder)
    //Rertun database path in params variable and run METAPOP
    bowtie_index=PREPARE.out.bowtie2index
    genesbed=PREPARE.out.genesbed
    genomebed=PREPARE.out.genomebed
    markerbed=PREPARE.out.markerbed

  }else if(params.run_metapop){
    Channel
      .fromPath(["prepare/bowtieindex/mags_bowtieindex*"])
      .toList()
      .set{bowtie_index}
    Channel
      .fromPath("prepare/genes.bed")
      .set{genesbed}
    Channel
      .fromPath("prepare/contigs.genome.bed")
      .set{genomebed}
    Channel
      .fromPath("prepare/marker.bed")
      .set{markerbed}

    RUN_ABUNDANCE(bowtie_index,genesbed,genomebed, markerbed)
  }
}
